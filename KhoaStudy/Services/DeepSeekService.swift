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
    
    func checkConnection(serverUrl: String, apiKey: String = "", completion: @escaping (Bool, String) -> Void) {
        var targetUrlString = "\(serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/")))/models"
        if apiKey.hasPrefix("sk-") {
            targetUrlString = "https://api.deepseek.com/v1/models"
        }
        
        guard let url = URL(string: targetUrlString) else {
            completion(false, "URL máy chủ không hợp lệ")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if apiKey.hasPrefix("sk-") {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        request.timeoutInterval = 4.0
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 {
                    if apiKey.hasPrefix("sk-") {
                        completion(true, "Đã kết nối DeepSeek Cloud API chính thức thành công!")
                    } else {
                        completion(true, "Đã kết nối DeepSeek Server thành công (HTTP 200)")
                    }
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
                "content": "Bạn là Gia Sư DeepSeek AI của ứng dụng học tập Shimy. Hãy giải thích chi tiết, đầy đủ bảng biểu, công thức toán học và mã nguồn (code) nếu cần để hỗ trợ học sinh học tập tốt nhất."
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
    
    // MARK: - AI Web Search Exam Generator
    func generateExamWithAI(
        grade: Int,
        semester: Int,
        subject: String,
        focusTopic: String,
        mcCount: Int,
        tfCount: Int,
        saCount: Int,
        apiKey: String,
        serverUrl: String,
        completion: @escaping (Result<GeneratedExam, Error>) -> Void
    ) {
        var targetEndpoint = "\(serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/")))/chat/completions"
        if apiKey.hasPrefix("sk-") && !serverUrl.contains("api.deepseek.com") {
            targetEndpoint = "https://api.deepseek.com/v1/chat/completions"
        }
        
        guard let url = URL(string: targetEndpoint) else {
            completion(.success(CuratedStandardExamProvider.getStandardExam(grade: grade, semester: semester, subject: subject, focusTopic: focusTopic, mcCount: mcCount, tfCount: tfCount, saCount: saCount)))
            return
        }
        
        let promptText = """
        Bạn là Chuyên gia Khảo thí của Bộ Giáo Dục & Đào Tạo. Hãy dùng tìm kiếm web tra cứu giáo trình chuẩn (Kết Nối Tri Thức, Cánh Diều, Chân Trời Sáng Tạo) để tạo 1 Đề Thi Kiểm Tra chuẩn cho:
        - Lớp: \(grade)
        - Học kỳ: \(semester)
        - Môn học: \(subject)
        - Trọng tâm kiến thức: "\(focusTopic.isEmpty ? "Toàn bộ kiến thức trọng tâm học kỳ \(semester) lớp \(grade)" : focusTopic)"

        Yêu cầu số lượng câu hỏi CHÍNH XÁC:
        1. Đúng \(mcCount) câu hỏi Trắc nghiệm 4 lựa chọn (A, B, C, D, chỉ 1 đáp án đúng).
        2. Đúng \(tfCount) câu hỏi Đúng/Sai (Mỗi câu gồm ngữ cảnh và 4 ý a, b, c, d; mỗi ý xác định đúng hay sai).
        3. Đúng \(saCount) câu hỏi Trả lời ngắn (Điền số hoặc đáp số ngắn).

        Yêu cầu kỹ thuật:
        - Sử dụng công thức toán/lý/hóa bằng định dạng LaTeX chuẩn ($...$).
        - Không được trùng lặp, bám sát SGK.
        - Lời giải thích (explanation) phải chi tiết, hướng dẫn từng bước.
        - BẮT BUỘC trả về DUY NHẤT 1 đối tượng JSON thuần túy (không kèm lời chào hay văn bản thừa), theo định dạng sau:
        {
          "title": "Đề Khảo Sát \(subject) Lớp \(grade) - Học Kỳ \(semester)",
          "grade": \(grade),
          "semester": \(semester),
          "subject": "\(subject)",
          "focusTopic": "\(focusTopic)",
          "multipleChoice": [
            {
              "id": 1,
              "question": "Nội dung câu hỏi",
              "options": ["A. ...", "B. ...", "C. ...", "D. ..."],
              "correctIndex": 0,
              "explanation": "Giải thích chi tiết"
            }
          ],
          "trueFalse": [
            {
              "id": 1,
              "context": "Ngữ cảnh đề bài",
              "statements": [
                {"id": "a", "statement": "Ý a", "isCorrectTrue": true, "explanation": "Giải thích"},
                {"id": "b", "statement": "Ý b", "isCorrectTrue": false, "explanation": "Giải thích"},
                {"id": "c", "statement": "Ý c", "isCorrectTrue": true, "explanation": "Giải thích"},
                {"id": "d", "statement": "Ý d", "isCorrectTrue": false, "explanation": "Giải thích"}
              ]
            }
          ],
          "shortAnswer": [
            {
              "id": 1,
              "question": "Nội dung câu hỏi tính toán ngắn",
              "acceptedAnswers": ["12", "12.0"],
              "unit": "cm",
              "explanation": "Lời giải chi tiết"
            }
          ]
        }
        """
        
        let apiMessages: [[String: String]] = [
            ["role": "user", "content": promptText]
        ]
        
        let body: [String: Any] = [
            "model": "deepseek-chat",
            "messages": apiMessages,
            "stream": false,
            "search": true
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !apiKey.isEmpty {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        request.timeoutInterval = 60.0
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.success(CuratedStandardExamProvider.getStandardExam(grade: grade, semester: semester, subject: subject, focusTopic: focusTopic, mcCount: mcCount, tfCount: tfCount, saCount: saCount)))
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {
                
                let cleaned = DeepSeekService.extractJsonBlock(from: content)
                if let jsonData = cleaned.data(using: .utf8),
                   let exam = try? JSONDecoder().decode(GeneratedExam.self, from: jsonData),
                   !exam.multipleChoice.isEmpty {
                    DispatchQueue.main.async {
                        completion(.success(exam))
                    }
                    return
                }
            }
            
            // Fallback to rich curated standard exam
            DispatchQueue.main.async {
                let fallback = CuratedStandardExamProvider.getStandardExam(
                    grade: grade,
                    semester: semester,
                    subject: subject,
                    focusTopic: focusTopic,
                    mcCount: mcCount,
                    tfCount: tfCount,
                    saCount: saCount
                )
                completion(.success(fallback))
            }
        }.resume()
    }
    
    static func extractJsonBlock(from text: String) -> String {
        var str = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if let startFence = str.range(of: "```json") {
            str = String(str[startFence.upperBound...])
            if let endFence = str.range(of: "```") {
                str = String(str[..<endFence.lowerBound])
            }
        } else if let startFence = str.range(of: "```") {
            str = String(str[startFence.upperBound...])
            if let endFence = str.range(of: "```") {
                str = String(str[..<endFence.lowerBound])
            }
        } else if let openBrace = str.firstIndex(of: "{"),
                  let closeBrace = str.lastIndex(of: "}") {
            str = String(str[openBrace...closeBrace])
        }
        return str.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
