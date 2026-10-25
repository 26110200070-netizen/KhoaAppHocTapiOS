import SwiftUI

/// Màn hình Học Lý Thuyết: Giao diện phẳng, tinh gọn, không khung lồng khung, kết nối tài liệu trithuctoan môn Toán
struct TheoryStudyView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    var onBackToHome: (() -> Void)? = nil
    
    // MARK: - Selection State
    @State private var selectedGrade: Int = 12
    @State private var selectedSemester: Int = 1
    @State private var selectedSubject: String = "Toán"
    @State private var customTopicInput: String = ""
    
    // Topics List State
    @State private var topicsList: [TheoryTopicItem] = []
    @State private var isLoadingTopics: Bool = false
    
    // In-place Navigation to Detailed Lesson (Không dùng modal sheet kéo lên!)
    @State private var selectedTopicForDetail: TheoryTopicItem? = nil
    
    let subjectList = [
        "Toán", "Vật lí", "Hóa học", "Sinh học", "Lịch sử", "Địa lí"
    ]
    
    init(onBackToHome: (() -> Void)? = nil) {
        self.onBackToHome = onBackToHome
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            if let activeItem = selectedTopicForDetail {
                // Màn hình chi tiết bài học: Chuyển trang trực tiếp mượt mà, KHÔNG KÉO LÊN
                TheoryLessonDetailView(topicItem: activeItem, onBack: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTopicForDetail = nil
                    }
                })
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            } else {
                // Danh sách chuyên đề lý thuyết chính
                VStack(spacing: 0) {
                    // 1. Top Header
                    topHeader
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 18) {
                            // 2. Chọn Lớp (Pill capsules phẳng)
                            gradeSelector
                            
                            // 3. Chọn Học Kỳ & Môn Học
                            semesterAndSubjectSection
                            
                            // 4. Ô Tìm Kiếm / Nhập Chuyên Đề Mới (Spotlight Style, phẳng)
                            searchAndCustomInputBar
                            
                            // 5. Danh Sách Kiến Thức Cần Thiết Đầy Đủ
                            topicsListContent
                            
                            // Khoảng trống dưới đáy tránh bị che bởi thanh Tab Bar
                            Spacer().frame(height: 120)
                        }
                        .padding(.top, 12)
                    }
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
    }
    
    // MARK: - 1. Top Header
    private var topHeader: some View {
        HStack(alignment: .center) {
            if let onBack = onBackToHome {
                Button(action: { onBack() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .bold))
                        Text("Trang Chủ")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(AppTheme.primaryDark)
                }
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text("Học Lí Thuyết")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                Text("\(selectedSubject) • Lớp \(selectedGrade) (HK\(selectedSemester))")
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#6B7280"))
            }
            
            Spacer()
            
            // Badge chuẩn 2026
            HStack(spacing: 4) {
                Circle()
                    .fill(Color(hex: "#10B981"))
                    .frame(width: 6, height: 6)
                Text("SGK 2026")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#059669"))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(Color(hex: "#D1FAE5")))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.white)
        .overlay(Divider(), alignment: .bottom)
    }
    
    // MARK: - 2. Chọn Lớp Học
    private var gradeSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("LỚP HỌC")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(hex: "#9CA3AF"))
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(6...12, id: \.self) { g in
                        let isSelected = (selectedGrade == g)
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                selectedGrade = g
                            }
                        }) {
                            Text("Lớp \(g)")
                                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                .foregroundColor(isSelected ? .white : Color(hex: "#374151"))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? AppTheme.primaryDark : Color(hex: "#F3F4F6"))
                                )
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - 3. Chọn Học Kỳ & Môn Học
    private var semesterAndSubjectSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Học kỳ 1 & 2
            HStack(spacing: 10) {
                ForEach([1, 2], id: \.self) { sem in
                    let isSelected = (selectedSemester == sem)
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            selectedSemester = sem
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: sem == 1 ? "1.circle.fill" : "2.circle.fill")
                                .font(.system(size: 13))
                            Text("Học Kỳ \(sem)")
                                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                        }
                        .foregroundColor(isSelected ? .white : Color(hex: "#4B5563"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(isSelected ? AppTheme.primaryMint : Color(hex: "#F3F4F6"))
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // Môn học (Toán, Lý, Hóa...)
            VStack(alignment: .leading, spacing: 8) {
                Text("MÔN HỌC")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                    .padding(.horizontal, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(subjectList, id: \.self) { subj in
                            let isSelected = (selectedSubject == subj)
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                    selectedSubject = subj
                                }
                            }) {
                                HStack(spacing: 6) {
                                    if subj == "Toán" {
                                        Image(systemName: "function")
                                            .font(.system(size: 12))
                                    }
                                    Text(subj)
                                        .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                }
                                .foregroundColor(isSelected ? .white : Color(hex: "#374151"))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? AppTheme.primaryDark : Color(hex: "#F3F4F6"))
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
    
    // MARK: - 4. Spotlight Search Bar (Phẳng, Không lồng khung)
    private var searchAndCustomInputBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(hex: "#9CA3AF"))
                .font(.system(size: 15))
            
            TextField("Tìm kiếm hoặc nhập chuyên đề mới...", text: $customTopicInput)
                .font(.system(size: 13.5))
                .onSubmit { searchCustomTopic() }
            
            if !customTopicInput.isEmpty {
                Button(action: {
                    customTopicInput = ""
                    loadCurriculumTopics()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }
                
                Button(action: { searchCustomTopic() }) {
                    Text("Học Ngay")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(AppTheme.primaryMint))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "#F3F4F6"))
        )
        .padding(.horizontal, 16)
    }
    
    // MARK: - 5. Danh Sách Bài Học (Dạng List Phẳng Tinh Tế)
    private var topicsListContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("DANH SÁCH BÀI HỌC (\(topicsList.count))")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                
                Spacer()
                
                if isLoadingTopics {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
            
            if topicsList.isEmpty && !isLoadingTopics {
                VStack(spacing: 12) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 38))
                        .foregroundColor(Color(hex: "#D1D5DB"))
                    Text("Chưa có danh mục cho môn học này")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#6B7280"))
                    Text("Bạn có thể nhập tên bài học vào ô tìm kiếm ở trên để AI biên soạn ngay.")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#9CA3AF"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(topicsList.enumerated()), id: \.element.id) { index, item in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTopicForDetail = item
                            }
                        }) {
                            HStack(alignment: .top, spacing: 14) {
                                // Số thứ tự bài học trong vòng tròn nhỏ
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "#ECFDF5"))
                                        .frame(width: 32, height: 32)
                                    Text("\(index + 1)")
                                        .font(.system(size: 13, weight: .bold, design: .rounded))
                                        .foregroundColor(AppTheme.primaryDark)
                                }
                                .padding(.top, 2)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(Color(hex: "#111827"))
                                        .multilineTextAlignment(.leading)
                                    
                                    Text(item.summary)
                                        .font(.system(size: 12.5))
                                        .foregroundColor(Color(hex: "#4B5563"))
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                    
                                    HStack(spacing: 8) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "play.circle.fill")
                                                .foregroundColor(.red)
                                                .font(.system(size: 11))
                                            Text(item.channelName)
                                                .font(.system(size: 11, weight: .medium))
                                                .foregroundColor(Color(hex: "#6B7280"))
                                                .lineLimit(1)
                                        }
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 3) {
                                            Image(systemName: "clock")
                                                .font(.system(size: 10))
                                            Text(item.estimatedTime)
                                                .font(.system(size: 10, weight: .medium))
                                        }
                                        .foregroundColor(Color(hex: "#9CA3AF"))
                                    }
                                    .padding(.top, 2)
                                }
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(hex: "#D1D5DB"))
                                    .padding(.top, 12)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                            .padding(.leading, 62)
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    private func loadCurriculumTopics() {
        isLoadingTopics = true
        TheoryKnowledgeService.shared.fetchCurriculumTopics(
            subject: selectedSubject,
            grade: selectedGrade,
            semester: selectedSemester,
            customQuery: customTopicInput
        ) { topics in
            DispatchQueue.main.async {
                self.topicsList = topics
                self.isLoadingTopics = false
            }
        }
    }
    
    private func searchCustomTopic() {
        let clean = customTopicInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else {
            loadCurriculumTopics()
            return
        }
        loadCurriculumTopics()
    }
}
