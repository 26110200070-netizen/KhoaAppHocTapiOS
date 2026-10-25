import SwiftUI

/// Màn hình học lí thuyết chi tiết: Khung trên là Video YouTube bài giảng, Khung dưới là AI hướng dẫn toàn diện
struct TheoryLessonDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    let topicItem: TheoryTopicItem
    var onBack: (() -> Void)? = nil
    
    @State private var detailedLesson: DetailedTheoryLesson? = nil
    @State private var isLoading: Bool = true
    
    // Practice configuration sheet state
    @State private var showingPracticeConfigSheet: Bool = false
    @State private var includeMultipleChoice: Bool = true
    @State private var includeTrueFalse: Bool = true
    @State private var includeShortAnswer: Bool = true
    @State private var selectedQuestionCount: Int = 10
    
    // Target counts passed to ExercisePracticeView
    @State private var targetMcCount: Int = 5
    @State private var targetTfCount: Int = 3
    @State private var targetSaCount: Int = 2
    @State private var isNavigatingToPractice: Bool = false
    
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
                                
                                // Kênh giảng dạy & Nút xem video trên YouTube (Logic tìm kiếm bài này)
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
                                    
                                    // Thay toàn bộ bằng 1 nút duy nhất: Xem video trên YouTube (Logic tìm kiếm chính xác bài học)
                                    Button(action: {
                                        var comp = URLComponents(string: "https://www.youtube.com/results")
                                        let query = "\(topicItem.title) \(topicItem.subject) lớp \(topicItem.grade) sgk mới"
                                        comp?.queryItems = [URLQueryItem(name: "search_query", value: query)]
                                        if let sUrl = comp?.url {
                                            UIApplication.shared.open(sUrl)
                                        }
                                    }) {
                                        HStack(spacing: 5) {
                                            Image(systemName: "play.rectangle.fill")
                                                .font(.system(size: 11))
                                            Text("Xem video trên YouTube")
                                                .font(.system(size: 11, weight: .bold))
                                            Image(systemName: "arrow.up.right")
                                                .font(.system(size: 9, weight: .bold))
                                        }
                                        .foregroundColor(Color(hex: "#DC2626"))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
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
                            
                            // 4. Action Button: Mở bảng chọn dạng bài & số lượng trước khi luyện tập
                            Button(action: { showingPracticeConfigSheet = true }) {
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
                            .padding(.bottom, 120) // Khoảng cách an toàn lớn đảm bảo nút không bao giờ bị thanh tab bar che khuất
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }
            }
        }
        .onAppear {
            StudyHistoryStore.shared.recordStudy(topic: topicItem)
            loadLessonContent()
        }
        .sheet(isPresented: $showingPracticeConfigSheet) {
            practiceConfigSheetView
        }
        .fullScreenCover(isPresented: $isNavigatingToPractice) {
            ExercisePracticeView(
                initialSubject: topicItem.subject,
                initialGrade: topicItem.grade,
                initialSemester: topicItem.semester,
                initialTopic: topicItem.title,
                initialMcCount: targetMcCount,
                initialTfCount: targetTfCount,
                initialSaCount: targetSaCount,
                autoStart: true
            )
        }
    }
    
    // MARK: - Practice Configuration Sheet View
    private var practiceConfigSheetView: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tùy Chọn Đề Luyện Tập")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    Text("\(topicItem.title) • \(topicItem.subject) Lớp \(topicItem.grade)")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
                Spacer()
                Button(action: { showingPracticeConfigSheet = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }
            }
            .padding(.top, 6)
            
            Divider()
            
            // 1. Dạng câu hỏi (Checkbox)
            VStack(alignment: .leading, spacing: 10) {
                Text("DẠNG CÂU HỎI (TÍCH CHỌN DẠNG BẠN MUỐN LÀM):")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#6B7280"))
                
                // Checkbox 1: Trắc nghiệm 4 lựa chọn
                Button(action: {
                    includeMultipleChoice.toggle()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: includeMultipleChoice ? "checkmark.square.fill" : "square")
                            .font(.system(size: 20))
                            .foregroundColor(includeMultipleChoice ? AppTheme.primaryMint : Color(hex: "#9CA3AF"))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Trắc nghiệm 4 lựa chọn (A, B, C, D)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "#1F2937"))
                            Text("Chọn 1 đáp án đúng duy nhất")
                                .font(.caption2)
                                .foregroundColor(Color(hex: "#6B7280"))
                        }
                        Spacer()
                    }
                    .padding(12)
                    .background(Color(hex: "#F9FAFB"))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
                
                // Checkbox 2: Đúng / Sai
                Button(action: {
                    includeTrueFalse.toggle()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: includeTrueFalse ? "checkmark.square.fill" : "square")
                            .font(.system(size: 20))
                            .foregroundColor(includeTrueFalse ? AppTheme.primaryMint : Color(hex: "#9CA3AF"))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Câu hỏi Đúng / Sai")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "#1F2937"))
                            Text("Mỗi câu gồm 4 ý a, b, c, d chuẩn Bộ GD&ĐT")
                                .font(.caption2)
                                .foregroundColor(Color(hex: "#6B7280"))
                        }
                        Spacer()
                    }
                    .padding(12)
                    .background(Color(hex: "#F9FAFB"))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
                
                // Checkbox 3: Trả lời ngắn
                Button(action: {
                    includeShortAnswer.toggle()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: includeShortAnswer ? "checkmark.square.fill" : "square")
                            .font(.system(size: 20))
                            .foregroundColor(includeShortAnswer ? AppTheme.primaryMint : Color(hex: "#9CA3AF"))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Trả lời ngắn")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "#1F2937"))
                            Text("Học sinh tự điền số hoặc kết quả")
                                .font(.caption2)
                                .foregroundColor(Color(hex: "#6B7280"))
                        }
                        Spacer()
                    }
                    .padding(12)
                    .background(Color(hex: "#F9FAFB"))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            
            // 2. Số lượng câu hỏi (Lựa chọn số lượng câu)
            VStack(alignment: .leading, spacing: 10) {
                Text("LỰA CHỌN SỐ LƯỢNG CÂU:")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#6B7280"))
                
                let counts = [5, 10, 15, 20, 25, 30]
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(counts, id: \.self) { count in
                            let isSelected = (selectedQuestionCount == count)
                            Button(action: {
                                selectedQuestionCount = count
                            }) {
                                Text("\(count) câu")
                                    .font(.system(size: 13, weight: .bold))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(isSelected ? AppTheme.primaryDark : Color(hex: "#F3F4F6"))
                                    )
                                    .foregroundColor(isSelected ? .white : Color(hex: "#374151"))
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            // Nút Bắt đầu làm bài
            let hasSelection = includeMultipleChoice || includeTrueFalse || includeShortAnswer
            Button(action: {
                startPracticeWithSelectedConfig()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 15))
                    Text("Bắt Đầu Làm Bài (\(selectedQuestionCount) câu)")
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
            .disabled(!hasSelection)
            .opacity(hasSelection ? 1.0 : 0.5)
            .padding(.bottom, 12)
        }
        .padding(20)
        .presentationDetents([.medium, .large])
    }
    
    private func startPracticeWithSelectedConfig() {
        let total = selectedQuestionCount
        var mc = 0
        var tf = 0
        var sa = 0
        
        if includeMultipleChoice && includeTrueFalse && includeShortAnswer {
            tf = max(1, Int(round(Double(total) * 0.3)))
            sa = max(1, Int(round(Double(total) * 0.2)))
            mc = max(1, total - tf - sa)
        } else if includeMultipleChoice && includeTrueFalse {
            tf = max(1, Int(round(Double(total) * 0.4)))
            mc = max(1, total - tf)
        } else if includeMultipleChoice && includeShortAnswer {
            sa = max(1, Int(round(Double(total) * 0.3)))
            mc = max(1, total - sa)
        } else if includeTrueFalse && includeShortAnswer {
            sa = max(1, Int(round(Double(total) * 0.4)))
            tf = max(1, total - sa)
        } else if includeMultipleChoice {
            mc = total
        } else if includeTrueFalse {
            tf = total
        } else if includeShortAnswer {
            sa = total
        }
        
        targetMcCount = mc
        targetTfCount = tf
        targetSaCount = sa
        showingPracticeConfigSheet = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isNavigatingToPractice = true
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
            preferredVideoId: topicItem.videoId,
            preferredChannelName: topicItem.channelName,
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
