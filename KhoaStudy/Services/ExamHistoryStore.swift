import Foundation

/// Bản ghi kết quả thi & luyện tập thực tế 100% của học sinh
struct ExamRecord: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var date: Date = Date()
    var subject: String
    var grade: Int
    var semester: Int
    var examTitle: String
    var score: Double // Thang điểm 10.0
    var correctCount: Int
    var totalQuestions: Int
    var durationSeconds: Int
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }
    
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: date)
    }
}

/// Quản lý lưu trữ bền vững lịch sử thi cử thực tế (100% số liệu thật)
final class ExamHistoryStore: ObservableObject {
    static let shared = ExamHistoryStore()
    
    @Published var records: [ExamRecord] = []
    
    private let storageKey = "shimy_real_exam_history_v1"
    
    private init() {
        loadRecords()
    }
    
    func addRecord(
        subject: String,
        grade: Int,
        semester: Int,
        examTitle: String,
        score: Double,
        correctCount: Int,
        totalQuestions: Int,
        durationSeconds: Int
    ) {
        let newRec = ExamRecord(
            subject: subject,
            grade: grade,
            semester: semester,
            examTitle: examTitle,
            score: max(0.0, min(10.0, score)),
            correctCount: correctCount,
            totalQuestions: totalQuestions,
            durationSeconds: durationSeconds
        )
        records.insert(newRec, at: 0)
        
        // Giữ tối đa 50 bài gần nhất
        if records.count > 50 {
            records = Array(records.prefix(50))
        }
        
        saveRecords()
    }
    
    var averageScore: Double? {
        guard !records.isEmpty else { return nil }
        let sum = records.reduce(0.0) { $0 + $1.score }
        return sum / Double(records.count)
    }
    
    var recent5Records: [ExamRecord] {
        return Array(records.prefix(5))
    }
    
    private func saveRecords() {
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let list = try? JSONDecoder().decode([ExamRecord].self, from: data) {
            records = list
        }
    }
    
    func clearAll() {
        records.removeAll()
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
