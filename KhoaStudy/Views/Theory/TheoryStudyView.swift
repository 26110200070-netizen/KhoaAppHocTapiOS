import SwiftUI

/// Màn hình chọn Lớp, Học kỳ, Môn học và danh sách chuyên đề lý thuyết được AI Web Search chuẩn 2026
struct TheoryStudyView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    // MARK: - Selection State (Như Luyện Bài Tập)
    @State private var selectedGrade: Int = 12
    @State private var selectedSemester: Int = 1
    @State private var selectedSubject: String = "Toán"
    @State private var customTopicInput: String = ""
    
    // Topics List State
    @State private var topicsList: [TheoryTopicItem] = []
    @State private var isLoadingTopics: Bool = false
    
    // Navigation to Detailed Lesson
    @State private var selectedTopicForDetail: TheoryTopicItem? = nil
    
    let subjectList = [
        "Toán", "Vật lí", "Hóa học", "Sinh học", "Tiếng Anh", "Lịch sử", "Địa lí"
    ]
    
    public init() {}
    
    public var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Custom Header
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
                    
                    Text("Học Lí Thuyết AI")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    
                    Spacer()
                    
                    Color.clear.frame(width: 80, height: 36)
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        // Header Banner with Mascot
                        headerBanner
                        
                        // 1. Grade (Lớp 6 - 12) & Semester (Học kỳ 1 & 2)
                        gradeAndSemesterSelector
                        
                        // 2. Subject Selection (Môn học)
                        subjectSelector
                        
                        // 3. Custom Topic Input (Ô nhập liệu khi người dùng muốn học bài ngoài danh sách)
                        customTopicInputSection
                        
                        // 4. Curriculum Topics List (Xổ xuống danh sách kiến thức cần thiết đầy đủ)
                        curriculumTopicsListSection
                        
                        Spacer().frame(height: 50)
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .onAppear {
            selectedGrade = appState.currentUser.grade
            loadCurriculumTopics()
        }
        .onChange(of: selectedGrade) { _ in loadCurriculumTopics() }
        .onChange(of: selectedSemester) { _ in loadCurriculumTopics() }
        .onChange(of: selectedSubject) { _ in loadCurriculumTopics() }
        .sheet(item: $selectedTopicForDetail) { item in
            TheoryLessonDetailView(topicItem: item)
        }
    }
    
    // MARK: - Banner
    private var headerBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image("ChibiTheory")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Học Lí Thuyết Chuẩn SGK 2026")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    Text("Video bài giảng YouTube trực quan kết hợp hướng dẫn chi tiết từ AI.")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            
            // Grounding Badge
            HStack(spacing: 6) {
                Image(systemName: "globe.asia.australia.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#059669"))
                Text("Web Search 2026: Tự động đối chiếu sách mới (KNTT, Cánh Diều, CTST)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(hex: "#065F46"))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#D1FAE5"))
            )
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
    
    // MARK: - Grade & Semester Picker
    private var gradeAndSemesterSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("1. Chọn Lớp Học & Học Kỳ", systemImage: "graduationcap.fill")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color(hex: "#111827"))
            
            // Grade Horizontal Picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(6...12, id: \.self) { g in
                        let isSelected = (selectedGrade == g)
                        Button(action: { selectedGrade = g }) {
                            Text("Lớp \(g)")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(isSelected ? .white : AppTheme.textPrimary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(isSelected ? AppTheme.primaryDark : Color(hex: "#F3F4F6"))
                                )
                        }
                    }
                }
            }
            
            // Semester Picker (Học kỳ 1 & 2)
            HStack(spacing: 10) {
                ForEach([1, 2], id: \.self) { sem in
                    let isSelected = (selectedSemester == sem)
                    Button(action: { selectedSemester = sem }) {
                        HStack {
                            Image(systemName: sem == 1 ? "1.circle.fill" : "2.circle.fill")
                            Text("Học Kỳ \(sem)")
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 13))
                        .foregroundColor(isSelected ? .white : AppTheme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isSelected ? AppTheme.primaryMint : Color(hex: "#F3F4F6"))
                        )
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
    
    // MARK: - Subject Selector
    private var subjectSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("2. Chọn Môn Học", systemImage: "book.fill")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color(hex: "#111827"))
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 95), spacing: 8)], spacing: 8) {
                ForEach(subjectList, id: \.self) { subj in
                    let isSelected = (selectedSubject == subj)
                    Button(action: { selectedSubject = subj }) {
                        Text(subj)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(isSelected ? .white : AppTheme.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(isSelected ? AppTheme.primaryMint : Color(hex: "#F3F4F6"))
                            )
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
    
    // MARK: - Custom Topic Input (Ô nhập liệu khi người dùng muốn học bài ngoài danh sách)
    private var customTopicInputSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("3. Nhập Bài Học Khác (Nếu chưa có trong danh sách)", systemImage: "magnifyingglass")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color(hex: "#111827"))
            
            Text("Bạn muốn học chuyên đề nào? Hãy nhập tên bài học để AI tra cứu ngay:")
                .font(.caption2)
                .foregroundColor(AppTheme.textSecondary)
            
            HStack(spacing: 8) {
                TextField("Ví dụ: Cực trị hàm số, Dao động điều hòa, Axit-Bazơ...", text: $customTopicInput)
                    .font(.system(size: 13.5))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#F9FAFB"))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E5E7EB"), lineWidth: 1))
                    )
                
                Button(action: {
                    searchCustomTopic()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                        Text("Học Ngay")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppTheme.primaryMint)
                    )
                }
                .disabled(customTopicInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
    
    // MARK: - Curriculum Topics List (Xổ xuống danh sách kiến thức cần thiết đầy đủ)
    private var curriculumTopicsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("4. Danh Sách Kiến Thức Đầy Đủ", systemImage: "list.bullet.rectangle.fill")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "#111827"))
                Spacer()
                Text("\(topicsList.count) chuyên đề")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.primaryMint)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(AppTheme.primaryLight))
            }
            
            if isLoadingTopics {
                HStack {
                    Spacer()
                    ProgressView("Đang tra cứu chuyên đề 2026...")
                        .tint(AppTheme.primaryMint)
                        .padding(.vertical, 20)
                    Spacer()
                }
            } else if topicsList.isEmpty {
                VStack(spacing: 8) {
                    Text("Không tìm thấy chuyên đề phù hợp.")
                        .font(.caption)
                        .foregroundColor(AppTheme.textMuted)
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
            } else {
                VStack(spacing: 10) {
                    ForEach(topicsList) { topic in
                        Button(action: {
                            selectedTopicForDetail = topic
                        }) {
                            HStack(alignment: .top, spacing: 12) {
                                // YouTube Play Icon
                                ZStack {
                                    Circle()
                                        .fill(Color.red.opacity(0.12))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.red)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(topic.title)
                                        .font(.system(size: 14.5, weight: .bold))
                                        .foregroundColor(Color(hex: "#111827"))
                                        .multilineTextAlignment(.leading)
                                    
                                    MarkdownRendererView(content: topic.summary)
                                        .font(.caption)
                                        .foregroundColor(AppTheme.textSecondary)
                                        .lineLimit(2)
                                    
                                    HStack(spacing: 8) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "tv")
                                                .font(.caption2)
                                            Text(topic.channelName)
                                                .font(.caption2)
                                                .fontWeight(.medium)
                                        }
                                        .foregroundColor(AppTheme.textMuted)
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 2) {
                                            Text("Học ngay")
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 9, weight: .bold))
                                        }
                                        .foregroundColor(AppTheme.primaryMint)
                                    }
                                    .padding(.top, 2)
                                }
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
                            )
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
    
    // MARK: - Helper Methods
    private func loadCurriculumTopics() {
        isLoadingTopics = true
        TheoryKnowledgeService.shared.fetchCurriculumTopics(
            subject: selectedSubject,
            grade: selectedGrade,
            semester: selectedSemester,
            customQuery: ""
        ) { topics in
            DispatchQueue.main.async {
                self.topicsList = topics
                self.isLoadingTopics = false
            }
        }
    }
    
    private func searchCustomTopic() {
        let clean = customTopicInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }
        
        isLoadingTopics = true
        TheoryKnowledgeService.shared.fetchCurriculumTopics(
            subject: selectedSubject,
            grade: selectedGrade,
            semester: selectedSemester,
            customQuery: clean
        ) { topics in
            DispatchQueue.main.async {
                self.topicsList = topics
                self.isLoadingTopics = false
                if let first = topics.first {
                    self.selectedTopicForDetail = first
                }
            }
        }
    }
}
