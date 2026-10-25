import SwiftUI

/// Màn hình học lí thuyết chi tiết: Khung trên là Video YouTube bài giảng, Khung dưới là AI hướng dẫn toàn diện
struct TheoryLessonDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    let topicItem: TheoryTopicItem
    var onBack: (() -> Void)? = nil
    
    @State private var detailedLesson: DetailedTheoryLesson? = nil
    @State private var isLoading: Bool = true
    @State private var showingPractice: Bool = false
    
    init(topicItem: TheoryTopicItem, onBack: (() -> Void)? = nil) {
        self.topicItem = topicItem
        self.onBack = onBack
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Clean Navigation Bar
                topNavBar
                
                if isLoading {
                    loadingLessonView
                } else if let lesson = detailedLesson {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 18) {
                            // 1. YouTube Frame: Tỉ lệ 16:9, không khung bao bọc rườm rà (Chuẩn yêu cầu)
                            VStack(alignment: .leading, spacing: 8) {
                                YouTubePlayerView(videoId: lesson.videoId)
                                    .aspectRatio(16/9, contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                
                                // Kênh giảng dạy & Nút mở YouTube trực tiếp
                                HStack {
                                    HStack(spacing: 6) {
                                        Image(systemName: "play.tv.fill")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                        Text(lesson.channelName)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(hex: "#1F2937"))
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        if let url = URL(string: "https://www.youtube.com/watch?v=\(lesson.videoId)") {
                                            UIApplication.shared.open(url)
                                        }
                                    }) {
                                        HStack(spacing: 4) {
                                            Text("Xem trên YouTube")
                                                .font(.system(size: 11, weight: .bold))
                                            Image(systemName: "arrow.up.right")
                                                .font(.system(size: 10, weight: .bold))
                                        }
                                        .foregroundColor(Color(hex: "#DC2626"))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Capsule().fill(Color(hex: "#FEE2E2")))
                                    }
                                }
                                .padding(.horizontal, 2)
                            }
                            
                            // 2. Tiêu đề chủ đề & Thông tin lớp môn (Hiển thị trực tiếp, không bọc khung)
                            VStack(alignment: .leading, spacing: 6) {
                                Text(lesson.topicTitle)
                                    .font(.system(size: 21, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: "#111827"))
                                
                                HStack(spacing: 8) {
                                    Text("Lớp \(lesson.grade) • Học kỳ \(lesson.semester) • Môn \(lesson.subject)")
                                        .font(.caption)
                                        .foregroundColor(Color(hex: "#6B7280"))
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(.green)
                                            .font(.caption2)
                                        Text("Chuẩn SGK 2026")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(hex: "#059669"))
                                    }
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 2)
                                    .background(Capsule().fill(Color(hex: "#D1FAE5")))
                                }
                            }
                            
                            Divider()
                            
                            // 3. Nội dung AI Hướng Dẫn Chi Tiết (Render Markdown Trực Tiếp, KHÔNG Khung Lồng Khung)
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 6) {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(AppTheme.primaryMint)
                                    Text("Hướng Dẫn Chi Tiết (Tra cứu 2026):")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(Color(hex: "#111827"))
                                }
                                
                                MarkdownRendererView(content: lesson.markdownContent)
                                    .lineSpacing(5)
                            }
                            
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
                                .padding(.vertical, 14)
                                .background(
                                    LinearGradient(
                                        colors: [AppTheme.primaryMint, AppTheme.primaryDark],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 6, x: 0, y: 3)
                            }
                            .padding(.top, 10)
                            .padding(.bottom, 40)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
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
            Button(action: {
                if let onBack = onBack {
                    onBack()
                } else {
                    dismiss()
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                    Text("Danh sách bài học")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(AppTheme.primaryDark)
            }
            
            Spacer()
            
            Button(action: {
                loadLessonContent()
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.primaryDark)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color(hex: "#F3F4F6")))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.white)
        .overlay(Divider(), alignment: .bottom)
    }
    
    // Loading State
    private var loadingLessonView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color(hex: "#E5E7EB"), lineWidth: 4)
                    .frame(width: 64, height: 64)
                
                ProgressView()
                    .scaleEffect(1.3)
                    .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.primaryMint))
            }
            
            VStack(spacing: 6) {
                Text("AI Đang Tra Cứu Web Search 2026...")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                
                Text("Đang tổng hợp kiến thức từ SGK mới & chuẩn bị video bài giảng YouTube cho bạn.")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Actions
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
            DispatchQueue.main.async {
                self.detailedLesson = lesson
                self.isLoading = false
            }
        }
    }
}
