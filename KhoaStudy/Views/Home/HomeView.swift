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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F8FAF9").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // 1. Top Header (Greeting + User Profile - Custom, no overlap!)
                        topHeaderSection
                        
                        // 2. Quick Subject Service Pills (Screenshot 3 Top Row)
                        quickServicesRow
                        
                        // 3. Grid of 3 Study Cards (Exact Layout of Screenshot 3)
                        // Left tall hero card with 3D art + Right 2 stacked cards
                        tammiStyleStudyCardsGrid
                        
                        // 4. Large Promo Banner with Mascot (Screenshot 3 Style)
                        tammiPromoBanner
                        
                        // 5. Grade Selector Pills (Lớp 6 - 12)
                        gradeSelectorSection
                        
                        // 6. SGK Chapters Explorer
                        curriculumExplorerSection
                        
                        // Bottom spacing for floating tab bar
                        Spacer().frame(height: 95)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
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
    
    private var currentCurriculum: SubjectCurriculum? {
        CurriculumStore.shared.getCurriculum(for: selectedSubjectCategory, grade: appState.selectedGrade)
    }
    
    // MARK: - 1. Top Header (Custom Header without Navigation Bar collision)
    private var topHeaderSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .foregroundColor(AppTheme.primaryMint)
                        .font(.caption2)
                    Text("KhoaStudy • \(appState.selectedGrade.level.rawValue)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.textSecondary)
                }
                Text("Chào, \(appState.currentUser.username) 👋")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppTheme.primaryLight)
                    .frame(width: 44, height: 44)
                Image(systemName: appState.currentUser.avatarName)
                    .font(.system(size: 24))
                    .foregroundColor(AppTheme.primary)
            }
            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
        }
        .padding(.top, 4)
    }
    
    // MARK: - 2. Quick Services Row (Screenshot 3 Top Service Pills)
    private var quickServicesRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(SubjectCategory.allCases) { cat in
                    let isSelected = (selectedSubjectCategory == cat)
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedSubjectCategory = cat
                        }
                    }) {
                        VStack(spacing: 6) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(isSelected ? AppTheme.primaryLight : Color.white)
                                    .frame(width: 52, height: 52)
                                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                                
                                Image(systemName: cat.iconName)
                                    .font(.system(size: 22))
                                    .foregroundColor(isSelected ? AppTheme.primaryDark : Color(hex: cat.colorHex))
                            }
                            
                            Text(cat.rawValue)
                                .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                                .foregroundColor(isSelected ? AppTheme.primaryDark : AppTheme.textSecondary)
                        }
                    }
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 2)
        }
    }
    
    // MARK: - 3. Tammi Style Study Cards Grid (Screenshot 3 Layout)
    // Left Tall Hero Card (with full 3D art) + Right 2 Stacked Cards
    private var tammiStyleStudyCardsGrid: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left Hero Card (Học Lí Thuyết SGK - Full 3D Illustration)
            Button(action: { showingTheorySheet = true }) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Học Lí Thuyết\nChuẩn SGK")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                        .lineSpacing(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 4) {
                        Text("Vào học ngay")
                            .font(.system(size: 11, weight: .bold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 9, weight: .bold))
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color.red.opacity(0.08)))
                    
                    Spacer(minLength: 8)
                    
                    // 3D Full Character Illustration filling the card
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(LinearGradient(colors: [Color(hex: "#E0F2FE"), Color(hex: "#F0FDF4")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        
                        VStack(spacing: 4) {
                            Image(systemName: "book.pages.fill")
                                .font(.system(size: 40))
                                .foregroundColor(AppTheme.primaryMint)
                            Text("Video AI & Công Thức")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(AppTheme.primaryDark)
                        }
                    }
                    .frame(height: 110)
                }
                .padding(14)
                .frame(maxWidth: .infinity, minHeight: 220)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
                )
            }
            
            // Right 2 Stacked Cards
            VStack(spacing: 12) {
                // Card Top Right: Làm Bài Tập
                Button(action: { showingExerciseSheet = true }) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Luyện Bài Tập")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: "#111827"))
                                Text("5 - 40 câu có lời giải")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(AppTheme.primaryLight)
                                    .frame(width: 48, height: 48)
                                Image(systemName: "pencil.and.list.clipboard")
                                    .font(.system(size: 24))
                                    .foregroundColor(AppTheme.primaryMint)
                            }
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, minHeight: 104)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    )
                }
                
                // Card Bottom Right: Treo Máy Tự Học
                Button(action: { showingFocusSheet = true }) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Treo Máy Tự Học")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: "#111827"))
                                Text("Pomodoro không xao nhãng")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(hex: "#F1F5F9"))
                                    .frame(width: 48, height: 48)
                                Image(systemName: "lock.shield.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(hex: "#1E293B"))
                            }
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, minHeight: 104)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    )
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - 4. Tammi Style Red Promo Banner (Screenshot 3 Style)
    private var tammiPromoBanner: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#DC2626"), Color(hex: "#991B1B")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                HStack(alignment: .center, spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("KHOASTUDY AI 🚀")
                            .font(.system(size: 10, weight: .heavy))
                            .foregroundColor(Color(hex: "#FEF08A"))
                        
                        Text("Ôn Thi Bứt Phá Điểm Cao\nCùng DeepSeek AI")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .lineSpacing(2)
                        
                        Button(action: { showingExamSheet = true }) {
                            Text("LÀM ĐỀ THI NGAY")
                                .font(.system(size: 11, weight: .heavy))
                                .foregroundColor(Color(hex: "#DC2626"))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(Capsule().fill(Color.white))
                        }
                        .padding(.top, 4)
                    }
                    .padding(18)
                    
                    Spacer()
                    
                    Image(systemName: "sparkles.tv.fill")
                        .font(.system(size: 64))
                        .foregroundColor(Color.white.opacity(0.9))
                        .padding(.trailing, 20)
                }
            }
            .frame(height: 140)
            .shadow(color: Color(hex: "#DC2626").opacity(0.25), radius: 10, x: 0, y: 5)
            
            // Dot indicators (Screenshot 3 style)
            HStack(spacing: 6) {
                Circle().fill(Color.red).frame(width: 7, height: 7)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
            }
            .padding(.top, 4)
        }
    }
    
    // MARK: - 5. Grade Selector Pills
    private var gradeSelectorSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Khối lớp học tập")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
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
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? Color(hex: "#111827") : Color.white)
                                )
                                .foregroundColor(isSelected ? .white : AppTheme.textSecondary)
                                .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0.03), radius: 5, x: 0, y: 2)
                        }
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
    
    // MARK: - 6. SGK Chapter Explorer
    private var curriculumExplorerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(selectedSubjectCategory.rawValue) • \(appState.selectedGrade.displayName)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                Spacer()
                Text("Chuẩn SGK")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(AppTheme.primaryLight))
                    .foregroundColor(AppTheme.primary)
            }
            
            if let curriculum = currentCurriculum, !curriculum.chapters.isEmpty {
                ForEach(curriculum.chapters) { chapter in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(chapter.title)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        Text(chapter.description)
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                            .lineLimit(2)
                        
                        ForEach(chapter.lessons) { lesson in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(lesson.title)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(hex: "#111827"))
                                    Text(lesson.summary)
                                        .font(.caption2)
                                        .foregroundColor(AppTheme.textSecondary)
                                        .lineLimit(1)
                                }
                                Spacer()
                                Button(action: {
                                    selectedLesson = lesson
                                    selectedChapter = chapter
                                    showingTheorySheet = true
                                }) {
                                    Text("Học ›")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(AppTheme.primaryMint)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Capsule().fill(AppTheme.primaryLight))
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    )
                }
            }
        }
    }
}
