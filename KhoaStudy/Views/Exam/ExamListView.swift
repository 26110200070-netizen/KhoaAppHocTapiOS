import SwiftUI

/// Hệ Thống Ôn Thi Bứt Phá Điểm Cao - Chuẩn Cấu Trúc Bộ GD&ĐT
/// Hỗ trợ chọn Lớp (10, 11, 12), Môn học, Học kì và các loại Đề: Giữa kỳ, Cuối kỳ, Ôn tập chương, Thi thử
/// Thiết kế chuẩn hiện đại: Phẳng, thoáng, KHÔNG khung lồng khung
struct ExamListView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    let curriculum: SubjectCurriculum?
    
    // MARK: - 1. Selection State
    @State private var selectedGrade: Int = 12
    @State private var selectedSubject: String = "Toán"
    @State private var selectedSemester: Int = 1 // 1: Học kì 1, 2: Học kì 2, 0: Cả năm
    @State private var selectedExamCategory: Int = 0 // 0: Giữa kỳ, 1: Cuối kỳ, 2: Ôn tập chương, 3: Thi thử THPT
    
    // MARK: - 2. Active Exam Practice State
    @State private var activeExamTopic: String = ""
    @State private var activeExamSubject: String = "Toán"
    @State private var activeExamGrade: Int = 12
    @State private var activeExamSemester: Int = 1
    @State private var showingExamPractice: Bool = false
    
    // Lists
    let gradeList = [10, 11, 12]
    
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
        ("Thi Thử THPT", "graduationcap.fill", "50 câu • Chuẩn ma trận BGD")
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
                selectedGrade = appState.currentUser.grade
            }
        }
    }
    
    // MARK: - 1. Header Hero Section (Màu đỏ tươi bứt phá điểm cao, chuẩn phong cách)
    private var headerHeroSection: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#DC2626"), Color(hex: "#B91C1C")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            HStack(alignment: .center, spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Text("LUYỆN ĐỀ CHUẨN BỘ GD&ĐT")
                            .font(.system(size: 10, weight: .heavy))
                            .foregroundColor(Color(hex: "#FEF08A"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(Color.black.opacity(0.18)))
                    }
                    
                    Text("Ôn Thi Bứt Phá Điểm Cao 🚀")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Ngân hàng đề thi phân loại theo Lớp, Môn và Học kì giúp bạn làm chủ bài kiểm tra")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.85))
                        .lineLimit(2)
                }
                .padding(18)
                
                Spacer()
                
                Image("ChibiExamBanner")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(.trailing, 16)
            }
        }
        .frame(height: 125)
        .shadow(color: Color(hex: "#DC2626").opacity(0.25), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - 2. Selection Bar: Lớp • Môn • Học kì (Flat, clean, NO nested frames)
    private var selectionBarSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            // A. Chọn Khối Lớp
            VStack(alignment: .leading, spacing: 8) {
                Text("1. Chọn Khối Lớp")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: "#374151"))
                
                HStack(spacing: 10) {
                    ForEach(gradeList, id: \.self) { grade in
                        let isSelected = (selectedGrade == grade)
                        Button(action: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                selectedGrade = grade
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "graduationcap.fill")
                                    .font(.system(size: 12))
                                Text("Lớp \(grade)")
                                    .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 9)
                            .background(
                                Capsule()
                                    .fill(isSelected ? Color(hex: "#0A3E39") : Color.white)
                            )
                            .foregroundColor(isSelected ? .white : Color(hex: "#4B5563"))
                            .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0.03), radius: 6, x: 0, y: 2)
                        }
                    }
                }
            }
            
            // B. Chọn Môn Học
            VStack(alignment: .leading, spacing: 8) {
                Text("2. Chọn Môn Học")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: "#374151"))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(subjectList, id: \.name) { sub in
                            let isSelected = (selectedSubject == sub.name)
                            Button(action: {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                    selectedSubject = sub.name
                                }
                            }) {
                                HStack(spacing: 5) {
                                    Image(systemName: sub.icon)
                                        .font(.system(size: 12))
                                        .foregroundColor(isSelected ? .white : sub.color)
                                    Text(sub.name)
                                        .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? sub.color : Color.white)
                                )
                                .foregroundColor(isSelected ? .white : Color(hex: "#374151"))
                                .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0.03), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
            
            // C. Chọn Học Kì
            VStack(alignment: .leading, spacing: 8) {
                Text("3. Chọn Học Kì")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: "#374151"))
                
                HStack(spacing: 10) {
                    semesterButton(title: "Học Kì 1", semesterIndex: 1)
                    semesterButton(title: "Học Kì 2", semesterIndex: 2)
                    semesterButton(title: "Cả Năm / Tổng Hợp", semesterIndex: 0)
                }
            }
        }
    }
    
    private func semesterButton(title: String, semesterIndex: Int) -> some View {
        let isSelected = (selectedSemester == semesterIndex)
        return Button(action: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                selectedSemester = semesterIndex
            }
        }) {
            Text(title)
                .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(hex: "#059669") : Color.white)
                )
                .foregroundColor(isSelected ? .white : Color(hex: "#4B5563"))
                .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0.03), radius: 5, x: 0, y: 2)
        }
    }
    
    // MARK: - 3. Exam Category Switcher (Giữa kỳ, Cuối kỳ, Ôn tập chương, Thi thử)
    private var examCategorySwitcher: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<examCategories.count, id: \.self) { idx in
                    let cat = examCategories[idx]
                    let isSelected = (selectedExamCategory == idx)
                    Button(action: {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            selectedExamCategory = idx
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: cat.1)
                                .font(.system(size: 13, weight: .bold))
                            Text(cat.0)
                                .font(.system(size: 13, weight: isSelected ? .bold : .semibold))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(isSelected ? Color(hex: "#DC2626") : Color.white)
                        )
                        .foregroundColor(isSelected ? .white : Color(hex: "#4B5563"))
                        .shadow(color: Color.black.opacity(isSelected ? 0.12 : 0.03), radius: 6, x: 0, y: 2)
                    }
                }
            }
            .padding(.vertical, 2)
        }
    }
    
    // MARK: - 4. Exam List Section (Curated dynamic exams)
    private var examListSection: some View {
        let exams = generateCuratedExams()
        
        return VStack(spacing: 14) {
            HStack {
                Text("Danh Sách Đề Thi (\(exams.count) Đề)")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                
                Spacer()
                
                Text("\(selectedSubject) • Lớp \(selectedGrade)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(hex: "#059669"))
            }
            
            ForEach(exams) { exam in
                examCard(exam: exam)
            }
        }
    }
    
    // MARK: - Single Exam Card (Flat, modern, single-layer, NO nested boxes)
    private func examCard(exam: CuratedExamItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Row: Title & Badges
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(exam.categoryBadge)
                            .font(.system(size: 10, weight: .heavy))
                            .foregroundColor(Color(hex: "#DC2626"))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Color(hex: "#FEE2E2")))
                        
                        if exam.isHot {
                            Text("HOT")
                                .font(.system(size: 9, weight: .heavy))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(Color(hex: "#EF4444")))
                        }
                    }
                    
                    Text(exam.title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                        .lineLimit(2)
                }
                
                Spacer()
            }
            
            // Metadata: Thời gian • Số câu • Cấu trúc
            HStack(spacing: 14) {
                HStack(spacing: 5) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(Color(hex: "#6B7280"))
                        .font(.system(size: 11))
                    Text("\(exam.durationMinutes) Phút")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#4B5563"))
                }
                
                Text("•").foregroundColor(Color.gray.opacity(0.4))
                
                HStack(spacing: 5) {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(Color(hex: "#6B7280"))
                        .font(.system(size: 11))
                    Text("\(exam.questionCount) Câu hỏi")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#4B5563"))
                }
                
                Text("•").foregroundColor(Color.gray.opacity(0.4))
                
                Text(exam.difficulty)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#059669"))
            }
            
            // Description of topic coverage
            Text(exam.description)
                .font(.system(size: 12))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(2)
            
            Divider()
            
            // Action Row: Cấu trúc & Nút Làm Đề Ngay
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Ma trận đề chuẩn BGD")
                        .font(.caption2)
                        .foregroundColor(AppTheme.textMuted)
                    Text("Trắc nghiệm + Đúng/Sai + Điền ngắn")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(hex: "#6B7280"))
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
                        Image(systemName: "play.fill")
                            .font(.system(size: 11, weight: .bold))
                        Text("LÀM ĐỀ NGAY")
                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 9)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#DC2626"), Color(hex: "#B91C1C")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: Color(hex: "#DC2626").opacity(0.3), radius: 6, x: 0, y: 3)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 3)
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
        let semName = selectedSemester == 1 ? "Học Kì I" : (selectedSemester == 2 ? "Học Kì II" : "Toàn Diện Cả Năm")
        let sub = selectedSubject
        let gr = selectedGrade
        
        switch selectedExamCategory {
        case 0:
            // Đề Giữa Kỳ
            return [
                CuratedExamItem(
                    title: "Đề Thi Khảo Sát Giữa \(semName) - Môn \(sub) \(gr) (Đề Số 01)",
                    categoryBadge: "GIỮA KÌ",
                    durationMinutes: 45,
                    questionCount: 28,
                    difficulty: "Chuẩn Đề Thi",
                    description: "Trọng tâm kiến thức 4 tuần đầu kỳ: Đầy đủ các mức độ Nhận biết, Thông hiểu và Vận dụng cao.",
                    isHot: true,
                    topicQuery: "Đề kiểm tra giữa kỳ 1 môn \(sub) lớp \(gr) chuẩn cấu trúc bộ giáo dục"
                ),
                CuratedExamItem(
                    title: "Đề Ôn Luyện Trọng Tâm Giữa \(semName) - Môn \(sub) \(gr) (Đề Số 02)",
                    categoryBadge: "GIỮA KÌ",
                    durationMinutes: 45,
                    questionCount: 25,
                    difficulty: "Nâng Cao",
                    description: "Bộ câu hỏi phân hóa điểm 8-9-10 dành cho học sinh khá giỏi ôn luyện bứt phá điểm số.",
                    isHot: false,
                    topicQuery: "Đề thi giữa kỳ môn \(sub) lớp \(gr) câu hỏi phân hóa điểm cao"
                ),
                CuratedExamItem(
                    title: "Đề Thử Sức Nhanh Giữa \(semName) - Môn \(sub) \(gr) (Đề Số 03)",
                    categoryBadge: "GIỮA KÌ",
                    durationMinutes: 45,
                    questionCount: 22,
                    difficulty: "Cơ Bản Chắc Điểm",
                    description: "Rà soát lại toàn bộ công thức và định lý cốt lõi, tránh các bẫy trắc nghiệm phổ biến.",
                    isHot: false,
                    topicQuery: "Đề thi thử giữa kỳ môn \(sub) lớp \(gr) chống điểm liệt và nắm chắc cơ bản"
                )
            ]
            
        case 1:
            // Đề Cuối Kỳ
            return [
                CuratedExamItem(
                    title: "Đề Thi Chính Thức Cuối \(semName) - Môn \(sub) \(gr) (Mã Đề 101)",
                    categoryBadge: "CUỐI KÌ",
                    durationMinutes: 90,
                    questionCount: 40,
                    difficulty: "Tổng Hợp Chuẩn",
                    description: "Bao quát 100% chương trình của \(semName), mô phỏng áp lực phòng thi thật.",
                    isHot: true,
                    topicQuery: "Đề thi học kỳ cuối kỳ môn \(sub) lớp \(gr) đầy đủ kiến thức học kỳ"
                ),
                CuratedExamItem(
                    title: "Đề Khảo Sát Chất Lượng Cuối \(semName) - Các Trường Chuyên (Mã Đề 102)",
                    categoryBadge: "CUỐI KÌ",
                    durationMinutes: 90,
                    questionCount: 40,
                    difficulty: "Phân Hóa Chuyên",
                    description: "Tổng hợp từ đề thi thử học kỳ của các trường THPT Chuyên hàng đầu toàn quốc.",
                    isHot: true,
                    topicQuery: "Đề thi cuối kỳ môn \(sub) lớp \(gr) các trường chuyên trường điểm"
                ),
                CuratedExamItem(
                    title: "Đề Thi Thực Chiến Cuối \(semName) - Bứt Phá Điểm 9+ (Mã Đề 103)",
                    categoryBadge: "CUỐI KÌ",
                    durationMinutes: 90,
                    questionCount: 35,
                    difficulty: "Bứt Phá Điểm Cao",
                    description: "Tập trung các bẫy đề thi, kỹ thuật bấm máy tính cầm tay và tư duy giải nhanh.",
                    isHot: false,
                    topicQuery: "Đề thi cuối kỳ môn \(sub) lớp \(gr) rèn luyện tư duy giải nhanh"
                )
            ]
            
        case 2:
            // Ôn Tập Chương
            let chapterName = sub == "Toán" ? (gr == 12 ? "Khảo Sát Hàm Số & Ứng Dụng Đạo Hàm" : "Hàm Số Lượng Giác & Phương Trình") : "Chuyên Đề Trọng Tâm Chắt Lọc"
            return [
                CuratedExamItem(
                    title: "Ôn Tập Chuyên Đề: \(chapterName)",
                    categoryBadge: "CHUYÊN ĐỀ",
                    durationMinutes: 30,
                    questionCount: 18,
                    difficulty: "Chuyên Sâu",
                    description: "Hệ thống hóa toàn bộ dạng bài thường gặp trong đề thi, từ bài tập nhận biết đến thực tế.",
                    isHot: true,
                    topicQuery: "Bài tập ôn tập chuyên đề \(chapterName) môn \(sub) lớp \(gr)"
                ),
                CuratedExamItem(
                    title: "Kiểm Tra 15 Phút Nhanh: Công Thức & Khái Niệm Cốt Lõi",
                    categoryBadge: "CỦNG CỐ",
                    durationMinutes: 15,
                    questionCount: 12,
                    difficulty: "Khởi Động",
                    description: "Kiểm tra phản xạ lý thuyết và công thức nhanh, giúp học sinh ghi nhớ sâu.",
                    isHot: false,
                    topicQuery: "Kiểm tra 15 phút lý thuyết công thức môn \(sub) lớp \(gr)"
                )
            ]
            
        default:
            // Thi Thử THPT Quốc Gia
            return [
                CuratedExamItem(
                    title: "Đề Thi Thử Tốt Nghiệp THPT - Môn \(sub) (Đề Dự Đoán Số 01)",
                    categoryBadge: "THPT QUỐC GIA",
                    durationMinutes: 50,
                    questionCount: 40,
                    difficulty: "Chuẩn Ma Trận 2025",
                    description: "Cấu trúc đề mới nhất của Bộ GD&ĐT: Trắc nghiệm 4 lựa chọn, Đúng/Sai đa ý và Trả lời ngắn.",
                    isHot: true,
                    topicQuery: "Đề thi thử tốt nghiệp THPT môn \(sub) cấu trúc mới nhất bộ giáo dục"
                ),
                CuratedExamItem(
                    title: "Đề Thi Thử Tốt Nghiệp THPT - Đề Phân Hóa Thủ Khoa (Đề Số 02)",
                    categoryBadge: "THPT QUỐC GIA",
                    durationMinutes: 50,
                    questionCount: 40,
                    difficulty: "Điểm 9 - 10",
                    description: "Rèn luyện tư duy thực tế và bài toán liên môn, tối ưu hóa thời gian làm bài.",
                    isHot: true,
                    topicQuery: "Đề thi thử THPT quốc gia môn \(sub) bứt phá điểm 9 điểm 10"
                )
            ]
        }
    }
}
