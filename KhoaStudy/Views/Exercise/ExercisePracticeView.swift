import SwiftUI

struct ExercisePracticeView: View {
    @Environment(\.dismiss) var dismiss
    let lesson: Lesson
    let subjectCategory: SubjectCategory
    
    // Config state
    @State private var selectedQuestionCount: Int = 5
    @State private var isTestStarted: Bool = false
    @State private var isSubmitted: Bool = false
    
    // Quiz state
    @State private var currentIndex: Int = 0
    @State private var userAnswers: [Int: Int] = [:] // Question Index -> Option Index
    @State private var showingWordExportToast: Bool = false
    
    // Options for question count
    let countOptions = [5, 10, 20, 40]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                if !isTestStarted {
                    setupView
                } else if !isSubmitted {
                    activeQuizView
                } else {
                    resultGradingView
                }
            }
            .navigationTitle("Luyện Tập Trắc Nghiệm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Đóng") { dismiss() }
                        .foregroundColor(AppTheme.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { exportToWord() }) {
                        Label("Tải Word", systemImage: "arrow.down.doc.fill")
                            .font(.caption)
                            .foregroundColor(AppTheme.primaryMint)
                    }
                }
            }
            .overlay(alignment: .bottom) {
                if showingWordExportToast {
                    wordExportToast
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 20)
                }
            }
        }
    }
    
    // MARK: - Setup Screen (Chọn số lượng câu hỏi & chế độ)
    private var setupView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppTheme.primaryLight)
                    .frame(width: 90, height: 90)
                Image(systemName: "pencil.and.list.clipboard")
                    .font(.system(size: 44))
                    .foregroundColor(AppTheme.primary)
            }
            
            VStack(spacing: 8) {
                Text(lesson.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppTheme.textPrimary)
                Text("Chọn số lượng câu hỏi để bắt đầu bài làm:")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            // Question Count Picker (5, 10, 20, 40)
            HStack(spacing: 12) {
                ForEach(countOptions, id: \.self) { count in
                    let isSelected = (selectedQuestionCount == count)
                    Button(action: {
                        withAnimation { selectedQuestionCount = count }
                    }) {
                        VStack(spacing: 4) {
                            Text("\(count)")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                            Text("Câu")
                                .font(.caption2)
                        }
                        .frame(width: 65, height: 65)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(isSelected ? AppTheme.primaryDark : Color.white)
                        )
                        .foregroundColor(isSelected ? .white : AppTheme.textPrimary)
                        .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0.03), radius: 6, x: 0, y: 2)
                    }
                }
            }
            
            VStack(spacing: 14) {
                // Button Start Test
                Button(action: {
                    withAnimation { isTestStarted = true }
                }) {
                    Text("Bắt Đầu Làm Bài")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule().fill(AppTheme.primaryMint)
                        )
                        .shadow(color: AppTheme.primaryMint.opacity(0.35), radius: 8, x: 0, y: 4)
                }
                
                // Button Export Word
                Button(action: { exportToWord() }) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                        Text("Tải Đề Theo Định Dạng Word (.docx)")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        Capsule().fill(AppTheme.primaryLight)
                    )
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Active Quiz Screen
    private var activeQuizView: some View {
        let questions = lesson.questions
        let currentQuestion = questions[min(currentIndex, questions.count - 1)]
        
        return VStack(spacing: 18) {
            // Progress Header
            HStack {
                Text("Câu \(currentIndex + 1) / \(min(questions.count, selectedQuestionCount))")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                // Origin tag preview
                Text(currentQuestion.originTag)
                    .font(.caption2)
                    .foregroundColor(AppTheme.textSecondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 20)
            
            // Question Prompt Card
            VStack(alignment: .leading, spacing: 12) {
                Text(currentQuestion.prompt)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .cleanCard(cornerRadius: 22, padding: 20)
            .padding(.horizontal, 20)
            
            // Options List
            VStack(spacing: 12) {
                ForEach(0..<currentQuestion.options.count, id: \.self) { optIdx in
                    let isChosen = (userAnswers[currentIndex] == optIdx)
                    let letter = ["A", "B", "C", "D"][optIdx]
                    
                    Button(action: {
                        userAnswers[currentIndex] = optIdx
                    }) {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(isChosen ? AppTheme.primaryMint : AppTheme.secondaryBg)
                                    .frame(width: 34, height: 34)
                                Text(letter)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(isChosen ? .white : AppTheme.textPrimary)
                            }
                            
                            Text(currentQuestion.options[optIdx])
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppTheme.textPrimary)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(isChosen ? AppTheme.primaryLight : Color.white)
                        )
                        .shadow(color: Color.black.opacity(isChosen ? 0.05 : 0.02), radius: 6, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Bottom Navigation (Câu trước, Câu sau, Nộp bài)
            HStack(spacing: 14) {
                if currentIndex > 0 {
                    Button(action: { currentIndex -= 1 }) {
                        Text("← Trước")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.textSecondary)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.white))
                    }
                }
                
                Spacer()
                
                if currentIndex < min(questions.count, selectedQuestionCount) - 1 {
                    Button(action: { currentIndex += 1 }) {
                        Text("Tiếp Theo →")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(AppTheme.primaryDark))
                    }
                } else {
                    Button(action: {
                        withAnimation { isSubmitted = true }
                    }) {
                        Text("Nộp Bài & Chấm Điểm")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(AppTheme.primaryMint))
                            .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .padding(.top, 10)
    }
    
    // MARK: - Result & Grading Screen with Solutions & Required Origin Tag
    private var resultGradingView: some View {
        let questions = lesson.questions
        let total = min(questions.count, selectedQuestionCount)
        var correctCount = 0
        for i in 0..<total {
            if userAnswers[i] == questions[i].correctIndex {
                correctCount += 1
            }
        }
        let scoreOutOf10 = Double(correctCount) / Double(total) * 10.0
        
        return ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Score Summary Card
                VStack(spacing: 10) {
                    Text("Kết Quả Làm Bài")
                        .font(.headline)
                        .foregroundColor(AppTheme.textSecondary)
                    
                    Text(String(format: "%.1f / 10", scoreOutOf10))
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(scoreOutOf10 >= 8.0 ? AppTheme.primaryMint : (scoreOutOf10 >= 5.0 ? .orange : .red))
                    
                    Text("Đúng \(correctCount) trên tổng số \(total) câu hỏi")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textPrimary)
                }
                .frame(maxWidth: .infinity)
                .cleanCard(cornerRadius: 24, padding: 22)
                
                // Detailed Solutions for ALL Questions (Both Correct and Incorrect)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Lời Giải Chi Tiết Từng Câu")
                        .font(.headline)
                        .foregroundColor(AppTheme.textPrimary)
                    
                    ForEach(0..<total, id: \.self) { idx in
                        let q = questions[idx]
                        let userOpt = userAnswers[idx]
                        let isCorrect = (userOpt == q.correctIndex)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Câu \(idx + 1):")
                                    .font(.system(size: 14, weight: .bold))
                                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(isCorrect ? .green : .red)
                                Text(isCorrect ? "Đúng" : "Sai")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(isCorrect ? .green : .red)
                                Spacer()
                            }
                            
                            Text(q.prompt)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppTheme.textPrimary)
                            
                            HStack {
                                Text("Đáp án đúng:")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                                Text(["A", "B", "C", "D"][q.correctIndex] + ". " + q.options[q.correctIndex])
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            
                            Divider()
                            
                            // Cách giải chi tiết
                            VStack(alignment: .leading, spacing: 4) {
                                Text("💡 Cách giải chi tiết:")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppTheme.primary)
                                Text(q.explanation)
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textPrimary)
                                    .lineSpacing(3)
                            }
                            
                            // YÊU CẦU BẮT BUỘC TỪ TICKET:
                            // "Cách giải kèm thêm 1 dòng . Bài tập thuộc bài a chương b"
                            HStack {
                                Image(systemName: "tag.fill")
                                    .font(.caption2)
                                    .foregroundColor(AppTheme.primaryMint)
                                Text("• " + q.originTag)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppTheme.primaryDark)
                            }
                            .padding(.top, 4)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white)
                        )
                        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
                    }
                }
                
                // Retry & Export Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        userAnswers.removeAll()
                        currentIndex = 0
                        isSubmitted = false
                        isTestStarted = true
                    }) {
                        Text("Làm Lại Đề Này")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.primaryDark)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Capsule().fill(Color.white))
                    }
                    
                    Button(action: { exportToWord() }) {
                        Text("Tải Đề & Lời Giải (.docx)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Capsule().fill(AppTheme.primaryMint))
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
    
    // MARK: - Word Export Helper
    private func exportToWord() {
        withAnimation { showingWordExportToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation { showingWordExportToast = false }
        }
    }
    
    private var wordExportToast: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text("Đã tạo file Word: DeThi_\(lesson.title).docx")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
        )
    }
}
