import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    var onOpenAIChat: (() -> Void)? = nil
    
    @State private var showingTheorySheet: Bool = false
    @State private var showingExerciseSheet: Bool = false
    @State private var showingFocusSheet: Bool = false
    @State private var showingExamSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color extends 100% full to battery bar & dynamic island
                Color(hex: "#F8FAF9")
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // 1. Top Header (Greeting + User Profile - starts right below status bar)
                        topHeaderSection
                            .padding(.top, 4)
                        
                        // 2. Tammi Style 3 Full Art Study Cards
                        tammiStudyCardsSection
                        
                        // 3. AI Tutor Interactive Banner (Screenshot 3 Style)
                        aiTutorInteractiveBanner
                        
                        // 4. Large Promo Exam Banner
                        tammiPromoExamBanner
                        
                        // Spacing above bottom floating bar
                        Spacer().frame(height: 100)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingTheorySheet) {
                if let lesson = CurriculumStore.shared.allCurriculums.first?.chapters.first?.lessons.first {
                    TheoryDetailView(lesson: lesson, subjectCategory: .math)
                }
            }
            .sheet(isPresented: $showingExerciseSheet) {
                if let lesson = CurriculumStore.shared.allCurriculums.first?.chapters.first?.lessons.first {
                    ExercisePracticeView(lesson: lesson, subjectCategory: .math)
                }
            }
            .fullScreenCover(isPresented: $showingFocusSheet) {
                FocusLockView()
            }
            .sheet(isPresented: $showingExamSheet) {
                ExamListView(curriculum: CurriculumStore.shared.allCurriculums.first)
            }
        }
    }
    
    // MARK: - 1. Top Header (Starts cleanly under battery bar)
    private var topHeaderSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .foregroundColor(AppTheme.primaryMint)
                        .font(.caption2)
                    Text("KhoaStudy • Lớp \(appState.currentUser.grade)")
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
    }
    
    // MARK: - 2. Tammi Style 3 Full Art Study Cards (Screenshot 3 Layout)
    private var tammiStudyCardsSection: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left Hero Card (Học Lí Thuyết SGK - Full 3D Art)
            Button(action: { showingTheorySheet = true }) {
                VStack(alignment: .leading, spacing: 6) {
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
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.red.opacity(0.08)))
                    
                    Spacer(minLength: 6)
                    
                    // 3D Full Character Illustration filling the card
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#E0F2FE"), Color(hex: "#DCFCE7")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        VStack(spacing: 4) {
                            Image(systemName: "book.pages.fill")
                                .font(.system(size: 46))
                                .foregroundColor(AppTheme.primaryMint)
                                .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 6, x: 0, y: 3)
                            
                            Text("Video AI & Công Thức")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(AppTheme.primaryDark)
                        }
                        .padding(.bottom, 14)
                    }
                    .frame(height: 120)
                }
                .padding(14)
                .frame(maxWidth: .infinity, minHeight: 235)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
                )
            }
            
            // Right 2 Stacked Cards (Full Visuals)
            VStack(spacing: 12) {
                // Card Top Right: Làm Bài Tập
                Button(action: { showingExerciseSheet = true }) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Luyện Bài Tập")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: "#111827"))
                                Text("5 - 40 câu có lời giải")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(colors: [Color(hex: "#FEF3C7"), Color(hex: "#FDE68A")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 54, height: 54)
                                Image(systemName: "pencil.and.list.clipboard")
                                    .font(.system(size: 26))
                                    .foregroundColor(Color(hex: "#D97706"))
                            }
                        }
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, minHeight: 112)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    )
                }
                
                // Card Bottom Right: Treo Máy Tự Học
                Button(action: { showingFocusSheet = true }) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Treo Máy Tự Học")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: "#111827"))
                                Text("Pomodoro 25p không xao nhãng")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(colors: [Color(hex: "#E0E7FF"), Color(hex: "#C7D2FE")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 54, height: 54)
                                Image(systemName: "lock.shield.fill")
                                    .font(.system(size: 26))
                                    .foregroundColor(Color(hex: "#4338CA"))
                            }
                        }
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, minHeight: 112)
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
    
    // MARK: - 3. AI Tutor Interactive Banner
    private var aiTutorInteractiveBanner: some View {
        Button(action: {
            onOpenAIChat?()
        }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primaryDark], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 54, height: 54)
                        .shadow(color: AppTheme.primaryMint.opacity(0.35), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text("Gia Sư Trí Tuệ Nhân Tạo")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                    Text("Hỏi đáp bài tập, giải thích công thức với DeepSeek")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.primaryMint)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
            )
        }
    }
    
    // MARK: - 4. Large Promo Exam Banner (Screenshot 3 Red Banner Style)
    private var tammiPromoExamBanner: some View {
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
                        
                        Text("Ôn Thi Bứt Phá Điểm Cao\nChuẩn Đề Bộ GD&ĐT")
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
            
            // Dot indicators
            HStack(spacing: 6) {
                Circle().fill(Color.red).frame(width: 7, height: 7)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 6, height: 6)
            }
            .padding(.top, 4)
        }
    }
}
