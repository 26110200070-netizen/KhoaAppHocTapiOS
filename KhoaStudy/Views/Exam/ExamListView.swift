import SwiftUI

/// Hệ Thống Ôn Thi Bứt Phá Điểm Cao - Chuẩn Cấu Trúc Bộ GD&ĐT
/// Hỗ trợ chọn Lớp (10, 11, 12), Môn học, Học kì và các loại Đề: Giữa kỳ, Cuối kỳ, Ôn tập chương, Thi thử
/// Thiết kế chuẩn hiện đại: Phẳng, thoáng, KHÔNG khung lồng khung
struct ExamListView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    let curriculum: SubjectCurriculum?
    
    // MARK: - 1. Selection State
    @State private var selectedGrade: Int = 11
    @State private var selectedSubject: String = "Toán"
    @State private var selectedSemester: Int = 1 // 1: Học kì 1, 2: Học kì 2, 0: Cả năm
    @State private var selectedExamCategory: Int = 0 // 0: Giữa kỳ, 1: Cuối kỳ, 2: Ôn tập chương, 3: Thi thử THPT
    
    // MARK: - 2. Active Exam Practice State
    @State private var activeExamTopic: String = ""
    @State private var activeExamSubject: String = "Toán"
    @State private var activeExamGrade: Int = 11
    @State private var activeExamSemester: Int = 1
    @State private var showingExamPractice: Bool = false
    @State private var hasInitializedGrade: Bool = false
    
    // Lists
    let gradeList = [6, 7, 8, 9, 10, 11, 12]
    
    let subjectList: [(name: String, icon: String, color: Color)] = [
        ("Toán", "function", Color(hex: "#0284C7")),
        ("Vật lí", "bolt.fill", Color(hex: "#7C3AED")),
        ("Hóa học", "flame.fill", Color(hex: "#EA580C")),
        ("Sinh học", "leaf.fill", Color(hex: "#059669")),
        ("Lịch sử", "hourglass", Color(hex: "#DC2626")),
        ("Địa lí", "globe.asia.australia.fill", Color(hex: "#0D9488")),
        ("Tiếng Anh", "character.book.closed.fill", Color(hex: "#2563EB"))
    ]
    
    let examCategories = [
        ("Đề Giữa Kỳ", "clock.badge.checkmark", "45 phút • Trọng tâm 50% kiến thức"),
        ("Đề Cuối Kỳ", "doc.text.fill", "90 phút • Bao quát toàn bộ học kỳ"),
        ("Ôn Tập Chương", "list.bullet.rectangle.portrait", "30 phút • Chuyên sâu từng chuyên đề"),
        ("Thi Thử / Khảo Sát", "graduationcap.fill", "Chuẩn ma trận đề thi BGD")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F8FAF9")
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // 1. Hero Title Banner
                        headerHeroSection
                        
                        // 2. Selectors: Lớp • Môn • Học kì (Flat Chips, NO nested borders)
                        selectionBarSection
                        
                        // 3. Exam Category Switcher (Giữa kỳ, Cuối kỳ, Ôn tập chương, Thi thử)
                        examCategorySwitcher
                        
                        // 4. List of Curated Exams
                        examListSection
                        
                        Spacer().frame(height: 50)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .bold))
                            Text("Trang Chủ")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(AppTheme.primaryDark)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Ôn Thi Bứt Phá Điểm Cao")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.textPrimary)
                }
            }
            .fullScreenCover(isPresented: $showingExamPractice) {
                ExercisePracticeView(
                    initialSubject: activeExamSubject,
                    initialGrade: activeExamGrade,
                    initialSemester: activeExamSemester,
                    initialTopic: activeExamTopic,
                    autoStart: true,
                    onBackToHome: {
                        showingExamPractice = false
                    }
                )
            }
            .onAppear {
                if !hasInitializedGrade {
                    selectedGrade = appState.currentUser.grade
                    activeExamGrade = appState.currentUser.grade
                    hasInitializedGrade = true
                }
            }
        }
    }
    
    // MARK: - 1. Header Hero Section (Quiet, typography-driven, no nested boxes)
    private var headerHeroSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color(hex: "#DC2626"))
                    .frame(width: 6, height: 6)
                Text("LUYỆN ĐỀ CHUẨN BỘ GD&ĐT")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#DC2626"))
                    .tracking(0.6)
            }
            
            Text("Ôn Thi Bứt Phá Điểm Cao")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
            
            Text("Ngân hàng đề thi phân loại theo Lớp, Môn và Học kì bám sát ma trận trithucAI giúp bạn làm chủ bài kiểm tra.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color(hex: "#6B7280"))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 6)
    }
    
    // MARK: - 2. Selection Bar: Lớp • Môn • Học kì (Flat, single-layer, NO nested capsules)
    private var selectionBarSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            // A. Chọn Khối Lớp (Lớp 6 đến Lớp 12)
            VStack(alignment: .leading, spacing: 8) {
                Text("KHỐI LỚP")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#6B7280"))
                    .tracking(0.5)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(gradeList, id: \.self) { grade in
                            let isSelected = (selectedGrade == grade)
                            Button(action: {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                    selectedGrade = grade
                                    activeExamGrade = grade
                                }
                            }) {
                                Text("Lớp \(grade)")
                                    .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(isSelected ? Color(hex: "#111827") : Color.white)
                                    .foregroundColor(isSelected ? .white : Color(hex: "#374151"))
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(Color(hex: isSelected ? "#111827" : "#E5E7EB"), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            
            // B. Chọn Môn Học
            VStack(alignment: .leading, spacing: 8) {
                Text("MÔN HỌC")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#6B7280"))
                    .tracking(0.5)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(subjectList, id: \.name) { sub in
                            let isSelected = (selectedSubject == sub.name)
                            Button(action: {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                    selectedSubject = sub.name
                                }
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: sub.icon)
                                        .font(.system(size: 12))
                                        .foregroundColor(isSelected ? .white : sub.color)
                                    Text(sub.name)
                                        .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(isSelected ? sub.color : Color.white)
                                .foregroundColor(isSelected ? .white : Color(hex: "#374151"))
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke(Color(hex: isSelected ? "#00000000" : "#E5E7EB"), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            
            // C. Chọn Học Kì
            VStack(alignment: .leading, spacing: 8) {
                Text("HỌC KÌ")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#6B7280"))
                    .tracking(0.5)
                
                HStack(spacing: 8) {
                    semesterButton(title: "Học Kì 1", semesterIndex: 1)
                    semesterButton(title: "Học Kì 2", semesterIndex: 2)
                    semesterButton(title: "Cả Năm", semesterIndex: 0)
                    Spacer()
                }
            }
        }
    }
    
    private func semesterButton(title: String, semesterIndex: Int) -> some View {
        let isSelected = (selectedSemester == semesterIndex)
        return Button(action: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                selectedSemester = semesterIndex
                activeExamSemester = semesterIndex == 0 ? 1 : semesterIndex
            }
        }) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color(hex: "#059669") : Color.white)
                .foregroundColor(isSelected ? .white : Color(hex: "#374151"))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(hex: isSelected ? "#059669" : "#E5E7EB"), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - 3. Exam Category Switcher (Giữa kỳ, Cuối kỳ, Ôn tập chương, Thi thử)
    private var examCategorySwitcher: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<examCategories.count, id: \.self) { idx in
                    let cat = examCategories[idx]
                    let isSelected = (selectedExamCategory == idx)
                    Button(action: {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                            selectedExamCategory = idx
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: cat.1)
                                .font(.system(size: 12, weight: .semibold))
                            Text(cat.0)
                                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(isSelected ? Color(hex: "#DC2626") : Color.white)
                        .foregroundColor(isSelected ? .white : Color(hex: "#4B5563"))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color(hex: isSelected ? "#DC2626" : "#E5E7EB"), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - 4. Exam List Section (Curated dynamic exams)
    private var examListSection: some View {
        let exams = generateCuratedExams()
        
        return VStack(spacing: 12) {
            HStack {
                Text("DANH SÁCH ĐỀ THI")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#6B7280"))
                    .tracking(0.5)
                
                Spacer()
                
                Text("\(exams.count) đề • \(selectedSubject) Lớp \(selectedGrade)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(hex: "#059669"))
            }
            .padding(.top, 4)
            
            ForEach(exams) { exam in
                examCard(exam: exam)
            }
        }
    }
    
    // MARK: - Single Exam Card (Flat, single-layer, typography-driven, NO nested boxes)
    private func examCard(exam: CuratedExamItem) -> some View {
        HStack(spacing: 0) {
            // Subtle left accent bar
            Rectangle()
                .fill(Color(hex: "#DC2626"))
                .frame(width: 3.5)
            
            VStack(alignment: .leading, spacing: 10) {
                // Typographic breadcrumb header: NO nested capsule pill
                HStack(spacing: 6) {
                    Text("\(exam.categoryBadge) • \(exam.durationMinutes) PHÚT • \(exam.questionCount) CÂU")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "#DC2626"))
                        .tracking(0.5)
                    
                    if exam.isHot {
                        Text("• HOT")
                            .font(.system(size: 11, weight: .heavy))
                            .foregroundColor(Color(hex: "#EF4444"))
                    }
                    
                    Spacer()
                }
                
                // Title
                Text(exam.title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                    .fixedSize(horizontal: false, vertical: true)
                
                // Description of topic coverage
                Text(exam.description)
                    .font(.system(size: 12.5))
                    .foregroundColor(Color(hex: "#4B5563"))
                    .lineLimit(2)
                
                Divider()
                
                // Bottom row: Difficulty info & Action button
                HStack(alignment: .center) {
                    HStack(spacing: 5) {
                        Circle()
                            .fill(Color(hex: "#059669"))
                            .frame(width: 6, height: 6)
                        Text(exam.difficulty)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(hex: "#374151"))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        activeExamTopic = exam.topicQuery
                        activeExamSubject = selectedSubject
                        activeExamGrade = selectedGrade
                        activeExamSemester = selectedSemester == 0 ? 1 : selectedSemester
                        showingExamPractice = true
                    }) {
                        HStack(spacing: 5) {
                            Text("Bắt đầu làm")
                                .font(.system(size: 12.5, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 11, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(hex: "#DC2626"))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(14)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
        )
    }
    
    // MARK: - Dynamic Exam Data Generator
    private struct CuratedExamItem: Identifiable {
        let id = UUID()
        let title: String
        let categoryBadge: String
        let durationMinutes: Int
        let questionCount: Int
        let difficulty: String
        let description: String
        let isHot: Bool
        let topicQuery: String
    }
    
    private func generateCuratedExams() -> [CuratedExamItem] {
        let semVal = selectedSemester == 0 ? 1 : selectedSemester
        let semName = selectedSemester == 1 ? "Học Kì I" : (selectedSemester == 2 ? "Học Kì II" : "Toàn Diện Cả Năm")
        let sub = selectedSubject
        let gr = selectedGrade
        
        // Lấy danh sách các chuyên đề thật 100% từ trithucAI qua SubjectCurriculumStore
        let realTopics = SubjectCurriculumStore.shared.getTopics(subject: sub, grade: gr, semester: semVal)
        let mainTopicTitles = realTopics.map { $0.title }
        let topicsPreview = mainTopicTitles.prefix(3).joined(separator: ", ")
        
        switch selectedExamCategory {
        case 0:
            // Đề Giữa Kỳ (Bám sát 50% kiến thức học kỳ từ trithucAI)
            let midQuery = !mainTopicTitles.isEmpty ? "Kiến thức giữa kì bám sát trithucAI: \(topicsPreview)" : "Đề thi giữa kì môn \(sub) lớp \(gr)"
            return [
                CuratedExamItem(
                    title: "Đề Thi Khảo Sát Giữa \(semName) - Môn \(sub) \(gr) (Đề Chuẩn 01)",
                    categoryBadge: "GIỮA KÌ",
                    durationMinutes: 45,
                    questionCount: 28,
                    difficulty: "Chuẩn Đề Thi",
                    description: "Trọng tâm kiến thức chuẩn trithucAI: \(topicsPreview.isEmpty ? "Đầy đủ nhận biết, thông hiểu và vận dụng." : topicsPreview).",
                    isHot: true,
                    topicQuery: midQuery
                ),
                CuratedExamItem(
                    title: "Đề Ôn Luyện Phân Hóa Giữa \(semName) - Môn \(sub) \(gr) (Đề 02)",
                    categoryBadge: "GIỮA KÌ",
                    durationMinutes: 45,
                    questionCount: 25,
                    difficulty: "Nâng Cao",
                    description: "Tập trung các câu hỏi vận dụng và bẫy đề thi hay gặp trong chương trình \(sub) \(gr).",
                    isHot: false,
                    topicQuery: "Đề thi giữa kì nâng cao môn \(sub) lớp \(gr) chuẩn trithucAI"
                ),
                CuratedExamItem(
                    title: "Đề Rà Soát Cơ Bản Giữa \(semName) - Môn \(sub) \(gr) (Đề 03)",
                    categoryBadge: "GIỮA KÌ",
                    durationMinutes: 45,
                    questionCount: 20,
                    difficulty: "Cơ Bản Chắc Điểm",
                    description: "Chống điểm liệt, rà soát lại toàn bộ công thức và định lý cốt lõi của \(semName).",
                    isHot: false,
                    topicQuery: "Đề kiểm tra giữa kỳ cơ bản môn \(sub) lớp \(gr) trithucAI"
                )
            ]
            
        case 1:
            // Đề Cuối Kỳ (Bao quát 100% kiến thức từ trithucAI)
            let allTopicsQuery = !mainTopicTitles.isEmpty ? "Kiến thức cuối kì toàn diện trithucAI: \(mainTopicTitles.prefix(5).joined(separator: "; "))" : "Đề thi cuối kì môn \(sub) lớp \(gr)"
            return [
                CuratedExamItem(
                    title: "Đề Thi Chính Thức Cuối \(semName) - Môn \(sub) \(gr) (Mã Đề 101)",
                    categoryBadge: "CUỐI KÌ",
                    durationMinutes: 90,
                    questionCount: 40,
                    difficulty: "Tổng Hợp Chuẩn",
                    description: "Bao quát toàn bộ chuyên đề theo giáo trình trithucAI, mô phỏng phòng thi thật.",
                    isHot: true,
                    topicQuery: allTopicsQuery
                ),
                CuratedExamItem(
                    title: "Đề Khảo Sát Trường Chuyên Cuối \(semName) - Môn \(sub) \(gr) (Mã Đề 102)",
                    categoryBadge: "CUỐI KÌ",
                    durationMinutes: 90,
                    questionCount: 40,
                    difficulty: "Phân Hóa Chuyên",
                    description: "Đề phân hóa điểm 8-9-10 từ các trường THPT Chuyên trên toàn quốc theo chuẩn BGD.",
                    isHot: true,
                    topicQuery: "Đề thi học kỳ chuyên sâu môn \(sub) lớp \(gr) trithucAI"
                ),
                CuratedExamItem(
                    title: "Đề Bứt Phá Điểm 9+ Cuối \(semName) - Môn \(sub) \(gr) (Mã Đề 103)",
                    categoryBadge: "CUỐI KÌ",
                    durationMinutes: 90,
                    questionCount: 35,
                    difficulty: "Bứt Phá Điểm 9+",
                    description: "Rèn luyện tư duy phản xạ nhanh, bẫy trắc nghiệm và phương pháp giải toán thực tế.",
                    isHot: false,
                    topicQuery: "Đề thi cuối kỳ điểm cao môn \(sub) lớp \(gr) trithucAI"
                )
            ]
            
        case 2:
            // Ôn Tập Chương (LẤY TỪNG CHUYÊN ĐỀ THẬT TỪ trithucAI)
            if !realTopics.isEmpty {
                return realTopics.prefix(5).enumerated().map { index, topicItem in
                    CuratedExamItem(
                        title: "Ôn Tập Chuyên Đề: \(topicItem.title)",
                        categoryBadge: "CHUYÊN ĐỀ",
                        durationMinutes: 30,
                        questionCount: 20,
                        difficulty: "Chuyên Sâu",
                        description: topicItem.summary.isEmpty ? "Bộ câu hỏi trắc nghiệm rèn luyện chuyên sâu chủ đề \(topicItem.title)." : topicItem.summary,
                        isHot: index == 0,
                        topicQuery: "Chuyên đề \(topicItem.title) môn \(sub) lớp \(gr) chuẩn trithucAI SGK"
                    )
                }
            } else {
                let defaultChapter = sub == "Toán" ? "Hàm số và Đạo hàm" : "Kiến thức trọng tâm"
                return [
                    CuratedExamItem(
                        title: "Ôn Tập Chuyên Đề: \(defaultChapter)",
                        categoryBadge: "CHUYÊN ĐỀ",
                        durationMinutes: 30,
                        questionCount: 18,
                        difficulty: "Chuyên Sâu",
                        description: "Hệ thống hóa toàn bộ dạng bài tập thường gặp trong đề thi.",
                        isHot: true,
                        topicQuery: "Ôn tập chuyên đề \(defaultChapter) môn \(sub) lớp \(gr)"
                    )
                ]
            }
            
        default:
            let catName = gr == 12 ? "THPT QUỐC GIA" : "KHẢO SÁT CHẤT LƯỢNG"
            let examName = gr == 12 ? "Đề Thi Thử Tốt Nghiệp THPT - Môn \(sub)" : "Đề Thi Khảo Sát Năng Lực - Môn \(sub) \(gr)"
            return [
                CuratedExamItem(
                    title: "\(examName) (Đề Dự Đoán 01)",
                    categoryBadge: catName,
                    durationMinutes: 50,
                    questionCount: 40,
                    difficulty: "Chuẩn Ma Trận",
                    description: "Đề bám sát 100% tài liệu trithucAI: Trắc nghiệm 4 lựa chọn, Đúng/Sai đa ý và Điền đáp án ngắn cho học sinh lớp \(gr).",
                    isHot: true,
                    topicQuery: "Đề thi thử khảo sát chất lượng môn \(sub) lớp \(gr) học kì \(semVal) chuẩn cấu trúc mới trithucAI"
                ),
                CuratedExamItem(
                    title: "\(examName) - Phân Hóa Điểm 9-10 (Đề Số 02)",
                    categoryBadge: catName,
                    durationMinutes: 50,
                    questionCount: 40,
                    difficulty: "Điểm 9 - 10",
                    description: "Tập trung các câu hỏi vận dụng cao, bài toán thực tế và phân hóa sâu chương trình lớp \(gr).",
                    isHot: true,
                    topicQuery: "Đề thi khảo sát nâng cao môn \(sub) lớp \(gr) học kì \(semVal) trithucAI"
                )
            ]
        }
    }
}
