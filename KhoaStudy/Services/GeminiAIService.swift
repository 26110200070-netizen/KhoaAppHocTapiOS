import Foundation

struct ChatMessage: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var role: String // "user", "assistant", "system"
    var content: String
    var timestamp: Date = Date()
}

enum GeminiAIModel: String, CaseIterable, Identifiable {
    case flash = "gemini-2.5-flash"
    case pro = "gemini-2.5-pro"
    case thinking = "gemini-thinking"
    case auto = "gemini-auto"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .flash: return "Shimy Flash (Phản Hồi Siêu Tốc)"
        case .pro: return "Shimy Pro (Chuyên Gia Học Tập)"
        case .thinking: return "Shimy Think (Suy Luận Sâu Từng Bước)"
        case .auto: return "Shimy Auto (Tự Động Tối Ưu Hóa)"
        }
    }
    
    var wireModel: String {
        return self.rawValue
    }
    
    var isThinking: Bool {
        return self == .thinking
    }
}

class GeminiAIService {
    static let shared = GeminiAIService()
    
    private var activeDataTask: URLSessionDataTask?
    private var streamTimer: Timer?
    
    // Stop / cancel streaming immediately when user taps stop button
    func stopStreaming() {
        activeDataTask?.cancel()
        activeDataTask = nil
        streamTimer?.invalidate()
        streamTimer = nil
    }
    
