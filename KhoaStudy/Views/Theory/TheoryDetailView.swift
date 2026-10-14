import SwiftUI

struct TheoryDetailView: View {
    @Environment(\.dismiss) var dismiss
    let lesson: Lesson
    let subjectCategory: SubjectCategory
    
    @State private var isPlayingVideo: Bool = false
    @State private var selectedTab: Int = 0
    @State private var isBookmarked: Bool = false
    @State private var showingExercise: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // 1. Video Bài Giảng Mockup Card (Like Hero image in video)
                        videoPlayerHeroCard
                        
                        // 2. Lesson Title & Subject Badges
                        lessonHeaderInfo
                        
                        // 3. Segmented Sub-tabs (Lí thuyết, Công thức, Ví dụ)
                        tabsSelector
                        
                        // 4. Tab Content
                        if selectedTab == 0 {
                            theorySummaryContent
                        } else if selectedTab == 1 {
                            formulasAndNotesContent
                        } else {
                            examplesContent
                        }
                        
                        // Bottom spacing for sticky action bar
                        Spacer().frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                
                // Sticky Bottom Action Bar (Like "Add to Cart" sticky bar in video)
                stickyBottomBar
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                            .padding(8)
                            .background(Circle().fill(Color.white))
                            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isBookmarked.toggle() }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(isBookmarked ? AppTheme.primaryMint : AppTheme.textPrimary)
                            .padding(8)
                            .background(Circle().fill(Color.white))
                            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                    }
                }
            }
            .sheet(isPresented: $showingExercise) {
                ExercisePracticeView(lesson: lesson, subjectCategory: subjectCategory)
            }
        }
    }
    
    // MARK: - 1. Video Player Hero Card
    private var videoPlayerHeroCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#062E29"), Color(hex: "#0E4E46")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 12) {
                // Play Button
                Button(action: {
                    withAnimation { isPlayingVideo.toggle() }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 64, height: 64)
                        Circle()
                            .fill(AppTheme.primaryMint)
                            .frame(width: 50, height: 50)
                            .shadow(color: AppTheme.primaryMint.opacity(0.4), radius: 8, x: 0, y: 4)
                        Image(systemName: isPlayingVideo ? "pause.fill" : "play.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                
                Text(isPlayingVideo ? "Đang phát video bài giảng AI..." : "Video Bài Giảng AI Trực Quan")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    Label(lesson.videoDuration, systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(Color.white.opacity(0.8))
                    Text("•")
                        .foregroundColor(Color.white.opacity(0.6))
                    Text("1080p HD")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.white.opacity(0.2)))
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 35)
        }
        .frame(height: 200)
        .shadow(color: AppTheme.primaryDark.opacity(0.18), radius: 12, x: 0, y: 6)
    }
    
    // MARK: - 2. Lesson Header Info
    private var lessonHeaderInfo: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(lesson.title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text("4.9")
                        .font(.caption)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color.orange.opacity(0.12)))
            }
            
            // Badges Row (Like vegetarian/halal pill row in video)
            HStack(spacing: 10) {
                badgePill(title: "Chuẩn SGK", icon: "checkmark.seal.fill", color: AppTheme.primary)
                badgePill(title: "Video AI", icon: "sparkles.tv.fill", color: AppTheme.primaryMint)
                badgePill(title: "Có Ví Dụ", icon: "list.bullet.rectangle.portrait.fill", color: AppTheme.accentOrange)
            }
        }
    }
    
    private func badgePill(title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(color)
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
        )
    }
    
    // MARK: - 3. Tabs Selector
    private var tabsSelector: some View {
        HStack(spacing: 12) {
            tabButton(title: "Lí thuyết tổng hợp", index: 0)
            tabButton(title: "Công thức & Lưu ý", index: 1)
            tabButton(title: "Ví dụ mẫu", index: 2)
        }
    }
    
    private func tabButton(title: String, index: Int) -> some View {
        let isSelected = (selectedTab == index)
        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
            }
        }) {
            Text(title)
                .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(
                    Capsule()
                        .fill(isSelected ? AppTheme.primaryDark : Color.white)
                )
                .foregroundColor(isSelected ? .white : AppTheme.textSecondary)
                .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0.03), radius: 5, x: 0, y: 2)
        }
    }
    
    // MARK: - 4A. Theory Summary Content
    private var theorySummaryContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Tài Liệu Lí Thuyết Bài Học")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)
            
            Text(lesson.summary)
                .font(.subheadline)
                .lineSpacing(6)
                .foregroundColor(AppTheme.textSecondary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("📌 Mục tiêu cần đạt:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.primary)
                Text("• Nắm vững định lý và điều kiện áp dụng.")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                Text("• Biết cách lập bảng biến thiên và xét dấu nhanh.")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                Text("• Ứng dụng giải quyết các câu hỏi thực tế trong đề thi.")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppTheme.primaryLight)
            )
        }
        .cleanCard(cornerRadius: 24, padding: 18)
    }
    
    // MARK: - 4B. Formulas & Notes (Họa tiết & Hiệu ứng nổi bật)
    private var formulasAndNotesContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Công Thức Trọng Tâm & Lưu Ý Quan Trọng")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)
            
            ForEach(lesson.formulas) { formula in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(formula.title)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                        Spacer()
                        Text(formula.badge)
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(AppTheme.pastelOrange))
                            .foregroundColor(AppTheme.accentOrange)
                    }
                    
                    // Highlighted Formula Box with decorative pattern
                    HStack {
                        Rectangle()
                            .fill(AppTheme.primaryMint)
                            .frame(width: 4)
                            .cornerRadius(2)
                        
                        Text(formula.formulaText)
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            .foregroundColor(AppTheme.primaryDark)
                            .padding(.vertical, 6)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppTheme.primaryLight)
                    )
                    
                    // Notes & Hints
                    HStack(alignment: .top, spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text(formula.notes)
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(hex: "#FAFCFB"))
                )
            }
        }
        .cleanCard(cornerRadius: 24, padding: 18)
    }
    
    // MARK: - 4C. Examples Content
    private var examplesContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Ví Dụ Minh Họa Có Lời Giải")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)
            
            if lesson.examples.isEmpty {
                Text("Đang cập nhật thêm ví dụ nâng cao...")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            } else {
                ForEach(lesson.examples) { ex in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("📝 Ví dụ:")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.primary)
                        Text(ex.question)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        Divider()
                        
                        Text("Lời giải từng bước:")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.textSecondary)
                        
                        ForEach(ex.solutionSteps, id: \.self) { step in
                            Text(step)
                                .font(.caption)
                                .lineSpacing(4)
                                .foregroundColor(AppTheme.textPrimary)
                        }
                        
                        HStack {
                            Text("Kết luận:")
                                .font(.caption)
                                .fontWeight(.bold)
                            Text(ex.finalResult)
                                .font(.caption)
                                .foregroundColor(AppTheme.primaryMint)
                                .fontWeight(.bold)
                        }
                        .padding(.top, 4)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white)
                    )
                }
            }
        }
        .cleanCard(cornerRadius: 24, padding: 18)
    }
    
    // MARK: - Sticky Bottom Bar (Video Style)
    private var stickyBottomBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Bài tập áp dụng")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                Text("\(lesson.questions.count) câu trắc nghiệm")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            Spacer()
            
            Button(action: { showingExercise = true }) {
                HStack(spacing: 8) {
                    Text("Luyện Bài Tập Ngay")
                        .font(.system(size: 15, weight: .bold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(AppTheme.primaryMint)
                )
                .shadow(color: AppTheme.primaryMint.opacity(0.35), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: -4)
        )
    }
}
