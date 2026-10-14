import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    var onOpenAIChat: (() -> Void)? = nil
    
    @State private var showingTheorySheet: Bool = false
    @State private var showingExerciseSheet: Bool = false
    @State private var showingFocusSheet: Bool = false
    @State private var showingExamSheet: Bool = false
    
    var body: some View {
        ZStack {
            // Full-bleed background color 100% covering battery bar, notch & home indicator
            Color(hex: "#F8FAF9")
                .ignoresSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    // 1. Top Header (Greeting + User Profile right under status bar)
                    topHeaderSection
                        .padding(.top, 8)
                    
                    // 2. Tammi Style 3 Full Art Gradient Study Cards (Full hình nền như Ôn Thi Bứt Phá!)
                    tammiFullGradientStudyCardsSection
                    
                    // 3. AI Tutor Interactive Banner (Screenshot 3 Style)
                    aiTutorInteractiveBanner
                    
                    // 4. Large Promo Exam Banner (Ôn Thi Bứt Phá)
                    tammiPromoExamBanner
                    
                    // Spacing above bottom bar
                    Spacer().frame(height: 90)
                }
                .padding(.horizontal, 16)
            }
        }
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
    
    // MARK: - 1. Top Header
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
    
    // MARK: - 2. Tammi Style 3 Full Art Study Cards (HÌNH NỀN FULL GRADIENT NHƯ ÔN THI BỨT PHÁ!)
    private var tammiFullGradientStudyCardsSection: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left Hero Card: HỌC LÍ THUYẾT SGK (Full Emerald/Teal Gradient)
            Button(action: { showingTheorySheet = true }) {
                ZStack(alignment: .topLeading) {
                    // Full Card Background Gradient
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#059669"), Color(hex: "#047857")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Học Lí Thuyết\nChuẩn SGK")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .lineSpacing(2)
                            .multilineTextAlignment(.leading)
                        
                        HStack(spacing: 4) {
                            Text("Vào học ngay")
                                .font(.system(size: 11, weight: .bold))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 9, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.white.opacity(0.2)))
                        
                        Spacer(minLength: 10)
                        
                        // 3D Visual Center
                        HStack {
                            Spacer()
                            VStack(spacing: 4) {
                                Image(systemName: "book.pages.fill")
                                    .font(.system(size: 52))
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                                
                                Text("Video AI & Lý Thuyết")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Color.white.opacity(0.9))
                            }
                            Spacer()
                        }
                        .padding(.bottom, 6)
                    }
                    .padding(14)
                }
                .frame(maxWidth: .infinity, minHeight: 236)
                .shadow(color: Color(hex: "#059669").opacity(0.25), radius: 8, x: 0, y: 4)
            }
            
            // Right 2 Stacked Cards (FULL GRADIENTS)
            VStack(spacing: 12) {
                // Card Top Right: LUYỆN BÀI TẬP (Full Amber Gradient)
                Button(action: { showingExerciseSheet = true }) {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#F59E0B"), Color(hex: "#D97706")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Luyện Bài Tập")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("5 - 40 câu có lời giải")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.9))
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.25))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "pencil.and.list.clipboard")
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(12)
                    }
                    .frame(maxWidth: .infinity, minHeight: 112)
                    .shadow(color: Color(hex: "#D97706").opacity(0.22), radius: 8, x: 0, y: 3)
                }
                
                // Card Bottom Right: TREO MÁY TỰ HỌC (Full Indigo Gradient)
                Button(action: { showingFocusSheet = true }) {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#6366F1"), Color(hex: "#4338CA")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Treo Máy Tự Học")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Pomodoro không xao nhãng")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.9))
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.25))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "lock.shield.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(12)
                    }
                    .frame(maxWidth: .infinity, minHeight: 112)
                    .shadow(color: Color(hex: "#4338CA").opacity(0.22), radius: 8, x: 0, y: 3)
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
                        .frame(width: 50, height: 50)
                        .shadow(color: AppTheme.primaryMint.opacity(0.35), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 24))
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
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
            )
        }
    }
    
    // MARK: - 4. Large Promo Exam Banner (Ôn Thi Bứt Phá)
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
