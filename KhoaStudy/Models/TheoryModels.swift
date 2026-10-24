import Foundation

/// Đại diện cho 1 chủ đề / bài học kiến thức trong danh mục lý thuyết
public struct TheoryTopicItem: Identifiable, Codable, Hashable {
    public var id: String
    public var title: String
    public var summary: String
    public var subject: String
    public var grade: Int
    public var semester: Int
    public var videoId: String
    public var channelName: String
    public var estimatedTime: String
    
    public init(
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
public struct DetailedTheoryLesson: Identifiable, Codable {
    public var id: String = UUID().uuidString
    public var topicTitle: String
    public var subject: String
    public var grade: Int
    public var semester: Int
    public var videoId: String
    public var channelName: String
    public var markdownContent: String
    public var createdAt: Date = Date()
    
    public init(
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