    // MARK: - Backend Health & Connection Diagnostic
    func checkConnection(
        serverUrl: String,
        appToken: String = "",
        geminiApiKey: String = "",
        completion: @escaping (Bool, String) -> Void
    ) {
        // If user provided direct Google AI Studio API Key (AIza...)
        if geminiApiKey.hasPrefix("AIza") {
            let target = "https://generativelanguage.googleapis.com/v1beta/models?key=\(geminiApiKey)"
            guard let url = URL(string: target) else {
                completion(false, "Google API Key không hợp lệ")
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 5.0
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 {
                        completion(true, "Đã kết nối Google AI Studio (Gemini Cloud) thành công!")
                    } else if let error = error {
                        completion(false, "Lỗi kết nối Google Cloud: \(error.localizedDescription)")
                    } else {
                        completion(false, "Mã phản hồi Google: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                    }
                }
            }.resume()
            return
        }
        
        // Otherwise check local/remote Backend Gateway
        let cleanBase = serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let baseWithoutV1 = cleanBase.hasSuffix("/v1") ? String(cleanBase.dropLast(3)) : cleanBase
        let targetUrlString = "\(baseWithoutV1)/health"
        
        guard let url = URL(string: targetUrlString) else {
            completion(false, "URL máy chủ không hợp lệ")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if !appToken.isEmpty {
            request.addValue("Bearer \(appToken)", forHTTPHeaderField: "Authorization")
        }
        request.timeoutInterval = 4.0
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 {
                    if let data = data,
                       let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        let sessionStatus = json["gemini_web_session"] as? String ?? "active"
                        if sessionStatus == "needs_login" {
                            completion(true, "Đã kết nối Server (Máy tính cần mở run_gemini_server để đăng nhập Google)")
                        } else {
                            completion(true, "Đã kết nối Shimy Gemini Gateway thành công (HTTP 200)")
                        }
                    } else {
                        completion(true, "Đã kết nối Shimy Backend thành công (HTTP 200)")
                    }
                } else if let error = error {
                    completion(false, "Không thể kết nối Server: \(error.localizedDescription)")
                } else {
                    completion(false, "Mã phản hồi từ Server: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                }
            }
        }.resume()
    }
    
    // MARK: - App User Login
    func loginToBackend(
        serverUrl: String,
        username: String,
        password: String,
        completion: @escaping (Bool, String, [String: Any]?) -> Void
    ) {
        let cleanBase = serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        // If ends with /v1, remove it for api routes
        let baseWithoutV1 = cleanBase.hasSuffix("/v1") ? String(cleanBase.dropLast(3)) : cleanBase
        let endpoint = "\(baseWithoutV1)/api/auth/login"
        
        guard let url = URL(string: endpoint) else {
            completion(false, "URL Endpoint không hợp lệ", nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 6.0
        
        let body: [String: Any] = [
            "username": username,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let status = json["status"] as? String ?? ""
                    let msg = json["message"] as? String ?? (json["detail"] as? String ?? "Phản hồi từ server")
                    let dataObj = json["data"] as? [String: Any]
                    
                    if status == "success", let d = dataObj {
                        completion(true, msg, d)
                    } else {
                        completion(false, msg, nil)
                    }
                } else if let error = error {
                    completion(false, "Lỗi kết nối máy chủ: \(error.localizedDescription)", nil)
                } else {
                    completion(false, "Lỗi không xác định từ máy chủ", nil)
                }
            }
        }.resume()
    }
    
    // MARK: - App User Register
    func registerToBackend(
        serverUrl: String,
        username: String,
        password: String,
        fullName: String,
        grade: Int = 12,
        completion: @escaping (Bool, String, [String: Any]?) -> Void
    ) {
        let cleanBase = serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let baseWithoutV1 = cleanBase.hasSuffix("/v1") ? String(cleanBase.dropLast(3)) : cleanBase
        let endpoint = "\(baseWithoutV1)/api/auth/register"
        
        guard let url = URL(string: endpoint) else {
            completion(false, "URL Endpoint không hợp lệ", nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 6.0
        
        let body: [String: Any] = [
            "username": username,
            "password": password,
            "full_name": fullName,
            "grade": grade
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let status = json["status"] as? String ?? ""
                    let msg = json["message"] as? String ?? (json["detail"] as? String ?? "Phản hồi từ server")
                    let dataObj = json["data"] as? [String: Any]
                    
                    if status == "success", let d = dataObj {
                        completion(true, msg, d)
                    } else {
                        completion(false, msg, nil)
                    }
                } else if let error = error {
                    completion(false, "Lỗi kết nối máy chủ: \(error.localizedDescription)", nil)
                } else {
                    completion(false, "Lỗi không xác định từ máy chủ", nil)
                }
            }
        }.resume()
    }
    
    // MARK: - Streaming Chat with Gemini
    func sendStreamingChat(
        messages: [ChatMessage],
        model: GeminiAIModel = .flash,
        appToken: String,
        serverUrl: String,
        geminiApiKey: String = "",
        isWebSearch: Bool = false,
        isDeepReasoning: Bool = false,
        attachedImageBase64: String? = nil,
        attachedFileContent: String? = nil,
        onToken: @escaping (String) -> Void,
        onComplete: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        stopStreaming()
        
        var cleanBase = serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        if !cleanBase.hasSuffix("/v1") {
            cleanBase = "\(cleanBase)/v1"
        }
        let targetEndpoint = "\(cleanBase)/chat/completions"
        
        guard let url = URL(string: targetEndpoint) else {
            DispatchQueue.main.async {
                onError(NSError(domain: "GeminiAIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "URL Endpoint không hợp lệ"]))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Pass either App Token or direct Google AI Studio API Key in Authorization header
        if !geminiApiKey.isEmpty && geminiApiKey.hasPrefix("AIza") {
            request.addValue("Bearer \(geminiApiKey)", forHTTPHeaderField: "Authorization")
        } else if !appToken.isEmpty {
            request.addValue("Bearer \(appToken)", forHTTPHeaderField: "Authorization")
        }
        request.timeoutInterval = 60.0
        
        // System Instruction for Shimy AI
        var systemInstruction = "Bạn tên là Shimy, một trợ lý học tập AI thông minh và tận tâm, được phát triển và huấn luyện bởi Duy Nguyễn. Hãy giải thích chi tiết, ân cần, đầy đủ bảng biểu, công thức toán học và mã nguồn nếu cần để hỗ trợ học sinh học tập tốt nhất. Tuyệt đối không đề cập đến tên gọi hay nhà phát triển nào khác, tên duy nhất của bạn là Shimy do Duy Nguyễn huấn luyện."
        if isWebSearch {
            systemInstruction += "\n[Chế độ Google Search Grounding: Đang BẬT. Hãy tra cứu và sử dụng các thông tin, giáo trình SGK mới nhất của Bộ GD&ĐT Việt Nam để đưa ra đáp án chuẩn xác nhất]."
        }
        
        var apiMessages: [[String: String]] = [
            ["role": "system", "content": systemInstruction]
        ]
        
        for (idx, msg) in messages.enumerated() {
            var content = msg.content
            if idx == messages.count - 1 && msg.role == "user" {
                if let fileContent = attachedFileContent, !fileContent.isEmpty {
                    content = "[Tệp tài liệu đính kèm]:\n\(fileContent)\n\n[Câu hỏi / Yêu cầu]:\n\(content)"
                }
            }
            apiMessages.append(["role": msg.role, "content": content])
        }
        
        let effectiveWireModel = isDeepReasoning ? "gemini-thinking" : model.wireModel
        var body: [String: Any] = [
            "model": effectiveWireModel,
            "messages": apiMessages,
            "stream": false,
            "thinking": isDeepReasoning || model.isThinking,
            "web_search": isWebSearch
        ]
        
        if let img = attachedImageBase64, !img.isEmpty {
            body["attached_image"] = img
        }
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            DispatchQueue.main.async {
                onError(NSError(domain: "GeminiAIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Lỗi mã hóa JSON"]))
            }
            return
        }
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            var fullAnswer = ""
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                
                // 1. Check for Server / Rate Limit / Cookie Guidance Error
                if let errorObj = json["error"] as? [String: Any],
                   let errMsg = errorObj["message"] as? String {
                    let lower = errMsg.lowercased()
                    if lower.contains("429") || lower.contains("hạn mức") || lower.contains("lượt dùng") {
                        fullAnswer = """
                        ⚠️ \(errMsg)
                        
                        💡 Gợi ý: Mỗi học sinh có 150 câu hỏi học tập miễn phí mỗi ngày. Bạn có thể đợi một lát hoặc nâng cấp tài khoản nhé!
                        """
                    } else if lower.contains("hết hạn") || lower.contains("đăng nhập") || lower.contains("cookie") {
                        fullAnswer = """
                        ⚠️ Phiên kết nối Google Gemini trên máy tính cần đăng nhập lại.
                        
                        👉 Cách xử lý siêu nhanh (chỉ 5 giây):
                        1. Mở file `run_gemini_server.bat` trên máy tính.
                        2. Cửa sổ trình duyệt sẽ tự động mở lên, bạn đăng nhập tài khoản Google.
                        3. Đăng nhập xong là bạn quay lại app gửi câu hỏi được ngay nhé!
                        """
                    } else {
                        fullAnswer = "⚠️ Shimy phản hồi: \(errMsg)"
                    }
                }
                // 2. Real Shimy Gemini AI response
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
                    ⚠️ Không nhận được nội dung phản hồi cho câu hỏi '\(lastUserPrompt)'.
                    
                    💡 Bạn hãy kiểm tra lại kết nối hoặc chạy file `run_gemini_server.bat` trên máy tính nhé!
                    """
                }
            } else if let error = error {
                fullAnswer = "⚠️ Lỗi kết nối mạng: \(error.localizedDescription)\n\nVui lòng kiểm tra xem máy tính và iPhone có đang chung mạng Wi-Fi và máy tính có đang mở file `run_gemini_server.bat` không."
            } else {
                fullAnswer = "⚠️ Không thể kết nối tới Shimy Server tại \(serverUrl)."
            }
            
            // Deliver smoothly to UI on the main thread
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
            DispatchQueue.main.async { onComplete() }
            return
        }
        
        DispatchQueue.main.async {
            self.streamTimer?.invalidate()
            var currentIndex = 0
            
            let timer = Timer.scheduledTimer(withTimeInterval: 0.022, repeats: true) { [weak self] t in
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
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    // MARK: - AI Exam Generator
    func generateExamWithAI(
        grade: Int,
        semester: Int,
        subject: String,
        focusTopic: String,
        mcCount: Int,
        tfCount: Int,
        saCount: Int,
        appToken: String,
        serverUrl: String,
        geminiApiKey: String = "",
        completion: @escaping (Result<GeneratedExam, Error>) -> Void
    ) {
        var cleanBase = serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        if !cleanBase.hasSuffix("/v1") {
            cleanBase = "\(cleanBase)/v1"
        }
        let targetEndpoint = "\(cleanBase)/chat/completions"
        
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
            "model": "gemini-2.5-flash",
            "messages": apiMessages,
            "stream": false,
            "web_search": true
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !geminiApiKey.isEmpty && geminiApiKey.hasPrefix("AIza") {
            request.addValue("Bearer \(geminiApiKey)", forHTTPHeaderField: "Authorization")
        } else if !appToken.isEmpty {
            request.addValue("Bearer \(appToken)", forHTTPHeaderField: "Authorization")
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
                
                let cleaned = GeminiAIService.extractJsonBlock(from: content)
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
