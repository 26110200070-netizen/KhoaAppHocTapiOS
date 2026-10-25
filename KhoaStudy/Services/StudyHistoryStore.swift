import Foundation

/// Đại diện cho 1 bản ghi lịch sử bài học mà người dùng đã từng mở học kèm nội dung bài giảng đã tạo
struct StudyHistoryItem: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var topicItem: TheoryTopicItem
    var savedContent: String? = nil
    var savedVideoId: String? = nil
    var savedChannelName: String? = nil
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
    
    /// Ghi nhận hoặc cập nhật bài học kèm nội dung vào lịch sử
    func recordStudy(topic: TheoryTopicItem, content: String? = nil, videoId: String? = nil, channelName: String? = nil) {
        // Tìm xem bài học đã có trong lịch sử chưa
        if let idx = historyList.firstIndex(where: {
            $0.topicItem.title == topic.title &&
            $0.topicItem.grade == topic.grade &&
            $0.topicItem.semester == topic.semester
        }) {
            var existing = historyList.remove(at: idx)
            existing.timestamp = Date()
            if let c = content, !c.isEmpty { existing.savedContent = c }
            if let v = videoId, !v.isEmpty { existing.savedVideoId = v }
            if let ch = channelName, !ch.isEmpty { existing.savedChannelName = ch }
            historyList.insert(existing, at: 0)
        } else {
            let newItem = StudyHistoryItem(
                id: UUID().uuidString,
                topicItem: topic,
                savedContent: content,
                savedVideoId: videoId,
                savedChannelName: channelName,
                timestamp: Date()
            )
            historyList.insert(newItem, at: 0)
        }
        
        // Giới hạn tối đa 50 bài gần nhất
        if historyList.count > 50 {
            historyList = Array(historyList.prefix(50))
        }
        
        saveHistory()
    }
    
    /// Lấy bài học đã lưu kèm toàn bộ nội dung cũ để mở ngay lập tức không cần loading lại
    func getSavedLesson(for topic: TheoryTopicItem) -> DetailedTheoryLesson? {
        guard let item = historyList.first(where: {
            $0.topicItem.title == topic.title &&
            $0.topicItem.grade == topic.grade &&
            $0.topicItem.semester == topic.semester
        }), let content = item.savedContent, !content.isEmpty else {
            return nil
        }
        
        return DetailedTheoryLesson(
            topicTitle: topic.title,
            subject: topic.subject,
            grade: topic.grade,
            semester: topic.semester,
            videoId: item.savedVideoId ?? topic.videoId,
            channelName: item.savedChannelName ?? topic.channelName,
            markdownContent: content
        )
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
