import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedSubjectCategory: SubjectCategory = .math
    @State private var showingTheorySheet: Bool = false
    @State private var showingExerciseSheet: Bool = false
    @State private var showingFocusSheet: Bool = false
    @State private var showingExamSheet: Bool = false
    @State private var selectedLesson: Lesson?
    @State private var selectedChapter: Chapter?
    
    // Active banner pager
    @State private var activeBannerIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        // 1. Top Header (Greeting + User Profile)
                        topHeaderSection
                        
                        // 2. Promotional / AI Motivation Banner with Dot Pager
                        bannerSection
                        
                        // 3. Three Major Study Mode Cards (Video & User Prompt)
                        threeMainModesSection
                        
                        // 4. Grade Selector Pills (Lớp 6 - 12, THCS & THPT)
                        gradeSelectorSection
                        
                        // 5. Subject Category Horizontal Pills
                        subjectCategoryPillsSection
                        
                        // 6. SGK Chapter & Lesson Explorer (Theo chuẩn SGK)
                        curriculumExplorerSection
                        
                        // Bottom spacing for floating tab bar
                        Spacer().frame(height: 90)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingTheorySheet) {
                if let lesson = selectedLesson ?? currentCurriculum?.chapters.first?.lessons.first {
                    TheoryDetailView(lesson: lesson, subjectCategory: selectedSubjectCategory)
                }
            }
            .sheet(isPresented: $showingExerciseSheet) {
                if let lesson = selectedLesson ?? currentCurriculum?.chapters.first?.lessons.first {
                    ExercisePracticeView(lesson: lesson, subjectCategory: selectedSubjectCategory)
                }
            }
            .fullScreenCover(isPresented: $showingFocusSheet) {
                FocusLockView()
            }
            .sheet(isPresented: $showingExamSheet) {
                ExamListView(curriculum: currentCurriculum)
            }
        }
    }
    
    // MARK: - Helper to find current curriculum
    private var currentCurriculum: SubjectCurriculum? {
        CurriculumStore.shared.getCurriculum(for: selectedSubjectCategory, grade: appState.selectedGrade)
    }
    
    // MARK: - 1. Top Header
    private var topHeaderSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .foregroundColor(AppTheme.primaryMint)
                        .font(.caption)
                    Text("KhoaStudy • \(appState.selectedGrade.level.rawValue)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.textSecondary)
                }
                Text("Chào, \(appState.currentUser.username) 👋")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            Spacer()
            
            // Avatar Button
            ZStack {
                Circle()
                    .fill(AppTheme.primaryLight)
                    .frame(width: 46, height: 46)
                Image(systemName: appState.currentUser.avatarName)
                    .font(.system(size: 26))
                    .foregroundColor(AppTheme.primary)
            }
            .shadow(color: AppTheme.primary.opacity(0.12), radius: 6, x: 0, y: 3)
        }
    }
    
    // MARK: - 2. Promotional Banner (Video Style with Pill Indicator)
    private var bannerSection: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                // Background Card
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#0E4D45"), Color(hex: "#06312C")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                HStack(alignment: .center, spacing: 14) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ÔN THI BỨT PHÁ 🚀")
                            .font(.caption)
                            .fontWeight(.heavy)
                            .foregroundColor(AppTheme.primaryMint)
                        
                        Text("Bộ Đề Chuẩn SGK\nKèm DeepSeek AI")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .lineLimit(2)
                        
                        Button(action: { showingExamSheet = true }) {
                            Text("Vào Ôn Tập")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(AppTheme.primaryDark)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule().fill(AppTheme.primaryMint)
                                )
                        }
                    }
                    .padding(20)
                    
                    Spacer()
                    
                    // Banner Illustration
                    Image(systemName: "brain.head.profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(AppTheme.primaryMint.opacity(0.85))
                        .padding(.trailing, 20)
                }
            }
            .frame(height: 155)
            .shadow(color: AppTheme.primaryDark.opacity(0.2), radius: 12, x: 0, y: 6)
            
            // Pager Dots Indicator (Pill active, dots inactive - exactly like video)
            HStack(spacing: 6) {
                Capsule()
                    .fill(AppTheme.primaryMint)
                    .frame(width: 22, height: 6)
                Circle()
                    .fill(AppTheme.textMuted.opacity(0.4))
                    .frame(width: 6, height: 6)
                Circle()
                    .fill(AppTheme.textMuted.opacity(0.4))
                    .frame(width: 6, height: 6)
            }
        }
    }
    
    // MARK: - 3. Three Major Choices (3 Ô Lựa Chọn Cốt Lõi)
    private var threeMainModesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Chế độ học tập")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.textPrimary)
            
            HStack(spacing: 12) {
                // Ô 1: Học Lí Thuyết
                modeCard(
                    title: "Học Lí Thuyết",
                    sub: "Video & Công thức",
                    icon: "book.fill",
                    bgGradient: [Color(hex: "#107B6E"), Color(hex: "#0A4E46")],
                    badge: "SGK"
                ) {
                    showingTheorySheet = true
                }
                
                // Ô 2: Làm Bài Tập
                modeCard(
                    title: "Làm Bài Tập",
                    sub: "Trắc nghiệm & Lời giải",
                    icon: "pencil.and.outline",
                    bgGradient: [Color(hex: "#2CC58A"), Color(hex: "#1EA873")],
                    badge: "Có Điểm"
                ) {
                    showingExerciseSheet = true
                }
                
                // Ô 3: Treo Máy Tự Học
                modeCard(
                    title: "Treo Máy Tự Học",
                    sub: "Khóa máy + Bấm giờ",
                    icon: "lock.fill",
                    bgGradient: [Color(hex: "#1E293B"), Color(hex: "#0F172A")],
                    badge: "Tập Trung"
                ) {
                    showingFocusSheet = true
                }
            }
        }
    }
    
    private func modeCard(title: String, sub: String, icon: String, bgGradient: [Color], badge: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 38, height: 38)
                        Image(systemName: icon)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text(badge)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.white.opacity(0.25)))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text(sub)
                        .font(.system(size: 10))
                        .foregroundColor(Color.white.opacity(0.8))
                        .lineLimit(1)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 110)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(LinearGradient(colors: bgGradient, startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .shadow(color: bgGradient.first?.opacity(0.25) ?? Color.clear, radius: 8, x: 0, y: 4)
        }
    }
    
    // MARK: - 4. Grade Selector (Lớp 6 -> 12)
    private var gradeSelectorSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Chọn khối lớp")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Text(appState.selectedGrade.level.rawValue)
                    .font(.caption)
                    .foregroundColor(AppTheme.primary)
                    .fontWeight(.medium)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(SchoolGrade.allCases) { grade in
                        let isSelected = (appState.selectedGrade == grade)
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                appState.selectedGrade = grade
                                appState.selectedLevel = grade.level
                            }
                        }) {
                            Text(grade.displayName)
                                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? AppTheme.primaryDark : Color.white)
                                )
                                .foregroundColor(isSelected ? .white : AppTheme.textSecondary)
                                .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0.03), radius: 6, x: 0, y: 2)
                        }
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
    
    // MARK: - 5. Subject Category Pills (Video Style Category Row)
    private var subjectCategoryPillsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Môn học SGK")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Button(action: { showingExamSheet = true }) {
                    Text("Thi Giữa / Cuối Kỳ →")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.primaryMint)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(SubjectCategory.allCases) { cat in
                        let isSelected = (selectedSubjectCategory == cat)
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedSubjectCategory = cat
                            }
                        }) {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(isSelected ? AppTheme.primaryLight : AppTheme.secondaryBg)
                                        .frame(width: 54, height: 54)
                                    
                                    Image(systemName: cat.iconName)
                                        .font(.system(size: 22))
                                        .foregroundColor(isSelected ? AppTheme.primaryDark : Color(hex: cat.colorHex))
                                }
                                
                                Text(cat.rawValue)
                                    .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                                    .foregroundColor(isSelected ? AppTheme.primaryDark : AppTheme.textSecondary)
                            }
                        }
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
    
    // MARK: - 6. SGK Chapter & Lesson Explorer
    private var curriculumExplorerSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("\(selectedSubjectCategory.rawValue) • \(appState.selectedGrade.displayName)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Text("Chuẩn SGK")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(AppTheme.primaryLight))
                    .foregroundColor(AppTheme.primary)
            }
            
            if let curriculum = currentCurriculum, !curriculum.chapters.isEmpty {
                ForEach(curriculum.chapters) { chapter in
                    VStack(alignment: .leading, spacing: 12) {
                        // Chapter Title Header
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(chapter.title)
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(AppTheme.textPrimary)
                                Text(chapter.description)
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                                    .lineLimit(2)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 4)
                        
                        // Lessons List in this Chapter
                        ForEach(chapter.lessons) { lesson in
                            lessonRowCard(lesson: lesson, chapter: chapter)
                        }
                    }
                    .cleanCard(cornerRadius: 24, padding: 18)
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 38))
                        .foregroundColor(AppTheme.textMuted)
                    Text("Đang tải dữ liệu chương trình chuẩn...")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .cleanCard(cornerRadius: 24)
            }
        }
    }
    
    private func lessonRowCard(lesson: Lesson, chapter: Chapter) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                // Lesson Order Circle
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryLight)
                        .frame(width: 34, height: 34)
                    Text("\(lesson.order)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.primary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    Text(lesson.summary)
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                        .lineLimit(2)
                }
                Spacer()
            }
            
            // Action Pill Buttons (Học lí thuyết, Làm bài tập)
            HStack(spacing: 8) {
                Button(action: {
                    selectedLesson = lesson
                    selectedChapter = chapter
                    showingTheorySheet = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "play.circle.fill")
                        Text("Lí thuyết")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(AppTheme.primaryLight))
                }
                
                Button(action: {
                    selectedLesson = lesson
                    selectedChapter = chapter
                    showingExerciseSheet = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil.circle.fill")
                        Text("Luyện tập (\(lesson.questions.count) câu)")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(AppTheme.primaryMint))
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 6)
    }
}
