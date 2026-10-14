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
        
        var targetEndpoint = "\(serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/")))/chat/completions"
        if apiKey.hasPrefix("sk-") && !serverUrl.contains("api.deepseek.com") {
            targetEndpoint = "https://api.deepseek.com/v1/chat/completions"
        }
        
        guard let url = URL(string: targetEndpoint) else {
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
        request.timeoutInterval = 45.0
        
        // Natural prompt without markdown meta-talk
        var apiMessages: [[String: String]] = [
            [
                "role": "system",
                "content": "Bạn là Gia Sư DeepSeek AI của ứng dụng học tập KhoaStudy. Hãy giải thích chi tiết, đầy đủ bảng biểu, công thức toán học và mã nguồn (code) nếu cần để hỗ trợ học sinh học tập tốt nhất."
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
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                
                // 1. Check for Server Error (e.g. Muted Account or Expired Token)
                if let errorObj = json["error"] as? [String: Any],
                   let errMsg = errorObj["message"] as? String {
                    let lower = errMsg.lowercased()
                    if lower.contains("muted") || lower.contains("tạm khóa") || lower.contains("giới hạn") {
                        fullAnswer = """
                        ⚠️ Tài khoản DeepSeek trên máy tính đang bị tạm khóa tính năng chat (User is muted).
                        
                        👉 Cách xử lý siêu nhanh:
                        1. Trên máy tính, hãy đóng cửa sổ DeepSeek Server và mở lại file `run_deepseek_server.bat`.
                        2. Cửa sổ Chromium sẽ mở lên, bạn bấm 'Log in with Google' và chọn một tài khoản Google khác (hoặc tạo tài khoản mới).
                        3. Đăng nhập xong là bạn quay lại app gửi câu hỏi được ngay nhé!
                        """
                    } else if lower.contains("authorization failed") || lower.contains("invalid token") || lower.contains("hết hạn") {
                        fullAnswer = """
                        ⚠️ Phiên đăng nhập DeepSeek trên máy tính đã hết hạn.
                        
                        👉 Cách khắc phục đơn giản:
                        Bạn hãy mở lại file `run_deepseek_server.bat` trên máy tính. Trình duyệt sẽ mở lên để bạn bấm 'Log in with Google' đăng nhập lại (mất 5 giây).
                        
                        Sau khi đăng nhập xong, bạn quay lại app bấm gửi lại câu hỏi là DeepSeek sẽ trả lời ngay nhé!
                        """
                    } else {
                        fullAnswer = "⚠️ DeepSeek phản hồi: \(errMsg)"
                    }
                }
                // 2. Real DeepSeek AI response
                else if let choices = json["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String,
                   !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    fullAnswer = content
                }
                // 3. Fallback when payload is empty
                else {
                    let lastUserPrompt = messages.last(where: { $0.role == "user" })?.content ?? ""
                    fullAnswer = """
                    ⚠️ Không nhận được phản hồi cho câu hỏi '\(lastUserPrompt)'.
                    
                    💡 Nguyên nhân:
                    Tài khoản DeepSeek trên máy tính đang bị DeepSeek tạm khóa (Muted) hoặc chưa đăng nhập hợp lệ.
                    
                    👉 Bạn hãy mở file `run_deepseek_server.bat` trên máy tính để đăng nhập một tài khoản Google khác nhé!
                    """
                }
            } else if let error = error {
                fullAnswer = "⚠️ Lỗi kết nối mạng: \(error.localizedDescription)\n\nVui lòng kiểm tra xem máy tính và iPhone có đang chung mạng Wi-Fi và máy tính có đang bật server không."
            } else {
                fullAnswer = "⚠️ Không thể kết nối tới DeepSeek Server tại \(serverUrl)."
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
}
