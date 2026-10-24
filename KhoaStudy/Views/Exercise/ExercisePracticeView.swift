import SwiftUI

public struct ExercisePracticeView: View {
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
        "Toán", "Vật lí", "Hóa học", "Sinh học", "Tiếng Anh", "Lịch sử", "Địa lí"
    ]
    
    public init() {}
    
    public var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
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
            selectedGrade = appState.currentUser.grade
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
            // Custom Top Bar with Back Button
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
                
                Text("Luyện Bài Tập AI")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                
                Spacer()
                
                // Placeholder to balance title
                Color.clear.frame(width: 80, height: 36)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    // Header Banner with Mascot Art
                    HStack(spacing: 12) {
                        Image("ChibiPractice")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 74, height: 74)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tạo Đề Thi Theo Yêu Cầu")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#111827"))
                            Text("Shimy tra cứu toàn bộ SGK & tài liệu chuẩn để biên soạn đề thi riêng cho bạn.")
                                .font(.caption)
                                .foregroundColor(AppTheme.textSecondary)
                        }
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    )
                    
                    // 1. Grade (Lớp 6 - 12) & Semester
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
                    
                    // 2. Subject Selection
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
                    
                    // 3. Focus Topic Input (Người dùng nhập kiến thức cần ôn)
                    VStack(alignment: .leading, spacing: 10) {
                        Label("3. Nhập Kiến Thức Bạn Cần Ôn Tập", systemImage: "pencil.and.outline")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(hex: "#111827"))
                        
                        Text("AI sẽ tập trung ra câu hỏi bám sát chủ đề bạn yêu cầu:")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                        
                        ZStack(alignment: .topLeading) {
                            if focusTopicInput.isEmpty {
                                Text("Nhập nội dung bạn muốn ôn (ví dụ: Cực trị hàm số, Dao động điều hòa, Axit-Bazơ, Thì quá khứ hoàn thành, Cuộc kháng chiến chống Pháp...)")
                                    .font(.system(size: 13))
                                    .foregroundColor(AppTheme.textMuted)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                            }
                            
                            TextEditor(text: $focusTopicInput)
                                .font(.system(size: 14))
                                .frame(minHeight: 85)
                                .padding(8)
                                .background(Color.clear)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(hex: "#F9FAFB"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                                )
                        )
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    )
                    
                    // 4. Question Distribution (Min/Max Constraints)
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Label("4. Cấu Trúc Đề Thi", systemImage: "slider.horizontal.3")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(hex: "#111827"))
                            Spacer()
                            Text("Tổng: \(mcCount + tfCount + saCount) câu")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.primaryMint)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(AppTheme.primaryLight))
                        }
                        
                        // Multiple Choice: min 8, max 20
                        stepperRow(
                            title: "Trắc nghiệm 4 lựa chọn (A, B, C, D)",
                            value: $mcCount,
                            range: 8...20,
                            desc: "Tối thiểu 8 câu • Tối đa 20 câu"
                        )
                        
                        Divider()
                        
                        // True / False: min 4, max 7
                        stepperRow(
                            title: "Câu hỏi Đúng / Sai (Mỗi câu 4 ý a,b,c,d)",
                            value: $tfCount,
                            range: 4...7,
                            desc: "Tối thiểu 4 câu • Tối đa 7 câu"
                        )
                        
                        Divider()
                        
                        // Short Answer: min 2, max 6
                        stepperRow(
                            title: "Câu hỏi Trả lời ngắn (Điền số)",
                            value: $saCount,
                            range: 2...6,
                            desc: "Tối thiểu 2 câu • Tối đa 6 câu"
                        )
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    )
                    
                    // 5. Action Button: TẠO ĐỀ THI
                    Button(action: { startAIGeneration() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 18, weight: .bold))
                            Text("Tạo Đề Thi Với AI")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [AppTheme.primaryMint, AppTheme.primaryDark],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: AppTheme.primaryMint.opacity(0.35), radius: 10, x: 0, y: 5)
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 16)
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
        VStack(spacing: 24) {
            Spacer()
            
            Image("ChibiPractice")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .scaleEffect(1.05)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isGenerating)
            
            VStack(spacing: 8) {
                Text("AI Đang Biên Soạn Đề Thi...")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                
                Text("Tra cứu giáo trình chuẩn Lớp \(selectedGrade) • Môn \(selectedSubject)\nKiến thức: \"\(focusTopicInput.isEmpty ? "Toàn bộ chương trình Học kỳ \(selectedSemester)" : focusTopicInput)\"")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppTheme.textSecondary)
                    .padding(.horizontal, 32)
            }
            
            ProgressView()
                .scaleEffect(1.2)
                .tint(AppTheme.primaryMint)
            
            Text("Đang tạo \(mcCount) câu trắc nghiệm • \(tfCount) câu đúng/sai • \(saCount) câu ngắn")
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
                tabButton(title: "Trắc Nghiệm (\(activeExam?.multipleChoice.count ?? 0))", partIndex: 0)
                tabButton(title: "Đúng / Sai (\(activeExam?.trueFalse.count ?? 0))", partIndex: 1)
                tabButton(title: "Trả Lời Ngắn (\(activeExam?.shortAnswer.count ?? 0))", partIndex: 2)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            
            // Questions Scroll View
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
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
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(isSelected ? .white : AppTheme.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? AppTheme.primaryDark : Color.white)
                )
                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        }
    }
    
    // Multiple Choice Card
    private func mcQuestionCard(_ q: MultipleChoiceQuestion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Câu \(q.id)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.primaryMint)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(AppTheme.primaryLight))
                Spacer()
            }
            
            MarkdownRendererView(content: q.question)
                .font(.system(size: 15))
            
            VStack(spacing: 8) {
                ForEach(0..<q.options.count, id: \.self) { optIdx in
                    let isChosen = (studentMCAnswers[q.id] == optIdx)
                    Button(action: {
                        studentMCAnswers[q.id] = optIdx
                    }) {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(isChosen ? AppTheme.primaryMint : Color(hex: "#F3F4F6"))
                                    .frame(width: 28, height: 28)
                                Text(["A", "B", "C", "D"][optIdx % 4])
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(isChosen ? .white : Color(hex: "#374151"))
                            }
                            
                            MarkdownRendererView(content: q.options[optIdx])
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "#1F2937"))
                            
                            Spacer()
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isChosen ? AppTheme.primaryMint.opacity(0.08) : Color(hex: "#F9FAFB"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(isChosen ? AppTheme.primaryMint : Color(hex: "#E5E7EB"), lineWidth: isChosen ? 1.5 : 1)
                                )
                        )
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
    
    // True/False Card (4 statements a, b, c, d)
    private func tfQuestionCard(_ q: TrueFalseQuestion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Câu \(q.id) (Đúng / Sai)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#2563EB"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color(hex: "#DBEAFE")))
                Spacer()
            }
            
            MarkdownRendererView(content: q.context)
                .font(.system(size: 15))
            
            VStack(spacing: 10) {
                ForEach(q.statements) { stmt in
                    let answerKey = "\(q.id):\(stmt.id)"
                    let chosenVal = studentTFAnswers[answerKey]
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(stmt.id))")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "#374151"))
                            
                            MarkdownRendererView(content: stmt.statement)
                                .font(.system(size: 14))
                        }
                        
                        HStack(spacing: 8) {
                            Spacer()
                            // Option: ĐÚNG
                            Button(action: { studentTFAnswers[answerKey] = true }) {
                                HStack(spacing: 4) {
                                    Image(systemName: chosenVal == true ? "checkmark.circle.fill" : "circle")
                                    Text("Đúng")
                                        .fontWeight(.bold)
                                }
                                .font(.caption)
                                .foregroundColor(chosenVal == true ? .white : Color(hex: "#059669"))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule().fill(chosenVal == true ? Color(hex: "#059669") : Color(hex: "#D1FAE5"))
                                )
                            }
                            
                            // Option: SAI
                            Button(action: { studentTFAnswers[answerKey] = false }) {
                                HStack(spacing: 4) {
                                    Image(systemName: chosenVal == false ? "xmark.circle.fill" : "circle")
                                    Text("Sai")
                                        .fontWeight(.bold)
                                }
                                .font(.caption)
                                .foregroundColor(chosenVal == false ? .white : Color(hex: "#DC2626"))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule().fill(chosenVal == false ? Color(hex: "#DC2626") : Color(hex: "#FEE2E2"))
                                )
                            }
                        }
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#F9FAFB"))
                    )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
    
    // Short Answer Card
    private func saQuestionCard(_ q: ShortAnswerQuestion) -> some View {
        let binding = Binding<String>(
            get: { studentSAAnswers[q.id] ?? "" },
            set: { studentSAAnswers[q.id] = $0 }
        )
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Câu \(q.id) (Trả Lời Ngắn)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#7C3AED"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color(hex: "#EDE9FE")))
                Spacer()
            }
            
            MarkdownRendererView(content: q.question)
                .font(.system(size: 15))
            
            HStack {
                TextField("Nhập kết quả số hoặc đáp số...", text: binding)
                    .font(.system(size: 15, design: .rounded))
                    .padding(12)
                    .background(Color(hex: "#F9FAFB"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                    )
                
                if let unit = q.unit, !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppTheme.textSecondary)
                        .padding(.horizontal, 8)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
    
    // =====================================================================
    // MARK: - SCREEN 4: GRADING & STEP-BY-STEP EXPLANATION
    // =====================================================================
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
            return "🎉 Xuất Sắc! Nắm rất vững kiến thức."
        } else if calculatedScore >= 5.0 {
            return "👍 Đạt yêu cầu! Cần ôn luyện thêm."
        } else {
            return "⚠️ Cần xem kỹ lại lời giải chi tiết bên dưới."
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
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label("Câu \(q.id)", systemImage: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(isCorrect ? .green : .red)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(isCorrect ? Color.green.opacity(0.12) : Color.red.opacity(0.12)))
                        
                        Spacer()
                        
                        Text(isCorrect ? "Đúng" : "Sai")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(isCorrect ? .green : .red)
                    }
                    
                    MarkdownRendererView(content: q.question)
                        .font(.system(size: 14))
                    
                    HStack {
                        Text("Bạn chọn: \(studentLetter)")
                            .font(.caption)
                            .foregroundColor(isCorrect ? .green : .red)
                        Spacer()
                        Text("Đáp án đúng: \(correctLetter)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    .padding(8)
                    .background(Color(hex: "#F9FAFB"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("💡 Lời giải chi tiết từ AI:")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.primaryMint)
                        MarkdownRendererView(content: q.explanation)
                            .font(.caption)
                            .foregroundColor(Color(hex: "#374151"))
                    }
                    .padding(10)
                    .background(Color(hex: "#ECFDF5"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
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
    
    @ViewBuilder
    private var reviewTrueFalseSection: some View {
        if let tfQuestions = activeExam?.trueFalse, !tfQuestions.isEmpty {
            ForEach(tfQuestions) { q in
                VStack(alignment: .leading, spacing: 10) {
                    Text("Câu \(q.id) (Đúng / Sai)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2563EB"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color(hex: "#DBEAFE")))
                    
                    MarkdownRendererView(content: q.context)
                        .font(.system(size: 14))
                    
                    ForEach(q.statements) { stmt in
                        let chosen = studentTFAnswers["\(q.id):\(stmt.id)"]
                        let isCorrect = (chosen == stmt.isCorrectTrue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(isCorrect ? .green : .red)
                                    .font(.caption)
                                Text("Ý \(stmt.id)): \(stmt.statement)")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Spacer()
                                Text(stmt.isCorrectTrue ? "Đúng" : "Sai")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            
                            Text("Giải thích: \(stmt.explanation)")
                                .font(.caption2)
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .padding(8)
                        .background(isCorrect ? Color.green.opacity(0.05) : Color.red.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
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
    
    @ViewBuilder
    private var reviewShortAnswerSection: some View {
        if let saQuestions = activeExam?.shortAnswer, !saQuestions.isEmpty {
            ForEach(saQuestions) { q in
                let studentAns = studentSAAnswers[q.id]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let isCorrect = q.acceptedAnswers.contains(where: { $0.lowercased() == studentAns.lowercased() })
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label("Câu \(q.id) (Trả lời ngắn)", systemImage: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(isCorrect ? .green : .red)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(isCorrect ? Color.green.opacity(0.12) : Color.red.opacity(0.12)))
                        Spacer()
                    }
                    
                    MarkdownRendererView(content: q.question)
                        .font(.system(size: 14))
                    
                    HStack {
                        Text("Bạn điền: \"\(studentAns.isEmpty ? "Bỏ trống" : studentAns)\"")
                            .font(.caption)
                            .foregroundColor(isCorrect ? .green : .red)
                        Spacer()
                        Text("Đáp số: \(q.acceptedAnswers.first ?? "") \(q.unit ?? "")")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    .padding(8)
                    .background(Color(hex: "#F9FAFB"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("💡 Hướng dẫn giải chi tiết:")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.primaryMint)
                        MarkdownRendererView(content: q.explanation)
                            .font(.caption)
                            .foregroundColor(Color(hex: "#374151"))
                    }
                    .padding(10)
                    .background(Color(hex: "#ECFDF5"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
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
            geminiApiKey: appState.geminiApiKey
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
                self.activeExamPart = 0
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
    }
}
