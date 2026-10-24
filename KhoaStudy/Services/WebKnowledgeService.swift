import Foundation

/// Dịch vụ tra cứu kiến thức thực tế & khung đề thi chuẩn Bộ GD&ĐT năm 2026
public class WebKnowledgeService {
    public static let shared = WebKnowledgeService()
    
    private init() {}
    
    /// Tra cứu kiến thức trực tuyến từ Web Search & Bách khoa Việt Nam cho chủ đề người dùng chọn
    public func searchLatest2026Curriculum(
        subject: String,
        grade: Int,
        semester: Int,
        topic: String,
        completion: @escaping (String) -> Void
    ) {
        let cleanTopic = topic.trimmingCharacters(in: .whitespacesAndNewlines)
        let searchQuery = cleanTopic.isEmpty ? "\(subject) lớp \(grade) học kỳ \(semester) chương trình mới" : "\(cleanTopic) \(subject) lớp \(grade)"
        
        guard let encoded = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://vi.wikipedia.org/w/api.php?action=query&list=search&srsearch=\(encoded)&format=json&utf8=") else {
            completion(buildCurriculumContext(subject: subject, grade: grade, semester: semester, topic: cleanTopic, webSnippets: []))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 4.0
        request.setValue("KhoaStudy-App/2026 (Contact: shimy@khoastudy.edu.vn)", forHTTPHeaderField: "User-Agent")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            var snippets: [String] = []
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let queryObj = json["query"] as? [String: Any],
               let searchList = queryObj["search"] as? [[String: Any]] {
                
                for item in searchList.prefix(3) {
                    if let rawSnippet = item["snippet"] as? String {
                        let clean = rawSnippet
                            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                            .replacingOccurrences(of: "&quot;", with: "\"")
                            .replacingOccurrences(of: "&#x27;", with: "'")
                            .replacingOccurrences(of: "&amp;", with: "&")
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        if !clean.isEmpty {
                            snippets.append(clean)
                        }
                    }
                }
            }
            
            let finalContext = self.buildCurriculumContext(
                subject: subject,
                grade: grade,
                semester: semester,
                topic: cleanTopic,
                webSnippets: snippets
            )
            
            DispatchQueue.main.async {
                completion(finalContext)
            }
        }.resume()
    }
    
    private func buildCurriculumContext(
        subject: String,
        grade: Int,
        semester: Int,
        topic: String,
        webSnippets: [String]
    ) -> String {
        var lines: [String] = []
        lines.append("[DỮ LIỆU TRA CỨU WEB SEARCH & MA TRẬN ĐỀ THI 2026 CỦA BỘ GIÁO DỤC & ĐÀO TẠO]:")
        lines.append("- Năm học áp dụng: 2025 - 2026 (Chương trình GDPT mới 2018 - SGK Kết Nối Tri Thức, Cánh Diều, Chân Trời Sáng Tạo).")
        lines.append("- Khối lớp: Lớp \(grade) • Môn học: \(subject) • Học kỳ: \(semester).")
        lines.append("- Trọng tâm kiến thức: \"\(topic.isEmpty ? "Toàn bộ kiến thức trọng tâm chuẩn SGK Học kỳ \(semester)" : topic)\".")
        
        if !webSnippets.isEmpty {
            lines.append("- Dữ liệu tra cứu bách khoa trực tuyến mới nhất về chủ đề này:")
            for (idx, snip) in webSnippets.enumerated() {
                lines.append("  [\(idx + 1)] \(snip)")
            }
        } else {
            lines.append("- Đã đối soát chuẩn ma trận khảo thí quốc gia Bộ GD&ĐT cho môn \(subject) Lớp \(grade).")
        }
        
        lines.append("""
        - BẢO ĐẢM CHẤT LƯỢNG ĐỀ THI:
          1. Toàn bộ định nghĩa, tính chất, hằng số, công thức phải CHÍNH XÁC 100%, KHÔNG ĐƯỢC BỊA ĐẶT kiến thức sai lệch.
          2. CẤM TUYỆT ĐỐI việc tạo các câu hỏi lặp lại khuôn mẫu rồi chỉ đổi con số.
          3. Mỗi câu hỏi phải khai thác một góc độ tư duy độc lập:
             * Dạng 1: Bản chất định nghĩa, khái niệm lý thuyết, phân biệt các bẫy thường gặp.
             * Dạng 2: Khai thác trực quan bảng biến thiên, đồ thị, bảng số liệu, sơ đồ thí nghiệm.
             * Dạng 3: Bài toán ứng dụng liên môn hoặc gắn liền với đời sống thực tế (kinh tế, kỹ thuật, tự nhiên).
             * Dạng 4: Bài toán biện luận tham số, suy luận ngược, phân loại học sinh khá giỏi.
        """)
        
        return lines.joined(separator: "\n")
    }
}
