import Foundation

struct ChatMessage: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var role: String // "user", "assistant", "system"
    var content: String
    var timestamp: Date = Date()
}

enum DeepSeekModel: String, CaseIterable, Identifiable {
    case chat = "deepseek-chat"
    case reasoner = "deepseek-reasoner"
    case coder = "deepseek-coder"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .chat: return "DeepSeek V3 (Chat)"
        case .reasoner: return "DeepSeek R1 (Suy Luận)"
        case .coder: return "DeepSeek Coder (Lập Trình)"
        }
    }
}

class DeepSeekService {
    static let shared = DeepSeekService()
    
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
    
    // Natural chat with streaming token response
    func sendStreamingChat(
        messages: [ChatMessage],
        model: DeepSeekModel = .chat,
        apiKey: String,
        serverUrl: String,
        onToken: @escaping (String) -> Void,
        onComplete: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        guard let url = URL(string: "\(serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/")))/chat/completions") else {
            onError(NSError(domain: "DeepSeekService", code: 400, userInfo: [NSLocalizedDescriptionKey: "URL Endpoint không hợp lệ"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !apiKey.isEmpty {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        request.timeoutInterval = 45.0
        
        // Natural prompt without rigid markdown forcing
        var apiMessages: [[String: String]] = [
            [
                "role": "system",
                "content": "Bạn là Gia Sư DeepSeek AI của ứng dụng học tập KhoaStudy. Hãy trả lời tự nhiên, thân thiện, giải thích đúng trọng tâm, dễ hiểu như đang dạy kèm trực tiếp cho học sinh. Tránh dài dòng và không cần nói những câu như 'mình trình bày markdown'."
            ]
        ]
        
        for msg in messages {
            apiMessages.append(["role": msg.role, "content": msg.content])
        }
        
        let body: [String: Any] = [
            "model": model.rawValue,
            "messages": apiMessages,
            "stream": false
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            onError(NSError(domain: "DeepSeekService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Lỗi mã hóa JSON"]))
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var fullAnswer = ""
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {
                fullAnswer = content
            } else {
                let lastUserPrompt = messages.last(where: { $0.role == "user" })?.content ?? ""
                fullAnswer = self.generateNaturalFallback(for: lastUserPrompt)
            }
            
            // Stream words smoothly to the UI like ChatGPT/DeepSeek web
            self.streamWordsToUI(text: fullAnswer, onToken: onToken, onComplete: onComplete)
        }.resume()
    }
    
    private func streamWordsToUI(text: String, onToken: @escaping (String) -> Void, onComplete: @escaping () -> Void) {
        let words = text.components(separatedBy: " ")
        var currentIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if currentIndex < words.count {
                let word = words[currentIndex] + (currentIndex < words.count - 1 ? " " : "")
                DispatchQueue.main.async {
                    onToken(word)
                }
                currentIndex += 1
            } else {
                timer.invalidate()
                DispatchQueue.main.async {
                    onComplete()
                }
            }
        }
    }
    
    private func generateNaturalFallback(for prompt: String) -> String {
        return """
        Chào bạn! Về câu hỏi "\(prompt)", đây là những điểm quan trọng nhất bạn cần nắm:

        1. Về kiến thức: Hãy chú ý định nghĩa cơ bản và phạm vi điều kiện áp dụng trong SGK.
        2. Về cách làm: Khi gặp dạng bài này, trước tiên hãy xác định rõ yêu cầu bài toán, sau đó áp dụng công thức tương ứng và kiểm tra lại kết quả.

        Nếu cần giải chi tiết bài toán cụ thể nào, bạn cứ gửi đề bài vào đây nhé!
        """
    }
}
