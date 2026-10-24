import SwiftUI

/// Màn hình học lí thuyết chi tiết: Khung trên là Video YouTube bài giảng, Khung dưới là AI hướng dẫn toàn diện
public struct TheoryLessonDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    public let topicItem: TheoryTopicItem
    
    @State private var detailedLesson: DetailedTheoryLesson? = nil
    @State private var isLoading: Bool = true
    @State private var showingPractice: Bool = false
    
    public init(topicItem: TheoryTopicItem) {
        self.topicItem = topicItem
    }
    
    public var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Custom Navigation Bar
                topNavBar
                
                if isLoading {
                    loadingLessonView
                } else if let lesson = detailedLesson {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            // 1. YouTube Frame: Tỉ lệ 16:9, không khung bao bọc rườm rà (Chuẩn yêu cầu)
                            VStack(alignment: .leading, spacing: 6) {
                                YouTubePlayerView(videoId: lesson.videoId)
                                    .aspectRatio(16/9, contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
                                
                                // Kênh giảng dạy & Chứng nhận
                                HStack(spacing: 6) {
                                    Image(systemName: "play.tv.fill")
                                        .font(.caption2)
                                        .foregroundColor(Color.red)
                                    Text(lesson.channelName)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(hex: "#1F2937"))
                                    Spacer()
                                    HStack(spacing: 4) {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(.green)
                                            .font(.caption2)
                                        Text("Chuẩn SGK 2026")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(hex: "#059669"))
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Capsule().fill(Color(hex: "#D1FAE5")))
                                }
                                .padding(.horizontal, 4)
                                .padding(.top, 2)
                            }
                            
                            // 2. Tiêu đề chủ đề & Thông tin lớp môn
                            VStack(alignment: .leading, spacing: 4) {
                                Text(lesson.topicTitle)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: "#111827"))
                                
                                Text("Lớp \(lesson.grade) • Học kỳ \(lesson.semester) • Môn \(lesson.subject)")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            
                            Divider()
                            
                            // 3. Nội dung AI Hướng Dẫn Chi Tiết (Render Markdown Toán Học Chuẩn)
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 6) {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(AppTheme.primaryMint)
                                    Text("AI Hướng Dẫn Chi Tiết (Tra cứu Web 2026):")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Color(hex: "#111827"))
                                }
                                
                                MarkdownRendererView(content: lesson.markdownContent)
                                    .lineSpacing(5)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                            )
                            
                            // 4. Action Button: Luyện Bài Tập Ngay
                            Button(action: { showingPractice = true }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "pencil.and.outline")
                                        .font(.system(size: 16, weight: .bold))
                                    Text("Luyện Bài Tập Chủ Đề Này Ngay")
                                        .font(.system(size: 15, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(
                                    LinearGradient(
                                        colors: [AppTheme.primaryMint, AppTheme.primaryDark],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 30)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                    }
                }
            }
        }
        .onAppear {
            loadLessonContent()
        }
        .fullScreenCover(isPresented: $showingPractice) {
            ExercisePracticeView()
        }
    }
    
    // Top Bar
    private var topNavBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                    Text("Quay về")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(AppTheme.primaryDark)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
            }
            
            Spacer()
            
            Text("Bài Giảng Lý Thuyết")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
            
            Spacer()
            
            Color.clear.frame(width: 80, height: 36)
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }
    
    // Loading View
    private var loadingLessonView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("ChibiTheory")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            ProgressView()
                .scaleEffect(1.2)
                .tint(AppTheme.primaryMint)
            
            VStack(spacing: 6) {
                Text("AI Đang Tra Cứu Web 2026...")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                Text("Tìm kiếm bài giảng YouTube & đối soát SGK mới cho chủ đề:\n\"\(topicItem.title)\"")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppTheme.textSecondary)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func loadLessonContent() {
        isLoading = true
        TheoryKnowledgeService.shared.generateDetailedLesson(
            topic: topicItem.title,
            subject: topicItem.subject,
            grade: topicItem.grade,
            semester: topicItem.semester,
            geminiApiKey: appState.geminiApiKey,
            groqApiKey: appState.groqApiKey,
            groqModel: appState.selectedGroqModel,
            provider: appState.selectedProvider,
            serverUrl: appState.serverUrl,
            appToken: appState.appAuthToken
        ) { lesson in
            self.detailedLesson = lesson
            self.isLoading = false
        }
    }
}
