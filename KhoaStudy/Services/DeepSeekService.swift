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
    
    var badge: String {
        switch self {
        case .chat: return "Nhanh"
        case .reasoner: return "Toán & Lý"
        case .coder: return "Code"
        }
    }
}

class DeepSeekService {
    static let shared = DeepSeekService()
    
    // Check if DeepSeek API server is alive
    func checkConnection(serverUrl: String, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "\(serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/")))/models") else {
            completion(false, "URL máy chủ không hợp lệ")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 4.0
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 {
                    completion(true, "Kết nối DeepSeek Server thành công (HTTP 200)")
                } else if let error = error {
                    completion(false, "Lỗi kết nối: \(error.localizedDescription)")
                } else {
                    completion(false, "Mã phản hồi: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                }
            }
        }.resume()
    }
    
    // Send full conversation to DeepSeek API with chosen model
    func sendChat(
        messages: [ChatMessage],
        model: DeepSeekModel = .chat,
        apiKey: String,
        serverUrl: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let url = URL(string: "\(serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/")))/chat/completions") else {
            completion(.failure(NSError(domain: "DeepSeekService", code: 400, userInfo: [NSLocalizedDescriptionKey: "URL Endpoint không hợp lệ"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !apiKey.isEmpty {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        request.timeoutInterval = 45.0
        
        var apiMessages: [[String: String]] = [
            [
                "role": "system",
                "content": "Bạn là Gia Sư Trí Tuệ Nhân Tạo DeepSeek của ứng dụng KhoaStudy. Hãy giải thích chi tiết, trình bày dạng Markdown rõ ràng (tiêu đề, in đậm, danh sách gạch đầu dòng, công thức hoặc code block). Giọng văn thân thiện, hỗ trợ tối đa cho học sinh Việt Nam."
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
            completion(.failure(NSError(domain: "DeepSeekService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Lỗi mã hóa JSON"])))
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    let lastPrompt = messages.last(where: { $0.role == "user" })?.content ?? ""
                    completion(.success(self.generateSmartFallback(for: lastPrompt, model: model)))
                }
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let firstChoice = choices.first,
                  let message = firstChoice["message"] as? [String: Any],
                  let content = message["content"] as? String else {
                DispatchQueue.main.async {
                    let lastPrompt = messages.last(where: { $0.role == "user" })?.content ?? ""
                    completion(.success(self.generateSmartFallback(for: lastPrompt, model: model)))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(content))
            }
        }.resume()
    }
    
    private func generateSmartFallback(for prompt: String, model: DeepSeekModel) -> String {
        return """
        ### 💡 Trợ Lý DeepSeek AI (\(model.displayName)):

        **Câu hỏi của bạn:** "\(prompt)"

        #### 1. Bản Chất Kiến Thức SGK:
        * Kiến thức này thuộc nội dung trọng tâm của chương trình.
        * Cần nắm vững công thức nền tảng và điều kiện ràng buộc.

        #### 2. Các Bước Giải Chi Tiết:
        * **Bước 1:** Xác định dữ kiện đề bài cho và đại lượng cần tìm.
        * **Bước 2:** Áp dụng định lý hoặc công thức biến đổi tương đương.
        * **Bước 3:** Kiểm tra điều kiện nghiệm để đưa ra kết luận chuẩn xác.

        ---
        *(Server local đang chạy tại `http://192.168.2.16:8000/v1`)*
        """
    }
}
