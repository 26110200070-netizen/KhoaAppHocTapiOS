import Foundation

struct ChatMessage: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var role: String // "user", "assistant", "system"
    var content: String
    var timestamp: Date = Date()
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
                    completion(false, "Không thể kết nối server: \(error.localizedDescription)")
                } else {
                    completion(false, "Máy chủ phản hồi mã: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                }
            }
        }.resume()
    }
    
    // Send full conversation to DeepSeek API
    func sendChat(
        messages: [ChatMessage],
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
        request.timeoutInterval = 25.0
        
        // Format messages payload for OpenAI-compatible endpoint
        var apiMessages: [[String: String]] = [
            [
                "role": "system",
                "content": "Bạn là Gia Sư Trí Tuệ Nhân Tạo DeepSeek của ứng dụng học tập KhoaStudy. Hãy giải thích chi tiết, chuẩn xác theo chương trình SGK Việt Nam, giọng văn ân cần, khuyến khích học sinh và trình bày rõ ràng từng bước."
            ]
        ]
        
        for msg in messages {
            apiMessages.append(["role": msg.role, "content": msg.content])
        }
        
        let body: [String: Any] = [
            "model": "deepseek-chat",
            "messages": apiMessages,
            "stream": false
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "DeepSeekService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Lỗi mã hóa dữ liệu JSON"])))
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    // Fallback to intelligent local simulation if server is offline
                    let lastUserPrompt = messages.last(where: { $0.role == "user" })?.content ?? ""
                    let fallback = self.generateSmartFallback(for: lastUserPrompt)
                    completion(.success(fallback))
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
                    let lastUserPrompt = messages.last(where: { $0.role == "user" })?.content ?? ""
                    completion(.success(self.generateSmartFallback(for: lastUserPrompt)))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(content))
            }
        }.resume()
    }
    
    // Intelligent educational fallback when local server is disconnected
    private func generateSmartFallback(for prompt: String) -> String {
        return """
        💡 [Gia Sư DeepSeek AI - Chế độ Hỗ trợ Nhanh]:

        Về câu hỏi: "\(prompt)"

        1. **Bản chất kiến thức SGK**: 
        Đây là phần kiến thức quan trọng thường xuất hiện trong đề thi. Bạn cần chú ý định nghĩa cơ bản và phạm vi điều kiện áp dụng.

        2. **Phương pháp giải tối ưu**:
        - Bước 1: Xác định dạng bài và ghi nhớ công thức liên quan.
        - Bước 2: Biến đổi từng bước, chú ý điều kiện nghiệm hoặc các trường hợp đặc biệt.
        - Bước 3: Kiểm tra lại kết quả với dữ kiện đề bài.

        3. **Gợi ý tự ôn tập**:
        Hãy vào phần **Làm Bài Tập** trên KhoaStudy để luyện thêm 5-10 câu trắc nghiệm dạng này nhé!

        *(Mẹo: Hãy chạy file `run_deepseek_server.bat` trên máy tính để kết nối trực tiếp tài khoản DeepSeek của bạn!)*
        """
    }
}
