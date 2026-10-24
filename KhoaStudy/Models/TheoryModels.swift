import Foundation

/// Đại diện cho 1 chủ đề / bài học kiến thức trong danh mục lý thuyết
struct TheoryTopicItem: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var summary: String
    var subject: String
    var grade: Int
    var semester: Int
    var videoId: String
    var channelName: String
    var estimatedTime: String
    
    init(
        id: String = UUID().uuidString,
        title: String,
        summary: String,
        subject: String,
        grade: Int,
        semester: Int,
        videoId: String = "",
        channelName: String = "Kênh Bài Giảng Chuẩn Bộ GD&ĐT",
        estimatedTime: String = "20 phút"
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.subject = subject
        self.grade = grade
        self.semester = semester
        self.videoId = videoId
        self.channelName = channelName
        self.estimatedTime = estimatedTime
    }
}

/// Chi tiết toàn bộ bài giảng lý thuyết do AI biên soạn kết hợp Web Search 2026
struct DetailedTheoryLesson: Identifiable, Codable {
    var id: String = UUID().uuidString
    var topicTitle: String
    var subject: String
    var grade: Int
    var semester: Int
    var videoId: String
    var channelName: String
    var markdownContent: String
    var createdAt: Date = Date()
    
    init(
        id: String = UUID().uuidString,
        topicTitle: String,
        subject: String,
        grade: Int,
        semester: Int,
        videoId: String,
        channelName: String,
        markdownContent: String
    ) {
        self.id = id
        self.topicTitle = topicTitle
        self.subject = subject
        self.grade = grade
        self.semester = semester
        self.videoId = videoId
        self.channelName = channelName
        self.markdownContent = markdownContent
        self.createdAt = Date()
    }
}
