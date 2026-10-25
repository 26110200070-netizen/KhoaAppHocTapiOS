import Foundation

/// Đại diện cho 1 bản ghi lịch sử bài học mà người dùng đã từng mở học
struct StudyHistoryItem: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var topicItem: TheoryTopicItem
    var timestamp: Date = Date()
    
    var sectionHeader: String {
        let cal = Calendar.current
        if cal.isDateInToday(timestamp) {
            return "hôm nay"
        } else if cal.isDateInYesterday(timestamp) {
            return "hôm qua"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: timestamp)
        }
    }
    
    var displaySubtitle: String {
        return "Lớp \(topicItem.grade) - Học kì \(topicItem.semester): \(topicItem.title)"
    }
}

/// Quản lý lưu trữ và truy xuất lịch sử học tập bền vững qua UserDefaults
final class StudyHistoryStore: ObservableObject {
    static let shared = StudyHistoryStore()
    
    @Published var historyList: [StudyHistoryItem] = []
    
    private let storageKey = "shimy_study_history_v1"
    
    private init() {
        loadHistory()
    }
    
    /// Ghi nhận 1 bài học vào lịch sử khi người dùng học
    func recordStudy(topic: TheoryTopicItem) {
        // Xóa bản ghi cũ cùng bài học & khối lớp nếu đã tồn tại để đẩy lên đầu
        historyList.removeAll {
            $0.topicItem.title == topic.title &&
            $0.topicItem.grade == topic.grade &&
            $0.topicItem.semester == topic.semester
        }
        
        let newItem = StudyHistoryItem(
            id: UUID().uuidString,
            topicItem: topic,
            timestamp: Date()
        )
        
        historyList.insert(newItem, at: 0)
        
        // Giới hạn tối đa 50 bài gần nhất
        if historyList.count > 50 {
            historyList = Array(historyList.prefix(50))
        }
        
        saveHistory()
    }
    
    /// Xóa 1 bản ghi theo ID (Vuốt sang trái để xóa)
    func remove(id: String) {
        historyList.removeAll { $0.id == id }
        saveHistory()
    }
    
    /// Nhóm danh sách theo ngày học để hiển thị phân mục (-- hôm nay --, -- hôm qua --)
    var groupedSections: [(sectionTitle: String, items: [StudyHistoryItem])] {
        let grouped = Dictionary(grouping: historyList) { $0.sectionHeader }
        
        let sortedKeys = grouped.keys.sorted { k1, k2 in
            if k1 == "hôm nay" { return true }
            if k2 == "hôm nay" { return false }
            if k1 == "hôm qua" { return true }
            if k2 == "hôm qua" { return false }
            return k1 > k2
        }
        
        return sortedKeys.compactMap { key in
            guard let items = grouped[key] else { return nil }
            return (sectionTitle: key, items: items.sorted(by: { $0.timestamp > $1.timestamp }))
        }
    }
    
    private func saveHistory() {
        if let data = try? JSONEncoder().encode(historyList) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([StudyHistoryItem].self, from: data) {
            self.historyList = decoded
        }
    }
}
