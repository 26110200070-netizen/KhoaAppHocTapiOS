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

enum GroqModel: String, CaseIterable, Identifiable {
    case gpt_oss_120b = "openai/gpt-oss-120b"
    case gpt_oss_20b = "openai/gpt-oss-20b"
    case qwen38_27b = "qwen/qwen3.8-27b"
    case gpt_oss_safeguard_20b = "openai/gpt-oss-safeguard-20b"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .gpt_oss_120b: return "OpenAI GPT-OSS 120B (Mặc Định)"
        case .gpt_oss_20b: return "OpenAI GPT-OSS 20B (Siêu Tốc 1000 t/s)"
        case .qwen38_27b: return "Alibaba Qwen 3.8 27B"
        case .gpt_oss_safeguard_20b: return "OpenAI GPT-OSS Safeguard 20B"
        }
    }
    
    var shortName: String {
        switch self {
        case .gpt_oss_120b: return "GPT-OSS 120B"
        case .gpt_oss_20b: return "GPT-OSS 20B"
        case .qwen38_27b: return "Qwen 3.8 27B"
        case .gpt_oss_safeguard_20b: return "GPT Safeguard 20B"
        }
    }
    
    var description: String {
        switch self {
        case .gpt_oss_120b: return "Mô hình 120B mạnh nhất của OpenAI trên Groq, tốc độ 500 từ/giây, suy luận toán & văn chuyên sâu"
        case .gpt_oss_20b: return "Mô hình OpenAI siêu tốc độ 1000 từ/giây, phản hồi tức thì"
        case .qwen38_27b: return "Mô hình Qwen 27B tối ưu suy luận đa nhiệm"
        case .gpt_oss_safeguard_20b: return "Mô hình OpenAI 20B tích hợp bảo vệ an toàn"
        }
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
    
    // MARK: - Groq Cloud Connection Diagnostic
    func checkGroqConnection(
        apiKey: String,
        completion: @escaping (Bool, String) -> Void
    ) {
        let cleanKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanKey.isEmpty else {
            completion(false, "Vui lòng nhập Groq API Key")
            return
        }
        guard let url = URL(string: "https://api.groq.com/openai/v1/models") else {
            completion(false, "URL Groq không hợp lệ")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(cleanKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 6.0
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 {
                    completion(true, "Đã kết nối Groq Cloud LPU thành công! Tốc độ phản hồi cực nhanh.")
                } else if let data = data,
                          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                          let err = json["error"] as? [String: Any],
                          let msg = err["message"] as? String {
                    completion(false, "Lỗi Groq: \(msg)")
                } else if let error = error {
                    completion(false, "Lỗi kết nối Groq: \(error.localizedDescription)")
                } else {
                    completion(false, "Mã phản hồi từ Groq: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                }
            }
        }.resume()
    }
    
    // MARK: - Backend Health & Connection Diagnostic
    func checkConnection(
        serverUrl: String,
        appToken: String = "",
        geminiApiKey: String = "",
        groqApiKey: String = "",
        provider: AIProvider = .groq,
        completion: @escaping (Bool, String) -> Void
    ) {
        if provider == .groq && !groqApiKey.isEmpty {
            checkGroqConnection(apiKey: groqApiKey, completion: completion)
            return
        }
        
        // If user provided direct Google AI Studio API Key (AIza...)
        if geminiApiKey.hasPrefix("AIza") || (!geminiApiKey.isEmpty && provider == .gemini) {
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
        groqModel: String = "openai/gpt-oss-120b",
        provider: AIProvider = .groq,
        appToken: String = "",
        serverUrl: String = "",
        geminiApiKey: String = "",
        groqApiKey: String = "",
        isWebSearch: Bool = false,
        isDeepReasoning: Bool = false,
        attachedImageBase64: String? = nil,
        attachedFileContent: String? = nil,
        onToken: @escaping (String) -> Void,
        onComplete: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        stopStreaming()
        
        let cleanGroqKey = groqApiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanGeminiKey = geminiApiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Priority 1: Groq Cloud (Ultra-fast LPU inference, no waiting, 100% free)
        if provider == .groq && !cleanGroqKey.isEmpty {
            sendGroqChat(
                messages: messages,
                model: groqModel,
                apiKey: cleanGroqKey,
                isWebSearch: isWebSearch,
                isDeepReasoning: isDeepReasoning,
                attachedImageBase64: attachedImageBase64,
                attachedFileContent: attachedFileContent,
                onToken: onToken,
                onComplete: onComplete,
                onError: onError
            )
            return
        }
        
        // Priority 2: Direct Google Cloud Gemini API
        if (provider == .gemini || cleanGroqKey.isEmpty) && !cleanGeminiKey.isEmpty && (cleanGeminiKey.hasPrefix("AIza") || cleanGeminiKey.count >= 25) {
            sendDirectGoogleGeminiChat(
                messages: messages,
                model: model,
                apiKey: cleanGeminiKey,
                isWebSearch: isWebSearch,
                isDeepReasoning: isDeepReasoning,
                attachedImageBase64: attachedImageBase64,
                attachedFileContent: attachedFileContent,
                onToken: onToken,
                onComplete: onComplete,
                onError: onError
            )
            return
        }
        
        // Priority 3: Fallback to Groq if key exists
        if !cleanGroqKey.isEmpty {
            sendGroqChat(
                messages: messages,
                model: groqModel,
                apiKey: cleanGroqKey,
                isWebSearch: isWebSearch,
                isDeepReasoning: isDeepReasoning,
                attachedImageBase64: attachedImageBase64,
                attachedFileContent: attachedFileContent,
                onToken: onToken,
                onComplete: onComplete,
                onError: onError
            )
            return
        }
        
        // Priority 4: Fallback to local / remote server gateway if configured
        var cleanBase = serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        if !cleanBase.isEmpty && !cleanBase.hasSuffix("/v1") {
            cleanBase = "\(cleanBase)/v1"
        }
        let targetEndpoint = "\(cleanBase)/chat/completions"
        
        guard !cleanBase.isEmpty, let url = URL(string: targetEndpoint) else {
            DispatchQueue.main.async {
                onError(NSError(domain: "GeminiAIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Vui lòng nhập API Key cho Groq hoặc Google Gemini để bắt đầu trò chuyện."]))
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
        var systemInstruction = """
        Bạn tên là Shimy, một trợ lý học tập AI thông minh và tận tâm, được phát triển và huấn luyện bởi Duy Nguyễn. Hãy giải thích chi tiết, ân cần, đầy đủ bảng biểu, công thức toán học và mã nguồn nếu cần để hỗ trợ học sinh học tập tốt nhất. Tuyệt đối không đề cập đến tên gọi hay nhà phát triển nào khác, tên duy nhất của bạn là Shimy do Duy Nguyễn huấn luyện.
        
        [QUY TẮC ĐỊNH DẠNG BẢNG BIỂU & TOÁN HỌC - BẮT BUỘC]:
        1. Bảng biểu (Markdown Table): Dùng định dạng bảng Markdown chuẩn (| Cột 1 | Cột 2 |). Tuyệt đối KHÔNG dùng thẻ HTML như <br>, <p>, <b> trong ô bảng. Muốn xuống dòng trong một ô hãy dùng gạch đầu dòng (-) hoặc viết câu ngắn gọn súc tích.
        2. Công thức toán học: Trình bày công thức sạch sẽ, dễ đọc, ưu tiên dùng các ký hiệu toán Unicode chuẩn (ví dụ: x², xⁿ, √x, ∫, ∑, ∈, ℝ, π, d/dx, ±, ≠, ≤, ≥, →). Đặt công thức chính giữa dòng trong $$...$$. Tuyệt đối KHÔNG sử dụng các macro LaTeX phức tạp như \\boxed, \\displaystyle, \\bigl, \\bigr, \\left, \\right, \\qquad, \\quad, \\, hoặc \\!. Hãy để công thức ngắn gọn, trực quan, đúng chuẩn sách giáo khoa.
        """
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
    
    // MARK: - Direct Groq Cloud Chat API (Ultra-fast LPU, Free)
    func sendGroqChat(
        messages: [ChatMessage],
        model: String = "openai/gpt-oss-120b",
        apiKey: String,
        isWebSearch: Bool = false,
        isDeepReasoning: Bool = false,
        attachedImageBase64: String? = nil,
        attachedFileContent: String? = nil,
        onToken: @escaping (String) -> Void,
        onComplete: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        stopStreaming()
        
        let cleanKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanKey.isEmpty else {
            DispatchQueue.main.async {
                onError(NSError(domain: "GeminiAIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Chưa cấu hình Groq API Key."]))
            }
            return
        }
        
        guard let url = URL(string: "https://api.groq.com/openai/v1/chat/completions") else {
            DispatchQueue.main.async {
                onError(NSError(domain: "GeminiAIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "URL Groq không hợp lệ."]))
            }
            return
        }
        
        var systemInstruction = """
        Bạn tên là Shimy, một trợ lý học tập AI thông minh và tận tâm, được phát triển và huấn luyện bởi Duy Nguyễn. Hãy giải thích chi tiết, ân cần, đầy đủ bảng biểu, công thức toán học và mã nguồn nếu cần để hỗ trợ học sinh học tập tốt nhất. Tuyệt đối không đề cập đến tên gọi hay nhà phát triển nào khác, tên duy nhất của bạn là Shimy do Duy Nguyễn huấn luyện.
        
        [QUY TẮC ĐỊNH DẠNG BẢNG BIỂU & TOÁN HỌC - BẮT BUỘC]:
        1. Bảng biểu (Markdown Table): Dùng định dạng bảng Markdown chuẩn (| Cột 1 | Cột 2 |). Tuyệt đối KHÔNG dùng thẻ HTML như <br>, <p>, <b> trong ô bảng. Muốn xuống dòng trong một ô hãy dùng gạch đầu dòng (-) hoặc viết câu ngắn gọn súc tích.
        2. Công thức toán học: Trình bày công thức sạch sẽ, dễ đọc, ưu tiên dùng các ký hiệu toán Unicode chuẩn (ví dụ: x², xⁿ, √x, ∫, ∑, ∈, ℝ, π, d/dx, ±, ≠, ≤, ≥, →). Đặt công thức chính giữa dòng trong $$...$$. Tuyệt đối KHÔNG sử dụng các macro LaTeX phức tạp như \\boxed, \\displaystyle, \\bigl, \\bigr, \\left, \\right, \\qquad, \\quad, \\, hoặc \\!. Hãy để công thức ngắn gọn, trực quan, đúng chuẩn sách giáo khoa.
        """
        if isWebSearch {
            systemInstruction += "\n[Lưu ý: Hãy tham khảo và áp dụng kiến thức theo chuẩn sách giáo khoa mới nhất của Bộ Giáo Dục & Đào Tạo Việt Nam]."
        }
        
        var apiMessages: [[String: Any]] = [
            ["role": "system", "content": systemInstruction]
        ]
        
        var effectiveModel = model
        let hasImage = (attachedImageBase64 != nil && !attachedImageBase64!.isEmpty)
        if isDeepReasoning {
            effectiveModel = "openai/gpt-oss-120b"
        }
        
        for (idx, msg) in messages.enumerated() {
            var textContent = msg.content
            if idx == messages.count - 1 && msg.role == "user" {
                if let fileContent = attachedFileContent, !fileContent.isEmpty {
                    textContent = "[Tệp tài liệu đính kèm]:\n\(fileContent)\n\n[Câu hỏi / Yêu cầu]:\n\(textContent)"
                }
                
                if let imgB64 = attachedImageBase64, !imgB64.isEmpty {
                    let contentArray: [[String: Any]] = [
                        ["type": "text", "text": textContent],
                        ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(imgB64)"]]
                    ]
                    apiMessages.append(["role": "user", "content": contentArray])
                    continue
                }
            }
            apiMessages.append(["role": msg.role, "content": textContent])
        }
        
        let body: [String: Any] = [
            "model": effectiveModel,
            "messages": apiMessages,
            "temperature": 0.6,
            "max_tokens": 12288,
            "stream": false
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(cleanKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 45.0
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            DispatchQueue.main.async {
                onError(NSError(domain: "GeminiAIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Lỗi mã hóa JSON Groq"]))
            }
            return
        }
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            var fullAnswer = ""
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let errorObj = json["error"] as? [String: Any],
                   let errMsg = errorObj["message"] as? String {
                    if errMsg.contains("Invalid API Key") || errMsg.contains("invalid_api_key") {
                        fullAnswer = "⚠️ Groq API Key không hợp lệ. Bạn vui lòng kiểm tra và cập nhật lại Key trên console.groq.com nhé!"
                    } else if errMsg.contains("rate limit") || errMsg.contains("Rate limit") {
                        fullAnswer = "⚠️ Groq báo đạt giới hạn tần suất tạm thời. Bạn vui lòng đợi 5-10 giây rồi thử lại nhé!"
                    } else {
                        fullAnswer = "⚠️ Groq phản hồi: \(errMsg)"
                    }
                } else if let choices = json["choices"] as? [[String: Any]],
                          let firstChoice = choices.first,
                          let msgObj = firstChoice["message"] as? [String: Any],
                          let text = msgObj["content"] as? String {
                    fullAnswer = text
                } else if let output = json["output"] as? String {
                    fullAnswer = output
                } else if let outputList = json["output"] as? [[String: Any]],
                          let firstOut = outputList.first,
                          let content = firstOut["content"] as? String {
                    fullAnswer = content
                } else if let text = json["response"] as? String {
                    fullAnswer = text
                } else {
                    fullAnswer = "⚠️ Không nhận được câu trả lời từ Groq Cloud. Vui lòng thử lại."
                }
            } else if let error = error {
                fullAnswer = "⚠️ Lỗi kết nối Groq: \(error.localizedDescription)"
            } else {
                fullAnswer = "⚠️ Không thể kết nối tới Groq Cloud."
            }
            
            self.streamWordsToUI(text: fullAnswer, onToken: onToken, onComplete: onComplete)
        }
        
        self.activeDataTask = task
        task.resume()
    }
    
    // MARK: - Direct Google Cloud Gemini API (No PC Server Needed)
    func sendDirectGoogleGeminiChat(
        messages: [ChatMessage],
        model: GeminiAIModel = .flash,
        apiKey: String,
        isWebSearch: Bool = false,
        isDeepReasoning: Bool = false,
        attachedImageBase64: String? = nil,
        attachedFileContent: String? = nil,
        onToken: @escaping (String) -> Void,
        onComplete: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        stopStreaming()
        
        var targetModel = "gemini-1.5-flash"
        if isDeepReasoning || model == .thinking {
            targetModel = "gemini-2.0-flash-thinking-exp"
        } else if model == .pro {
            targetModel = "gemini-1.5-pro"
        }
        
        let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/\(targetModel):generateContent?key=\(apiKey)"
        guard let url = URL(string: endpoint) else {
            DispatchQueue.main.async {
                onError(NSError(domain: "GeminiAIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "URL Google Gemini không hợp lệ"]))
            }
            return
        }
        
        let systemInstruction = """
        Bạn tên là Shimy, một trợ lý học tập AI thông minh và tận tâm, được phát triển và huấn luyện bởi Duy Nguyễn. Hãy giải thích chi tiết, ân cần, đầy đủ bảng biểu, công thức toán học và mã nguồn nếu cần để hỗ trợ học sinh học tập tốt nhất. Tuyệt đối không đề cập đến tên gọi hay nhà phát triển nào khác, tên duy nhất của bạn là Shimy do Duy Nguyễn huấn luyện.
        
        [QUY TẮC ĐỊNH DẠNG BẢNG BIỂU & TOÁN HỌC - BẮT BUỘC]:
        1. Bảng biểu (Markdown Table): Dùng định dạng bảng Markdown chuẩn (| Cột 1 | Cột 2 |). Tuyệt đối KHÔNG dùng thẻ HTML như <br>, <p>, <b> trong ô bảng. Muốn xuống dòng trong một ô hãy dùng gạch đầu dòng (-) hoặc viết câu ngắn gọn súc tích.
        2. Công thức toán học: Trình bày công thức sạch sẽ, dễ đọc, ưu tiên dùng các ký hiệu toán Unicode chuẩn (ví dụ: x², xⁿ, √x, ∫, ∑, ∈, ℝ, π, d/dx, ±, ≠, ≤, ≥, →). Đặt công thức chính giữa dòng trong $$...$$. Tuyệt đối KHÔNG sử dụng các macro LaTeX phức tạp như \\boxed, \\displaystyle, \\bigl, \\bigr, \\left, \\right, \\qquad, \\quad, \\, hoặc \\!. Hãy để công thức ngắn gọn, trực quan, đúng chuẩn sách giáo khoa.
        """
        
        var contents: [[String: Any]] = []
        for (idx, msg) in messages.enumerated() {
            if msg.role == "system" { continue }
            let role = (msg.role == "user") ? "user" : "model"
            var textContent = msg.content
            
            if idx == messages.count - 1 && msg.role == "user" {
                if let fileContent = attachedFileContent, !fileContent.isEmpty {
                    textContent = "[Tệp tài liệu đính kèm]:\n\(fileContent)\n\n[Câu hỏi / Yêu cầu]:\n\(textContent)"
                }
            }
            
            var parts: [[String: Any]] = [
                ["text": textContent]
            ]
            
            if idx == messages.count - 1 && msg.role == "user", let imgB64 = attachedImageBase64, !imgB64.isEmpty {
                parts.append([
                    "inline_data": [
                        "mime_type": "image/jpeg",
                        "data": imgB64
                    ]
                ])
            }
            
            contents.append([
                "role": role,
                "parts": parts
            ])
        }
        
        var body: [String: Any] = [
            "contents": contents,
            "system_instruction": [
                "parts": [
                    ["text": systemInstruction]
                ]
            ],
            "generationConfig": [
                "temperature": 0.7,
                "maxOutputTokens": 4096
            ]
        ]
        
        if isWebSearch {
            body["tools"] = [
                ["google_search": [:]]
            ]
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 45.0
        
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
                if let errorObj = json["error"] as? [String: Any],
                   let errMsg = errorObj["message"] as? String {
                    if errMsg.contains("API key not valid") || errMsg.contains("API_KEY_INVALID") {
                        fullAnswer = "⚠️ Google Gemini API Key không hợp lệ hoặc đã bị hết hạn. Vui lòng kiểm tra lại Key trên aistudio.google.com trong Cài Đặt nhé!"
                    } else if errMsg.contains("quota") || errMsg.contains("rate") {
                        fullAnswer = "⚠️ Google Gemini báo đã đạt giới hạn tần suất tạm thời. Bạn vui lòng đợi 10 giây rồi thử lại nhé!"
                    } else {
                        fullAnswer = "⚠️ Google Gemini phản hồi: \(errMsg)"
                    }
                } else if let candidates = json["candidates"] as? [[String: Any]],
                          let firstCandidate = candidates.first,
                          let contentObj = firstCandidate["content"] as? [String: Any],
                          let parts = contentObj["parts"] as? [[String: Any]] {
                    let textParts = parts.compactMap { $0["text"] as? String }
                    fullAnswer = textParts.joined()
                } else {
                    fullAnswer = "⚠️ Không nhận được phản hồi từ Google Gemini Cloud. Vui lòng thử lại."
                }
            } else if let error = error {
                fullAnswer = "⚠️ Lỗi kết nối Google: \(error.localizedDescription)"
            } else {
                fullAnswer = "⚠️ Không thể kết nối tới Google Gemini."
            }
            
            self.streamWordsToUI(text: fullAnswer, onToken: onToken, onComplete: onComplete)
        }
        
        self.activeDataTask = task
        task.resume()
    }
    
    // MARK: - Direct Google Cloud Exam Generator (Native JSON Mode)
    // MARK: - Direct Google Cloud Exam Generator (Native JSON Mode & Web Search Grounding)
    func generateDirectGoogleGeminiExam(
        grade: Int,
        semester: Int,
        subject: String,
        focusTopic: String,
        mcCount: Int,
        tfCount: Int,
        saCount: Int,
        apiKey: String,
        webContext: String = "",
        completion: @escaping (Result<GeneratedExam, Error>) -> Void
    ) {
        let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)"
        guard let url = URL(string: endpoint) else {
            completion(.success(CuratedStandardExamProvider.getStandardExam(grade: grade, semester: semester, subject: subject, focusTopic: focusTopic, mcCount: mcCount, tfCount: tfCount, saCount: saCount)))
            return
        }
        
        let promptText = GeminiAIService.buildExamPrompt(
            grade: grade,
            semester: semester,
            subject: subject,
            focusTopic: focusTopic,
            mcCount: mcCount,
            tfCount: tfCount,
            saCount: saCount,
            webContext: webContext
        )
        
        let body: [String: Any] = [
            "contents": [
                [
                    "role": "user",
                    "parts": [
                        ["text": promptText]
                    ]
                ]
            ],
            "tools": [
                ["googleSearch": [:]]
            ],
            "generationConfig": [
                "temperature": 0.4,
                "response_mime_type": "application/json"
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 60.0
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.success(CuratedStandardExamProvider.getStandardExam(grade: grade, semester: semester, subject: subject, focusTopic: focusTopic, mcCount: mcCount, tfCount: tfCount, saCount: saCount)))
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let candidates = json["candidates"] as? [[String: Any]],
               let firstCandidate = candidates.first,
               let contentObj = firstCandidate["content"] as? [String: Any],
               let parts = contentObj["parts"] as? [[String: Any]],
               let text = parts.first?["text"] as? String {
                
                let cleaned = GeminiAIService.extractJsonBlock(from: text)
                if let jsonData = cleaned.data(using: .utf8),
                   let rawExam = try? JSONDecoder().decode(GeneratedExam.self, from: jsonData) {
                    let sanitized = GeminiAIService.sanitizeExam(rawExam, mcCount: mcCount, tfCount: tfCount, saCount: saCount)
                    if (sanitized.multipleChoice.count + sanitized.trueFalse.count + sanitized.shortAnswer.count) > 0 {
                        DispatchQueue.main.async {
                            completion(.success(sanitized))
                        }
                        return
                    }
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
                let sanitized = GeminiAIService.sanitizeExam(fallback, mcCount: mcCount, tfCount: tfCount, saCount: saCount)
                completion(.success(sanitized))
            }
        }.resume()
    }
    
    // MARK: - Direct Groq Cloud Exam Generator (Native JSON Mode & 2026 Grounding)
    func generateGroqExam(
        grade: Int,
        semester: Int,
        subject: String,
        focusTopic: String,
        mcCount: Int,
        tfCount: Int,
        saCount: Int,
        apiKey: String,
        model: String = "openai/gpt-oss-120b",
        webContext: String = "",
        completion: @escaping (Result<GeneratedExam, Error>) -> Void
    ) {
        guard let url = URL(string: "https://api.groq.com/openai/v1/chat/completions") else {
            completion(.success(CuratedStandardExamProvider.getStandardExam(grade: grade, semester: semester, subject: subject, focusTopic: focusTopic, mcCount: mcCount, tfCount: tfCount, saCount: saCount)))
            return
        }
        
        let promptText = GeminiAIService.buildExamPrompt(
            grade: grade,
            semester: semester,
            subject: subject,
            focusTopic: focusTopic,
            mcCount: mcCount,
            tfCount: tfCount,
            saCount: saCount,
            webContext: webContext
        )
        
        let body: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": "Bạn là chuyên gia ra đề thi học tập K-12 Việt Nam. Bạn luôn xuất dữ liệu ở định dạng JSON hợp lệ tuân thủ chính xác schema được yêu cầu."],
                ["role": "user", "content": promptText]
            ],
            "response_format": ["type": "json_object"],
            "temperature": 0.4,
            "max_tokens": 8192
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 55.0
        
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
               let msg = firstChoice["message"] as? [String: Any],
               let text = msg["content"] as? String {
                
                let cleaned = GeminiAIService.extractJsonBlock(from: text)
                if let jsonData = cleaned.data(using: .utf8),
                   let rawExam = try? JSONDecoder().decode(GeneratedExam.self, from: jsonData) {
                    let sanitized = GeminiAIService.sanitizeExam(rawExam, mcCount: mcCount, tfCount: tfCount, saCount: saCount)
                    if (sanitized.multipleChoice.count + sanitized.trueFalse.count + sanitized.shortAnswer.count) > 0 {
                        DispatchQueue.main.async {
                            completion(.success(sanitized))
                        }
                        return
                    }
                }
            }
            
            // Fallback
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
                let sanitized = GeminiAIService.sanitizeExam(fallback, mcCount: mcCount, tfCount: tfCount, saCount: saCount)
                completion(.success(sanitized))
            }
        }.resume()
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
        appToken: String = "",
        serverUrl: String = "",
        provider: AIProvider = .groq,
        geminiApiKey: String = "",
        groqApiKey: String = "",
        groqModel: String = "openai/gpt-oss-120b",
        completion: @escaping (Result<GeneratedExam, Error>) -> Void
    ) {
        let cleanGroqKey = groqApiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanGeminiKey = geminiApiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 1. Thực hiện tra cứu Web Search thực tế về kiến thức năm 2026 của Bộ GD&ĐT
        WebKnowledgeService.shared.searchLatest2026Curriculum(
            subject: subject,
            grade: grade,
            semester: semester,
            topic: focusTopic
        ) { webContext in
            // Priority 1: Groq Cloud Exam Generation
            if (provider == .groq && !cleanGroqKey.isEmpty) || (!cleanGroqKey.isEmpty && cleanGeminiKey.isEmpty) {
                self.generateGroqExam(
                    grade: grade,
                    semester: semester,
                    subject: subject,
                    focusTopic: focusTopic,
                    mcCount: mcCount,
                    tfCount: tfCount,
                    saCount: saCount,
                    apiKey: cleanGroqKey,
                    model: groqModel,
                    webContext: webContext,
                    completion: completion
                )
                return
            }
            
            // Priority 2: Direct Google Cloud Gemini Exam Generation
            if !cleanGeminiKey.isEmpty && (cleanGeminiKey.hasPrefix("AIza") || cleanGeminiKey.count >= 25) {
                self.generateDirectGoogleGeminiExam(
                    grade: grade,
                    semester: semester,
                    subject: subject,
                    focusTopic: focusTopic,
                    mcCount: mcCount,
                    tfCount: tfCount,
                    saCount: saCount,
                    apiKey: cleanGeminiKey,
                    webContext: webContext,
                    completion: completion
                )
                return
            }
            
            var cleanBase = serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            if !cleanBase.hasSuffix("/v1") {
                cleanBase = "\(cleanBase)/v1"
            }
            let targetEndpoint = "\(cleanBase)/chat/completions"
            
            guard let url = URL(string: targetEndpoint) else {
                completion(.success(CuratedStandardExamProvider.getStandardExam(grade: grade, semester: semester, subject: subject, focusTopic: focusTopic, mcCount: mcCount, tfCount: tfCount, saCount: saCount)))
                return
            }
        
            let promptText = GeminiAIService.buildExamPrompt(
                grade: grade,
                semester: semester,
                subject: subject,
                focusTopic: focusTopic,
                mcCount: mcCount,
                tfCount: tfCount,
                saCount: saCount,
                webContext: webContext
            )
            
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
                       let rawExam = try? JSONDecoder().decode(GeneratedExam.self, from: jsonData) {
                        let sanitized = GeminiAIService.sanitizeExam(rawExam, mcCount: mcCount, tfCount: tfCount, saCount: saCount)
                        if (sanitized.multipleChoice.count + sanitized.trueFalse.count + sanitized.shortAnswer.count) > 0 {
                            DispatchQueue.main.async {
                                completion(.success(sanitized))
                            }
                            return
                        }
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
                    let sanitized = GeminiAIService.sanitizeExam(fallback, mcCount: mcCount, tfCount: tfCount, saCount: saCount)
                    completion(.success(sanitized))
                }
            }.resume()
        }
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
    
    // MARK: - Sanitizer: Đảm bảo số lượng câu hỏi và phần thi đúng chính xác theo lựa chọn người dùng
    static func sanitizeExam(_ exam: GeneratedExam, mcCount: Int, tfCount: Int, saCount: Int) -> GeneratedExam {
        let mc = mcCount <= 0 ? [] : Array(exam.multipleChoice.prefix(mcCount))
        let tf = tfCount <= 0 ? [] : Array(exam.trueFalse.prefix(tfCount))
        let sa = saCount <= 0 ? [] : Array(exam.shortAnswer.prefix(saCount))
        return GeneratedExam(
            title: exam.title,
            grade: exam.grade,
            semester: exam.semester,
            subject: exam.subject,
            focusTopic: exam.focusTopic,
            multipleChoice: mc,
            trueFalse: tf,
            shortAnswer: sa
        )
    }
    
    // MARK: - Dynamic Prompt Builder: Tùy biến schema theo đúng phần thi người dùng tích chọn
    static func buildExamPrompt(
        grade: Int,
        semester: Int,
        subject: String,
        focusTopic: String,
        mcCount: Int,
        tfCount: Int,
        saCount: Int,
        webContext: String
    ) -> String {
        let topicText = focusTopic.isEmpty ? "Toàn bộ kiến thức trọng tâm học kỳ \(semester) lớp \(grade)" : focusTopic
        
        var partReqs: [String] = []
        var schemaFields: [String] = []
        
        if mcCount > 0 {
            partReqs.append("1. PHẦN 1 - TRẮC NGHIỆM 4 LỰA CHỌN: Đúng \(mcCount) câu. Mỗi câu có 4 phương án A, B, C, D (chỉ 1 đáp án đúng).")
            schemaFields.append("""
            "multipleChoice": [
              {
                "id": 1,
                "question": "Nội dung câu hỏi trắc nghiệm (sử dụng LaTeX $...$ nếu cần)",
                "options": ["A. ...", "B. ...", "C. ...", "D. ..."],
                "correctIndex": 0,
                "explanation": "Lời giải chi tiết từng bước"
              }
            ]
            """)
        } else {
            partReqs.append("1. PHẦN 1 - TRẮC NGHIỆM: KHÔNG YÊU CẦU. Bắt buộc để multipleChoice = [].")
            schemaFields.append("\"multipleChoice\": []")
        }
        
        if tfCount > 0 {
            partReqs.append("2. PHẦN 2 - TRẮC NGHIỆM ĐÚNG/SAI: Đúng \(tfCount) câu. Mỗi câu gồm 1 ngữ cảnh/bài toán lớn dẫn dắt (context) và 4 ý a, b, c, d với giá trị boolean isCorrectTrue (true hoặc false).")
            schemaFields.append("""
            "trueFalse": [
              {
                "id": 1,
                "context": "Ngữ cảnh đề bài hoặc bài toán thực tế dẫn dắt",
                "statements": [
                  {"id": "a", "statement": "Nhận định ý a", "isCorrectTrue": true, "explanation": "Giải thích chi tiết"},
                  {"id": "b", "statement": "Nhận định ý b", "isCorrectTrue": false, "explanation": "Giải thích chi tiết"},
                  {"id": "c", "statement": "Nhận định ý c", "isCorrectTrue": true, "explanation": "Giải thích chi tiết"},
                  {"id": "d", "statement": "Nhận định ý d", "isCorrectTrue": false, "explanation": "Giải thích chi tiết"}
                ]
              }
            ]
            """)
        } else {
            partReqs.append("2. PHẦN 2 - ĐÚNG/SAI: KHÔNG YÊU CẦU. Bắt buộc để trueFalse = [].")
            schemaFields.append("\"trueFalse\": []")
        }
        
        if saCount > 0 {
            partReqs.append("3. PHẦN 3 - TRẢ LỜI NGẮN: Đúng \(saCount) câu. Yêu cầu tính toán ra một đáp số cụ thể (số hoặc từ khóa ngắn gọn).")
            schemaFields.append("""
            "shortAnswer": [
              {
                "id": 1,
                "question": "Nội dung câu hỏi tính toán ngắn",
                "acceptedAnswers": ["12", "12.0"],
                "unit": "cm",
                "explanation": "Hướng dẫn các bước tính toán chi tiết"
              }
            ]
            """)
        } else {
            partReqs.append("3. PHẦN 3 - TRẢ LỜI NGẮN: KHÔNG YÊU CẦU. Bắt buộc để shortAnswer = [].")
            schemaFields.append("\"shortAnswer\": []")
        }
        
        let schemaJoined = schemaFields.joined(separator: ",\n")
        let partReqsJoined = partReqs.joined(separator: "\n")
        
        return """
        Bạn là Chuyên gia Khảo thí Cao cấp của Bộ Giáo Dục & Đào Tạo Việt Nam, chịu trách nhiệm xây dựng đề thi chuẩn hóa năm học 2025 - 2026 theo chương trình GDPT mới (bộ sách Kết Nối Tri Thức, Cánh Diều, Chân Trời Sáng Tạo).

        \(webContext)

        Thông tin đề thi:
        - Lớp: \(grade)
        - Học kỳ: \(semester)
        - Môn học: \(subject)
        - Trọng tâm ôn tập: "\(topicText)"

        [YÊU CẦU ĐẶC BIỆT VỀ CHẤT LƯỢNG ĐỀ THI - BẮT BUỘC TUÂN THỦ]:
        1. KHÔNG ĐƯỢC BỊA ĐẶT KIẾN THỨC: Toàn bộ công thức, định lý, sự kiện, dữ kiện phải chính xác 100% theo chương trình giáo dục phổ thông Việt Nam năm học 2025 - 2026.
        2. TUYỆT ĐỐI KHÔNG ĐƯỢC TẠO CÁC CÂU HỎI GIỐNG NHAU RỒI ĐỔI SỐ.
        3. PHÂN BỐ MỨC ĐỘ TƯ DUY: Nhận biết, thông hiểu, vận dụng, vận dụng cao.
        4. SỐ LƯỢNG CÂU HỎI CHÍNH XÁC:
        \(partReqsJoined)

        CÔNG THỨC TOÁN/LÝ/HÓA:
        - Sử dụng ký hiệu toán học chuẩn hoặc LaTeX ngắn gọn trong $...$. Không dùng macro LaTeX phức tạp như \\boxed hay \\displaystyle.

        BẮT BUỘC TRẢ VỀ DUY NHẤT 1 ĐỐI TƯỢNG JSON THUẦN TÚY TUÂN THỦ SCHEMA SAU (Không kèm markdown ```json hay giải thích):
        {
          "title": "Đề Khảo Sát \(subject) Lớp \(grade) - Học Kỳ \(semester)",
          "grade": \(grade),
          "semester": \(semester),
          "subject": "\(subject)",
          "focusTopic": "\(focusTopic)",
          \(schemaJoined)
        }
        """
    }
}
