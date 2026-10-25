import SwiftUI

struct ExercisePracticeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    // MARK: - 1. Setup Configuration State
    @State private var selectedGrade: Int = 12
    @State private var selectedSemester: Int = 1
    @State private var selectedSubject: String = "Toán"
    @State private var focusTopicInput: String = ""
    
    // Sliders & Steppers
    // min 8, max 20 for Multiple Choice
    @State private var mcCount: Int = 10
    // min 4, max 7 for True/False
    @State private var tfCount: Int = 4
    // min 2, max 6 for Short Answer
    @State private var saCount: Int = 3
    
    // MARK: - 2. Quiz State
    @State private var isGenerating: Bool = false
    @State private var activeExam: GeneratedExam? = nil
    @State private var isExamActive: Bool = false
    @State private var isSubmitted: Bool = false
    
    // Student Answers State
    @State private var studentMCAnswers: [Int: Int] = [:] // Question ID -> Option Index (0..3)
    @State private var studentTFAnswers: [String: Bool] = [:] // "QuestionID:StatementID" -> Bool
    @State private var studentSAAnswers: [Int: String] = [:] // Question ID -> Text Answer
    
    // Navigation / Tab state during exam
    @State private var activeExamPart: Int = 0 // 0: Trắc nghiệm, 1: Đúng/Sai, 2: Trả lời ngắn
    @State private var timeRemainingSeconds: Int = 45 * 60 // 45 minutes
    @State private var timer: Timer? = nil
    @State private var showingQuitConfirmation: Bool = false
    
    // Grading Result
    @State private var calculatedScore: Double = 0.0
    @State private var correctCount: Int = 0
    @State private var totalSubItems: Int = 0
    
    let subjectList = [
        "Toán", "Vật lí", "Hóa học", "Sinh học", "Lịch sử", "Địa lí"
    ]
    
    // Configurable Initializer Parameters
    private var initialSubject: String?
    private var initialGrade: Int?
    private var initialSemester: Int?
    private var initialTopic: String?
    private var initialMcCount: Int?
    private var initialTfCount: Int?
    private var initialSaCount: Int?
    private var autoStart: Bool = false
    var onBackToHome: (() -> Void)? = nil
    
    public init(
        initialSubject: String? = nil,
        initialGrade: Int? = nil,
        initialSemester: Int? = nil,
        initialTopic: String? = nil,
        initialMcCount: Int? = nil,
        initialTfCount: Int? = nil,
        initialSaCount: Int? = nil,
        autoStart: Bool = false,
        onBackToHome: (() -> Void)? = nil
    ) {
        self.initialSubject = initialSubject
        self.initialGrade = initialGrade
        self.initialSemester = initialSemester
        self.initialTopic = initialTopic
        self.initialMcCount = initialMcCount
        self.initialTfCount = initialTfCount
        self.initialSaCount = initialSaCount
        self.autoStart = autoStart
        self.onBackToHome = onBackToHome
        
        let g = initialGrade ?? 11
        let s = initialSemester ?? 1
        let sub = initialSubject ?? "Toán"
        let top = initialTopic ?? ""
        
        _selectedGrade = State(initialValue: g)
        _selectedSemester = State(initialValue: s)
        _selectedSubject = State(initialValue: sub)
        _focusTopicInput = State(initialValue: top)
        if let mc = initialMcCount { _mcCount = State(initialValue: mc) }
        if let tf = initialTfCount { _tfCount = State(initialValue: tf) }
        if let sa = initialSaCount { _saCount = State(initialValue: sa) }
    }
    
    public var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            if isGenerating {
                generatingAILoadingView
            } else if !isExamActive {
                examSetupView
            } else if !isSubmitted {
                examTakingView
            } else {
                examGradingReviewView
            }
        }
        .onAppear {
            if let g = initialGrade {
                selectedGrade = g
            } else {
                selectedGrade = appState.currentUser.grade
            }
            if let s = initialSemester {
                selectedSemester = s
            }
            if let subj = initialSubject {
                selectedSubject = subj
            }
            if let top = initialTopic {
                focusTopicInput = top
            }
            if let mc = initialMcCount {
                mcCount = mc
            }
            if let tf = initialTfCount {
                tfCount = tf
            }
            if let sa = initialSaCount {
                saCount = sa
            }
            if autoStart && !isExamActive && !isGenerating && activeExam == nil {
                startAIGeneration()
            }
        }
        .alert("Thoát Bài Thi?", isPresented: $showingQuitConfirmation) {
            Button("Ở Lại Làm Tiếp", role: .cancel) {}
            Button("Thoát", role: .destructive) {
                timer?.invalidate()
                isExamActive = false
                isSubmitted = false
                activeExam = nil
            }
        } message: {
            Text("Nếu thoát ngay bây giờ, tiến trình làm bài của bạn sẽ không được lưu.")
        }
    }
    
    // =====================================================================
    // MARK: - SCREEN 1: EXAM SETUP & TOPIC INPUT
    // =====================================================================
    private var examSetupView: some View {
        VStack(spacing: 0) {
            // Custom Top Bar with Back to Home Button
            HStack(alignment: .center) {
                Button(action: {
                    if let onBack = onBackToHome {
                        onBack()
                    } else {
                        dismiss()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .bold))
                        Text("Trang Chủ")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(AppTheme.primaryDark)
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text("Luyện Bài Tập AI")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    Text("\(selectedSubject) • Lớp \(selectedGrade) (HK\(selectedSemester))")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "#6B7280"))
                }
                
                Spacer()
                
                // Badge đề 2026
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color(hex: "#10B981"))
                        .frame(width: 6, height: 6)
                    Text("Đề 2026")
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
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    // Header Banner with Chibi Practice Mascot (Flat, borderless)
                    HStack(spacing: 12) {
                        Image("ChibiPractice")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tạo Đề Thi Theo Yêu Cầu")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#111827"))
                            Text("Shimy tra cứu dữ liệu mới nhất 2026 của Bộ GD&ĐT để biên soạn đề chuẩn xác, không trùng lặp.")
                                .font(.caption)
                                .foregroundColor(AppTheme.textSecondary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    
                    // 1. Grade (Lớp 6 - 12)
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
                                            .font(.system(size: 13, weight: .bold))
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
                    
                    // 2. Semester & Subject
                    VStack(alignment: .leading, spacing: 10) {
                        Text("HỌC KỲ & MÔN HỌC")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(hex: "#9CA3AF"))
                            .padding(.horizontal, 16)
                        
                        HStack(spacing: 8) {
                            ForEach([1, 2], id: \.self) { sem in
                                let isSelected = (selectedSemester == sem)
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                        selectedSemester = sem
                                    }
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: sem == 1 ? "1.circle.fill" : "2.circle.fill")
                                        Text("Học kỳ \(sem)")
                                    }
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(isSelected ? .white : Color(hex: "#374151"))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(isSelected ? AppTheme.primaryMint : Color(hex: "#F3F4F6"))
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // Subject horizontal scroll
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(subjectList, id: \.self) { subj in
                                    let isSelected = (selectedSubject == subj)
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                            selectedSubject = subj
                                        }
                                    }) {
                                        Text(subj)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(isSelected ? .white : Color(hex: "#4B5563"))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 7)
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
                    
                    // 3. Focus Topic Input (Chủ đề cần ôn)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("CHỦ ĐỀ CẦN ÔN TẬP")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(hex: "#9CA3AF"))
                            .padding(.horizontal, 16)
                        
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "#9CA3AF"))
                                .padding(.top, 4)
                            
                            ZStack(alignment: .topLeading) {
                                if focusTopicInput.isEmpty {
                                    Text("Nhập nội dung cần ôn (ví dụ: Tập hợp và số tự nhiên, Cực trị hàm số, Dao động điều hòa...) hoặc để trống để AI bao quát toàn bộ học kỳ")
                                        .font(.system(size: 13))
                                        .foregroundColor(Color(hex: "#9CA3AF"))
                                }
                                
                                TextEditor(text: $focusTopicInput)
                                    .font(.system(size: 13))
                                    .frame(minHeight: 56)
                                    .background(Color.clear)
                            }
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#F9FAFB"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 16)
                    }
                    
                    // 4. Cấu trúc đề thi
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("CẤU TRÚC ĐỀ THI")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(hex: "#9CA3AF"))
                            
                            Spacer()
                            
                            Text("Tổng: \(mcCount + tfCount + saCount) câu")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(AppTheme.primaryDark)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(AppTheme.primaryLight))
                        }
                        .padding(.horizontal, 16)
                        
                        VStack(spacing: 12) {
                            stepperRow(
                                title: "Trắc nghiệm 4 lựa chọn (A, B, C, D)",
                                value: $mcCount,
                                range: 8...20,
                                desc: "Tối thiểu 8 câu • Tối đa 20 câu"
                            )
                            
                            Divider()
                            
                            stepperRow(
                                title: "Câu hỏi Đúng / Sai (4 ý a, b, c, d)",
                                value: $tfCount,
                                range: 4...7,
                                desc: "Tối thiểu 4 câu • Tối đa 7 câu"
                            )
                            
                            Divider()
                            
                            stepperRow(
                                title: "Câu hỏi Trả lời ngắn (Điền số)",
                                value: $saCount,
                                range: 2...6,
                                desc: "Tối thiểu 2 câu • Tối đa 6 câu"
                            )
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#F9FAFB"))
                        )
                        .padding(.horizontal, 16)
                    }
                    
                    // 5. Action Button: TẠO ĐỀ THI
                    Button(action: { startAIGeneration() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 17, weight: .bold))
                            Text("Bắt Đầu Tạo Đề Thi Với AI")
                                .font(.system(size: 16, weight: .bold))
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
                        .clipShape(Capsule())
                        .shadow(color: AppTheme.primaryMint.opacity(0.35), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    
                    // Khoảng trống dưới cùng tránh bị che bởi thanh tab bar
                    Spacer().frame(height: 120)
                }
            }
        }
    }
    
    private func stepperRow(title: String, value: Binding<Int>, range: ClosedRange<Int>, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "#111827"))
                    Text(desc)
                        .font(.caption2)
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: {
                        if value.wrappedValue > range.lowerBound {
                            value.wrappedValue -= 1
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(value.wrappedValue > range.lowerBound ? AppTheme.primaryDark : AppTheme.textMuted)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Color(hex: "#F3F4F6")))
                    }
                    .disabled(value.wrappedValue <= range.lowerBound)
                    
                    Text("\(value.wrappedValue)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                        .frame(minWidth: 24)
                    
                    Button(action: {
                        if value.wrappedValue < range.upperBound {
                            value.wrappedValue += 1
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(value.wrappedValue < range.upperBound ? AppTheme.primaryDark : AppTheme.textMuted)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Color(hex: "#F3F4F6")))
                    }
                    .disabled(value.wrappedValue >= range.upperBound)
                }
            }
        }
    }
    
    // =====================================================================
    // MARK: - SCREEN 2: LOADING / AI GENERATING
    // =====================================================================
    private var generatingAILoadingView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("ChibiPractice")
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110)
                .scaleEffect(1.05)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isGenerating)
            
            VStack(spacing: 8) {
                Text("AI Đang Biên Soạn Đề Thi...")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                
                Text("Tra cứu chuẩn 2026 • Lớp \(selectedGrade) • Môn \(selectedSubject)\nChuyên đề: \"\(focusTopicInput.isEmpty ? "Toàn bộ chương trình Học kỳ \(selectedSemester)" : focusTopicInput)\"")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppTheme.textSecondary)
                    .padding(.horizontal, 32)
            }
            
            ProgressView()
                .scaleEffect(1.2)
                .tint(AppTheme.primaryMint)
                .padding(.vertical, 4)
            
            // Steps indicator
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "globe")
                        .foregroundColor(Color(hex: "#059669"))
                    Text("Web Search 2026: Tra cứu kiến thức SGK Bộ GD&ĐT mới nhất")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#374151"))
                }
                HStack(spacing: 8) {
                    Image(systemName: "shuffle")
                        .foregroundColor(Color(hex: "#2563EB"))
                    Text("Đa dạng hóa câu hỏi: Phân bố cấp độ, tuyệt đối không lặp dạng")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#374151"))
                }
                HStack(spacing: 8) {
                    Image(systemName: "function")
                        .foregroundColor(Color(hex: "#D97706"))
                    Text("Chuẩn hóa công thức Toán / Lý / Hóa và lời giải chi tiết")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#374151"))
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
            )
            .padding(.horizontal, 24)
            
            Text("Quy mô: \(mcCount) câu trắc nghiệm • \(tfCount) câu đúng/sai • \(saCount) câu ngắn")
                .font(.caption2)
                .foregroundColor(AppTheme.textMuted)
            
            Spacer()
        }
        .padding()
    }
    
    // =====================================================================
    // MARK: - SCREEN 3: EXAM TAKING INTERACTION
    // =====================================================================
    private var examTakingView: some View {
        VStack(spacing: 0) {
            // Exam Header with Timer & Quit Alert
            HStack {
                Button(action: { showingQuitConfirmation = true }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.primaryDark)
                        .padding(8)
                        .background(Circle().fill(Color.white))
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(activeExam?.title ?? "Bài Kiểm Tra")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                        .lineLimit(1)
                    Text("Lớp \(selectedGrade) • Môn \(selectedSubject)")
                        .font(.caption2)
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
                
                // Countdown Timer Pill
                HStack(spacing: 4) {
                    Image(systemName: "timer")
                        .font(.caption2)
                    Text(formattedTime(timeRemainingSeconds))
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                }
                .foregroundColor(.red)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.red.opacity(0.08)))
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)
            
            // Part Switcher Tabs (Trắc nghiệm / Đúng Sai / Trả lời ngắn)
            HStack(spacing: 8) {
                if (activeExam?.multipleChoice.count ?? 0) > 0 {
                    tabButton(title: "Trắc Nghiệm (\(activeExam?.multipleChoice.count ?? 0))", partIndex: 0)
                }
                if (activeExam?.trueFalse.count ?? 0) > 0 {
                    tabButton(title: "Đúng / Sai (\(activeExam?.trueFalse.count ?? 0))", partIndex: 1)
                }
                if (activeExam?.shortAnswer.count ?? 0) > 0 {
                    tabButton(title: "Trả Lời Ngắn (\(activeExam?.shortAnswer.count ?? 0))", partIndex: 2)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            
            // Questions Scroll View (Tự động cuộn lên đầu khi chuyển tab trắc nghiệm / đúng sai / trả lời ngắn)
            ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Anchor cuộn lên đầu trang
                        Color.clear
                            .frame(height: 1)
                            .id("EXAM_QUESTIONS_TOP_ANCHOR")
                        
                        if activeExamPart == 0 {
                            // Part 1: Multiple Choice Questions
                            ForEach(activeExam?.multipleChoice ?? []) { q in
                                mcQuestionCard(q)
                            }
                        } else if activeExamPart == 1 {
                            // Part 2: True / False Questions
                            ForEach(activeExam?.trueFalse ?? []) { q in
                                tfQuestionCard(q)
                            }
                        } else {
                            // Part 3: Short Answer Questions
                            ForEach(activeExam?.shortAnswer ?? []) { q in
                                saQuestionCard(q)
                            }
                        }
                        
                        Spacer().frame(height: 100)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                .onChange(of: activeExamPart) { _ in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        scrollProxy.scrollTo("EXAM_QUESTIONS_TOP_ANCHOR", anchor: .top)
                    }
                }
            }
            
            // Bottom Sticky Bar: Submit Button
            VStack(spacing: 8) {
                Divider()
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Đã trả lời: \(completedAnswerCount) / \(activeExam?.totalQuestionCount ?? 0) câu")
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                        Text(selectedSubject)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "#111827"))
                    }
                    
                    Spacer()
                    
                    Button(action: { submitExam() }) {
                        Text("Nộp Bài")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(AppTheme.primaryMint)
                            )
                            .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 14)
            }
            .background(Color.white)
        }
    }
    
    private func tabButton(title: String, partIndex: Int) -> some View {
        let isSelected = (activeExamPart == partIndex)
        return Button(action: { activeExamPart = partIndex }) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? Color(hex: "#059669") : Color(hex: "#6B7280"))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(hex: "#D1FAE5") : Color(hex: "#F3F4F6"))
                )
        }
    }
    
    // Multiple Choice Card (Taste-Skill Anti-Slop: Flat, single-layer, airy typography, NO nested boxes)
    private func mcQuestionCard(_ q: MultipleChoiceQuestion) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 6) {
                Text("CÂU \(q.id)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#059669"))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color(hex: "#D1FAE5")))
                
                Text("Trắc nghiệm 4 phương án")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "#6B7280"))
                
                Spacer()
            }
            
            MarkdownRendererView(content: q.question)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "#111827"))
            
            VStack(spacing: 8) {
                ForEach(0..<q.options.count, id: \.self) { optIdx in
                    let isChosen = (studentMCAnswers[q.id] == optIdx)
                    Button(action: {
                        studentMCAnswers[q.id] = optIdx
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(isChosen ? Color(hex: "#0A3E39") : Color.white)
                                    .frame(width: 26, height: 26)
                                    .overlay(
                                        Circle()
                                            .stroke(isChosen ? Color(hex: "#0A3E39") : Color(hex: "#D1D5DB"), lineWidth: 1)
                                    )
                                Text(["A", "B", "C", "D"][optIdx % 4])
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(isChosen ? .white : Color(hex: "#374151"))
                            }
                            
                            MarkdownRendererView(content: q.options[optIdx])
                                .font(.system(size: 14, weight: isChosen ? .semibold : .regular))
                                .foregroundColor(isChosen ? Color(hex: "#0A3E39") : Color(hex: "#1F2937"))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 11)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(isChosen ? Color(hex: "#F0FDF4") : Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(isChosen ? Color(hex: "#10B981") : Color(hex: "#E5E7EB"), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                )
        )
    }
    
    // True/False Card (Taste-Skill Anti-Slop: Flat editorial context, clean hairline rows, NO nested box-in-a-box)
    private func tfQuestionCard(_ q: TrueFalseQuestion) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 6) {
                Text("CÂU \(q.id)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#0284C7"))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color(hex: "#E0F2FE")))
                
                Text("Đúng / Sai 4 ý a, b, c, d")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "#6B7280"))
                
                Spacer()
            }
            
            HStack(alignment: .top, spacing: 10) {
                Rectangle()
                    .fill(Color(hex: "#0284C7"))
                    .frame(width: 3)
                    .cornerRadius(1.5)
                
                MarkdownRendererView(content: q.context)
                    .font(.system(size: 14.5))
                    .foregroundColor(Color(hex: "#1F2937"))
            }
            .padding(.vertical, 2)
            
            VStack(spacing: 0) {
                ForEach(Array(q.statements.enumerated()), id: \.element.id) { index, stmt in
                    let answerKey = "\(q.id):\(stmt.id)"
                    let chosenVal = studentTFAnswers[answerKey]
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if index > 0 {
                            Divider().padding(.vertical, 4)
                        }
                        
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(stmt.id))")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(hex: "#374151"))
                            
                            MarkdownRendererView(content: stmt.statement)
                                .font(.system(size: 13.5))
                                .foregroundColor(Color(hex: "#1F2937"))
                        }
                        
                        HStack(spacing: 8) {
                            Spacer()
                            Button(action: { studentTFAnswers[answerKey] = true }) {
                                HStack(spacing: 4) {
                                    Image(systemName: chosenVal == true ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 11))
                                    Text("Đúng")
                                        .font(.system(size: 12, weight: chosenVal == true ? .bold : .medium))
                                }
                                .foregroundColor(chosenVal == true ? .white : Color(hex: "#059669"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule().fill(chosenVal == true ? Color(hex: "#059669") : Color(hex: "#D1FAE5"))
                                )
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: { studentTFAnswers[answerKey] = false }) {
                                HStack(spacing: 4) {
                                    Image(systemName: chosenVal == false ? "xmark.circle.fill" : "circle")
                                        .font(.system(size: 11))
                                    Text("Sai")
                                        .font(.system(size: 12, weight: chosenVal == false ? .bold : .medium))
                                }
                                .foregroundColor(chosenVal == false ? .white : Color(hex: "#DC2626"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule().fill(chosenVal == false ? Color(hex: "#DC2626") : Color(hex: "#FEE2E2"))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                )
        )
    }
    
    // Short Answer Card (Taste-Skill Anti-Slop: Clean field, no clutter)
    private func saQuestionCard(_ q: ShortAnswerQuestion) -> some View {
        let binding = Binding<String>(
            get: { studentSAAnswers[q.id] ?? "" },
            set: { studentSAAnswers[q.id] = $0 }
        )
        
        return VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 6) {
                Text("CÂU \(q.id)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#7C3AED"))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color(hex: "#EDE9FE")))
                
                Text("Trả lời ngắn (Điền đáp số)")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "#6B7280"))
                
                Spacer()
            }
            
            MarkdownRendererView(content: q.question)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "#111827"))
            
            HStack(spacing: 8) {
                TextField("Điền kết quả số...", text: binding)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "#D1D5DB"), lineWidth: 1)
                    )
                
                if let unit = q.unit, !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "#4B5563"))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                )
        )
    }
    
    // =====================================================================
    // MARK: - SCREEN 4: GRADING & STEP-BY-STEP EXPLANATION
    // =====================================================================
    private var examGradingReviewView: some View {
        VStack(spacing: 0) {
            reviewHeader
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    reviewScoreCard
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Text("AI Sửa Từng Câu & Hướng Dẫn Giải:")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        
                        reviewMultipleChoiceSection
                        reviewTrueFalseSection
                        reviewShortAnswerSection
                    }
                    
                    Spacer().frame(height: 30)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
        }
    }
    
    private var reviewHeader: some View {
        HStack {
            Button(action: {
                isSubmitted = false
                isExamActive = false
                activeExam = nil
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                    Text("Tạo đề khác")
                }
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(AppTheme.primaryDark)
            }
            
            Spacer()
            
            Text("Kết Quả & Lời Giải Chi Tiết")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Text("Đóng")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.textSecondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }
    
    private var reviewScoreCard: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(Color(hex: "#E5E7EB"), lineWidth: 10)
                    .frame(width: 110, height: 110)
                
                Circle()
                    .trim(from: 0, to: CGFloat(calculatedScore / 10.0))
                    .stroke(
                        scoreColor,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 110, height: 110)
                
                VStack(spacing: 0) {
                    Text(String(format: "%.1f", calculatedScore))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    Text("/ 10.0")
                        .font(.caption2)
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            
            Text(scoreAssessmentText)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(scoreColor)
            
            HStack(spacing: 20) {
                statBadge(label: "Đúng", val: "\(correctCount)", color: .green)
                statBadge(label: "Sai / Bỏ sót", val: "\(totalSubItems - correctCount)", color: .red)
                statBadge(label: "Môn", val: selectedSubject, color: .blue)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
        )
    }
    
    private var scoreAssessmentText: String {
        if calculatedScore >= 8.0 {
            return "Xuất Sắc! Nắm rất vững kiến thức."
        } else if calculatedScore >= 5.0 {
            return "Đạt yêu cầu! Cần ôn luyện thêm."
        } else {
            return "Cần xem kỹ lại lời giải chi tiết bên dưới."
        }
    }
    
    private var scoreColor: Color {
        if calculatedScore >= 8.0 {
            return Color(hex: "#059669")
        } else if calculatedScore >= 5.0 {
            return Color(hex: "#D97706")
        } else {
            return Color(hex: "#DC2626")
        }
    }
    
    private func optionLetter(_ index: Int) -> String {
        let letters = ["A", "B", "C", "D"]
        guard index >= 0 && index < letters.count else { return "A" }
        return letters[index]
    }
    
    @ViewBuilder
    private var reviewMultipleChoiceSection: some View {
        if let questions = activeExam?.multipleChoice, !questions.isEmpty {
            ForEach(questions) { q in
                let studentAns = studentMCAnswers[q.id]
                let isCorrect = (studentAns == q.correctIndex)
                let studentLetter = (studentAns != nil && studentAns! >= 0 && studentAns! < 4) ? optionLetter(studentAns!) : "Chưa chọn"
                let correctLetter = optionLetter(q.correctIndex)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Text("CÂU \(q.id)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(isCorrect ? Color(hex: "#059669") : Color(hex: "#DC2626"))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(isCorrect ? Color(hex: "#D1FAE5") : Color(hex: "#FEE2E2")))
                        
                        Text(isCorrect ? "Đúng (+0.25đ)" : "Chưa chính xác")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(isCorrect ? Color(hex: "#059669") : Color(hex: "#DC2626"))
                        
                        Spacer()
                    }
                    
                    MarkdownRendererView(content: q.question)
                        .font(.system(size: 14.5))
                        .foregroundColor(Color(hex: "#111827"))
                    
                    HStack(spacing: 16) {
                        Text("Bạn chọn: ")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#6B7280"))
                        + Text(studentLetter)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(isCorrect ? Color(hex: "#059669") : Color(hex: "#DC2626"))
                        
                        Spacer()
                        
                        Text("Đáp án đúng: ")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#6B7280"))
                        + Text(correctLetter)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(hex: "#059669"))
                    }
                    .padding(.vertical, 4)
                    
                    // Explanation: Editorial left border line, no box-in-box
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hướng dẫn giải:")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(hex: "#374151"))
                        MarkdownRendererView(content: q.explanation)
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#4B5563"))
                    }
                    .padding(.leading, 10)
                    .overlay(
                        Rectangle()
                            .fill(Color(hex: "#10B981"))
                            .frame(width: 2.5),
                        alignment: .leading
                    )
                    .padding(.top, 4)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    @ViewBuilder
    private var reviewTrueFalseSection: some View {
        if let tfQuestions = activeExam?.trueFalse, !tfQuestions.isEmpty {
            ForEach(tfQuestions) { q in
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Text("CÂU \(q.id)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(hex: "#0284C7"))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(Color(hex: "#E0F2FE")))
                        
                        Text("Đúng / Sai")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(hex: "#4B5563"))
                        
                        Spacer()
                    }
                    
                    MarkdownRendererView(content: q.context)
                        .font(.system(size: 14.5))
                        .foregroundColor(Color(hex: "#111827"))
                    
                    ForEach(q.statements) { stmt in
                        let chosen = studentTFAnswers["\(q.id):\(stmt.id)"]
                        let isCorrect = (chosen == stmt.isCorrectTrue)
                        let chosenText = chosen == true ? "Đúng" : (chosen == false ? "Sai" : "Chưa chọn")
                        let actualText = stmt.isCorrectTrue ? "Đúng" : "Sai"
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(isCorrect ? Color(hex: "#059669") : Color(hex: "#DC2626"))
                                    .font(.system(size: 13))
                                    .padding(.top, 2)
                                
                                MarkdownRendererView(content: "**\(stmt.id))** " + stmt.statement)
                                    .font(.system(size: 13.5))
                                    .foregroundColor(Color(hex: "#1F2937"))
                                
                                Spacer()
                                
                                Text(actualText)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(stmt.isCorrectTrue ? Color(hex: "#059669") : Color(hex: "#DC2626"))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Capsule().fill(stmt.isCorrectTrue ? Color(hex: "#D1FAE5") : Color(hex: "#FEE2E2")))
                            }
                            
                            HStack(spacing: 12) {
                                Text("Bạn chọn: \(chosenText)")
                                    .font(.system(size: 11))
                                    .foregroundColor(isCorrect ? Color(hex: "#059669") : Color(hex: "#DC2626"))
                                
                                Text("•")
                                    .foregroundColor(Color.gray.opacity(0.3))
                                    .font(.system(size: 10))
                                
                                Text(stmt.explanation)
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(hex: "#6B7280"))
                                    .lineLimit(2)
                            }
                            .padding(.leading, 22)
                        }
                        .padding(.vertical, 4)
                        
                        if stmt.id != q.statements.last?.id {
                            Divider().padding(.leading, 22)
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    @ViewBuilder
    private var reviewShortAnswerSection: some View {
        if let saQuestions = activeExam?.shortAnswer, !saQuestions.isEmpty {
            ForEach(saQuestions) { q in
                let studentAns = studentSAAnswers[q.id]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let isCorrect = q.acceptedAnswers.contains(where: { $0.lowercased() == studentAns.lowercased() })
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Text("CÂU \(q.id)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(hex: "#7C3AED"))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(Color(hex: "#EDE9FE")))
                        
                        Text(isCorrect ? "Đúng (+0.25đ)" : "Chưa chính xác")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(isCorrect ? Color(hex: "#059669") : Color(hex: "#DC2626"))
                        
                        Spacer()
                    }
                    
                    MarkdownRendererView(content: q.question)
                        .font(.system(size: 14.5))
                        .foregroundColor(Color(hex: "#111827"))
                    
                    HStack(spacing: 16) {
                        Text("Bạn điền: ")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#6B7280"))
                        + Text(studentAns.isEmpty ? "(Bỏ trống)" : studentAns)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(isCorrect ? Color(hex: "#059669") : Color(hex: "#DC2626"))
                        
                        Spacer()
                        
                        Text("Đáp số chuẩn: ")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#6B7280"))
                        + Text("\(q.acceptedAnswers.first ?? "") \(q.unit ?? "")")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(hex: "#059669"))
                    }
                    .padding(.vertical, 4)
                    
                    // Explanation with left accent bar
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hướng dẫn giải:")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(hex: "#374151"))
                        MarkdownRendererView(content: q.explanation)
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#4B5563"))
                    }
                    .padding(.leading, 10)
                    .overlay(
                        Rectangle()
                            .fill(Color(hex: "#7C3AED"))
                            .frame(width: 2.5),
                        alignment: .leading
                    )
                    .padding(.top, 4)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                        )
                )
            }
        }
    }

    
    private func statBadge(label: String, val: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(val)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(AppTheme.textSecondary)
        }
    }
    
    // =====================================================================
    // MARK: - LOGIC METHODS
    // =====================================================================
    private var completedAnswerCount: Int {
        let mc = studentMCAnswers.count
        let tf = Set(studentTFAnswers.keys.map { $0.components(separatedBy: ":").first ?? "" }).count
        let sa = studentSAAnswers.filter { !$0.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }.count
        return mc + tf + sa
    }
    
    private func formattedTime(_ totalSec: Int) -> String {
        let m = totalSec / 60
        let s = totalSec % 60
        return String(format: "%02d:%02d", m, s)
    }
    
    private func startAIGeneration() {
        isGenerating = true
        
        GeminiAIService.shared.generateExamWithAI(
            grade: selectedGrade,
            semester: selectedSemester,
            subject: selectedSubject,
            focusTopic: focusTopicInput,
            mcCount: mcCount,
            tfCount: tfCount,
            saCount: saCount,
            appToken: appState.appAuthToken,
            serverUrl: appState.serverUrl,
            provider: appState.selectedProvider,
            geminiApiKey: appState.geminiApiKey,
            groqApiKey: appState.groqApiKey,
            groqModel: appState.selectedGroqModel
        ) { result in
            isGenerating = false
            switch result {
            case .success(let exam):
                self.activeExam = exam
                self.studentMCAnswers.removeAll()
                self.studentTFAnswers.removeAll()
                self.studentSAAnswers.removeAll()
                self.isExamActive = true
                self.isSubmitted = false
                if !(exam.multipleChoice.isEmpty) {
                    self.activeExamPart = 0
                } else if !(exam.trueFalse.isEmpty) {
                    self.activeExamPart = 1
                } else {
                    self.activeExamPart = 2
                }
                self.timeRemainingSeconds = 45 * 60
                
                // Start countdown timer
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
                    if self.timeRemainingSeconds > 0 {
                        self.timeRemainingSeconds -= 1
                    } else {
                        t.invalidate()
                        self.submitExam()
                    }
                }
            case .failure:
                // Fallback exam
                let fallback = CuratedStandardExamProvider.getStandardExam(
                    grade: selectedGrade,
                    semester: selectedSemester,
                    subject: selectedSubject,
                    focusTopic: focusTopicInput,
                    mcCount: mcCount,
                    tfCount: tfCount,
                    saCount: saCount
                )
                self.activeExam = fallback
                self.isExamActive = true
                if !(fallback.multipleChoice.isEmpty) {
                    self.activeExamPart = 0
                } else if !(fallback.trueFalse.isEmpty) {
                    self.activeExamPart = 1
                } else {
                    self.activeExamPart = 2
                }
            }
        }
    }
    
    private func submitExam() {
        timer?.invalidate()
        guard let exam = activeExam else { return }
        
        var totalPoints: Double = 0.0
        var maxPossiblePoints: Double = 0.0
        var correct = 0
        var totalItems = 0
        
        // 1. Score Part 1: Multiple Choice (0.25 pt each)
        for q in exam.multipleChoice {
            maxPossiblePoints += 1.0
            totalItems += 1
            if let chosen = studentMCAnswers[q.id], chosen == q.correctIndex {
                totalPoints += 1.0
                correct += 1
            }
        }
        
        // 2. Score Part 2: True/False (Ministry formula: 1 correct=0.1, 2=0.25, 3=0.5, 4=1.0)
        for q in exam.trueFalse {
            maxPossiblePoints += 1.0
            var stmtCorrect = 0
            for stmt in q.statements {
                totalItems += 1
                if let chosen = studentTFAnswers["\(q.id):\(stmt.id)"], chosen == stmt.isCorrectTrue {
                    stmtCorrect += 1
                    correct += 1
                }
            }
            switch stmtCorrect {
            case 1: totalPoints += 0.1
            case 2: totalPoints += 0.25
            case 3: totalPoints += 0.5
            case 4: totalPoints += 1.0
            default: break
            }
        }
        
        // 3. Score Part 3: Short Answer
        for q in exam.shortAnswer {
            maxPossiblePoints += 1.0
            totalItems += 1
            let studentText = studentSAAnswers[q.id]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if !studentText.isEmpty && q.acceptedAnswers.contains(where: { $0.lowercased() == studentText.lowercased() }) {
                totalPoints += 1.0
                correct += 1
            }
        }
        
        // Scale to 10.0
        let normalizedScore = maxPossiblePoints > 0 ? (totalPoints / maxPossiblePoints) * 10.0 : 0.0
        self.calculatedScore = normalizedScore
        self.correctCount = correct
        self.totalSubItems = totalItems
        self.isSubmitted = true
        
        // Lưu kết quả thi thực tế 100% vào ExamHistoryStore để phục vụ Sơ Đồ Thống Kê
        let spentSeconds = max(10, (45 * 60) - max(0, timeRemainingSeconds))
        let title = focusTopicInput.isEmpty ? "Đề luyện thi \(selectedSubject) Lớp \(selectedGrade)" : focusTopicInput
        ExamHistoryStore.shared.addRecord(
            subject: selectedSubject,
            grade: selectedGrade,
            semester: selectedSemester,
            examTitle: title,
            score: normalizedScore,
            correctCount: correct,
            totalQuestions: totalItems,
            durationSeconds: spentSeconds
        )
    }
}
