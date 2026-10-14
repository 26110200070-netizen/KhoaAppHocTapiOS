import SwiftUI

struct ExamListView: View {
    @Environment(\.dismiss) var dismiss
    let curriculum: SubjectCurriculum?
    
    @State private var selectedExamType: Int = 0 // 0: Giữa kỳ, 1: Cuối kỳ, 2: Ôn tập chương
    @State private var activeExamQuestions: [QuizQuestion] = []
    @State private var showingExamPractice: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Header description
                        VStack(spacing: 6) {
                            Text("Hệ Thống Đề Thi & Kiểm Tra")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.textPrimary)
                            Text("Bộ đề chuẩn cấu trúc đề thi chính thức của Bộ GD&ĐT")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .padding(.top, 10)
                        
                        // Exam Type Segmented Switcher
                        HStack(spacing: 10) {
                            examTypeButton(title: "Giữa Kỳ (45p)", index: 0)
                            examTypeButton(title: "Cuối Kỳ (90p)", index: 1)
                            examTypeButton(title: "Ôn Tập Chương", index: 2)
                        }
                        
                        // List of Exam Packages
                        VStack(spacing: 14) {
                            ForEach(1...3, id: \.self) { examNumber in
                                examPackageCard(examNumber: examNumber)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .bold))
                            Text("Quay về")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(AppTheme.primaryDark)
                    }
                }
            }
            .fullScreenCover(isPresented: $showingExamPractice) {
                ExercisePracticeView()
            }
        }
    }
    
    private func examTypeButton(title: String, index: Int) -> some View {
        let isSelected = (selectedExamType == index)
        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedExamType = index
            }
        }) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(isSelected ? AppTheme.primaryDark : Color.white)
                )
                .foregroundColor(isSelected ? .white : AppTheme.textSecondary)
                .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0.03), radius: 5, x: 0, y: 2)
        }
    }
    
    private func examPackageCard(examNumber: Int) -> some View {
        let titlePrefix = selectedExamType == 0 ? "Đề Thi Giữa Kỳ Số \(examNumber)" : (selectedExamType == 1 ? "Đề Thi Học Kỳ Số \(examNumber)" : "Đề Kiểm Tra Chương \(examNumber)")
        let duration = selectedExamType == 0 ? "45 Phút" : (selectedExamType == 1 ? "90 Phút" : "30 Phút")
        let totalQ = selectedExamType == 0 ? "25 Câu" : (selectedExamType == 1 ? "40 Câu" : "15 Câu")
        
        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(titlePrefix)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.textPrimary)
                    HStack(spacing: 6) {
                        Label(duration, systemImage: "clock.fill")
                        Text("•")
                        Label(totalQ, systemImage: "doc.text.fill")
                    }
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                }
                Spacer()
                Text("Hot")
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color.red.opacity(0.12)))
                    .foregroundColor(.red)
            }
            
            Divider()
            
            HStack {
                Text("Cấu trúc: 80% Nhận biết - Thông hiểu, 20% Vận dụng cao")
                    .font(.caption2)
                    .foregroundColor(AppTheme.textMuted)
                Spacer()
                Button(action: {
                    showingExamPractice = true
                }) {
                    Text("Làm Đề Ngay")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(AppTheme.primaryMint))
                }
            }
        }
        .cleanCard(cornerRadius: 22, padding: 18)
    }
}
