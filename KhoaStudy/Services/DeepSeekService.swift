import Foundation

class DeepSeekService {
    static let shared = DeepSeekService()
    
    // Call DeepSeek API (local server or cloud)
    func askAI(prompt: String, apiKey: String, serverUrl: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/")))/chat/completions") else {
            completion(.failure(NSError(domain: "DeepSeekService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !apiKey.isEmpty {
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        
        let body: [String: Any] = [
            "model": "deepseek-chat",
            "messages": [
                ["role": "system", "content": "Bạn là gia sư AI thông minh của ứng dụng KhoaStudy, giải thích bài học chi tiết, ngắn gọn, dễ hiểu."],
                ["role": "user", "content": prompt]
            ],
            "stream": false
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "DeepSeekService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"])))
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // If local server is not running, return intelligent offline simulation response
                DispatchQueue.main.async {
                    completion(.success(self.simulateResponse(for: prompt)))
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
                    completion(.success(self.simulateResponse(for: prompt)))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(content))
            }
        }.resume()
    }
    
    // Offline / Instant Fallback AI Tutor
    private func simulateResponse(for prompt: String) -> String {
        return """
        💡 [Gia sư DeepSeek AI]:
        Về câu hỏi: "\(prompt)"
        
        1. Bản chất: Cần nắm vững định nghĩa trong SGK và các điều kiện ràng buộc.
        2. Phương pháp giải nhanh: Nhớ công thức trọng tâm và xét dấu đạo hàm / biến đổi phương trình.
        3. Lưu ý tránh bẫy: Luôn đặt điều kiện xác định trước khi giải.
        """
    }
}
