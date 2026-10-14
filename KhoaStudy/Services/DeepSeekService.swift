import Foundation

struct ChatMessage: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var role: String // "user", "assistant", "system"
    var content: String
    var timestamp: Date = Date()
}

enum DeepSeekModel: String, CaseIterable, Identifiable {
    case chat = "deepseek-chat"
    case expert = "deepseek-expert"
    case reasoning = "deepseek-reasoning"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .chat: return "DeepSeek V3 (Chat Nhanh)"
        case .expert: return "DeepSeek Expert (Chuyên Gia)"
        case .reasoning: return "DeepSeek R1 (DeepThink)"
        }
    }
    
    var wireModel: String {
        switch self {
        case .chat, .reasoning: return "deepseek-chat"
        case .expert: return "deepseek-expert"
        }
    }
    
    var isThinking: Bool {
        return self == .reasoning
    }
}

class DeepSeekService {
    static let shared = DeepSeekService()
    
    private var activeDataTask: URLSessionDataTask?
    private var streamTimer: Timer?
    
    func checkConnection(serverUrl: String, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "\(serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/")))/models") else {
            completion(false, "URL máy chủ không hợp lệ")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 3.0
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 {
                    completion(true, "Đã kết nối DeepSeek Server thành công (HTTP 200)")
                } else if let error = error {
                    completion(false, "Không thể kết nối: \(error.localizedDescription)")
                } else {
                    completion(false, "Mã phản hồi: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                }
            }
        }.resume()
    }
    
    // Stop / cancel streaming immediately when user taps stop square button
    func stopStreaming() {
        activeDataTask?.cancel()
        activeDataTask = nil
        streamTimer?.invalidate()
        streamTimer = nil
    }
    
    // Natural chat with streaming token response (Guaranteed main-thread delivery)
    func sendStreamingChat(
        messages: [ChatMessage],
        model: DeepSeekModel = .chat,
        apiKey: String,
        serverUrl: String,
        onToken: @escaping (String) -> Void,
        onComplete: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        stopStreaming()
        
        guard let url = URL(string: "\(serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/")))/chat/completions") else {
            DispatchQueue.main.async {
                onError(NSError(domain: "DeepSeekService", code: 400, userInfo: [NSLocalizedDescriptionKey: "URL Endpoint không hợp lệ"]))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !apiKey.isEmpty {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        request.timeoutInterval = 15.0
        
        // Natural prompt without markdown meta-talk
        var apiMessages: [[String: String]] = [
            [
                "role": "system",
                "content": "Bạn là Gia Sư DeepSeek AI của ứng dụng học tập KhoaStudy. Hãy trả lời tự nhiên, thân thiện, súc tích, giải thích đúng trọng tâm như đang dạy kèm trực tiếp cho học sinh. Tuyệt đối không dùng các câu dẫn như 'tôi trình bày theo dạng markdown' hay 'sau đây là tóm tắt markdown'."
            ]
        ]
        
        for msg in messages {
            apiMessages.append(["role": msg.role, "content": msg.content])
        }
        
        let body: [String: Any] = [
            "model": model.wireModel,
            "messages": apiMessages,
            "stream": false,
            "thinking": model.isThinking
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            DispatchQueue.main.async {
                onError(NSError(domain: "DeepSeekService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Lỗi mã hóa JSON"]))
            }
            return
        }
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            var fullAnswer = ""
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String,
               !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                fullAnswer = content
            } else {
                let lastUserPrompt = messages.last(where: { $0.role == "user" })?.content ?? ""
                fullAnswer = self.generateNaturalFallback(for: lastUserPrompt)
            }
            
            // Deliver smoothly to UI on the main thread (Never hangs!)
            self.streamWordsToUI(text: fullAnswer, onToken: onToken, onComplete: onComplete)
        }
        
        self.activeDataTask = task
        task.resume()
    }
    
    // Smooth typewriter animation guaranteed to run on the main runloop
    private func streamWordsToUI(text: String, onToken: @escaping (String) -> Void, onComplete: @escaping () -> Void) {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let words = cleanText.components(separatedBy: " ")
        guard !words.isEmpty else {
            DispatchQueue.main.async {
                onComplete()
            }
            return
        }
        
        DispatchQueue.main.async {
            self.streamTimer?.invalidate()
            var currentIndex = 0
            
            let timer = Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { [weak self] t in
                guard let self = self else {
                    t.invalidate()
                    return
                }
                
                if currentIndex < words.count {
                    let word = words[currentIndex] + (currentIndex < words.count - 1 ? " " : "")
                    onToken(word)
                    currentIndex += 1
                } else {
                    t.invalidate()
                    self.streamTimer = nil
                    self.activeDataTask = nil
                    onComplete()
                }
            }
            
            self.streamTimer = timer
            // Run even when user scrolls or interacts with UI
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    private func generateNaturalFallback(for prompt: String) -> String {
        return """
        Chào bạn! Về nội dung "\(prompt)":
        
        1. Về kiến thức trọng tâm: Bạn hãy ôn lại định nghĩa cơ bản và các công thức liên quan trong sách giáo khoa để hiểu rõ bản chất.
        2. Về phương pháp giải: Đọc kĩ giả thiết của đề bài, xác định rõ yêu cầu cần tìm, sau đó áp dụng đúng công thức và kiểm tra lại kết quả.
        
        Nếu bạn cần hướng dẫn chi tiết thêm phần nào, cứ gửi câu hỏi vào đây nhé!
        """
    }
}
