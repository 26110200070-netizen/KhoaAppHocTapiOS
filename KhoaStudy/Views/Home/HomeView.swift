import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    var onNavigateToTheory: (() -> Void)? = nil
    var onNavigateToPractice: (() -> Void)? = nil
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
                        .padding(.top, 14)
                    
                    // 2. Tammi Style 3D Cutout Mascot Cards (Không khung bao bọc, Không shadow!)
                    tammiChibiArtworkCardsSection
                    
                    // 3. AI Tutor Interactive Banner with 3D Mascot
                    aiTutorInteractiveBanner
                    
                    // 4. Large Promo Exam Banner (Ôn Thi Bứt Phá)
                    tammiPromoExamBanner
                    
                    // Spacing above bottom bar
                    Spacer().frame(height: 110)
                }
                .padding(.horizontal, 16)
            }
        }
        .fullScreenCover(isPresented: $showingTheorySheet) {
            TheoryStudyView()
        }
        .fullScreenCover(isPresented: $showingExerciseSheet) {
            ExercisePracticeView()
        }
        .fullScreenCover(isPresented: $showingFocusSheet) {
            FocusLockView()
        }
        .fullScreenCover(isPresented: $showingExamSheet) {
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
                    Text("Shimy • Lớp \(appState.currentUser.grade)")
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
    
    // MARK: - 2. Tammi Style 3D Mascot Cards (NHÂN VẬT TÁCH NỀN TRONG SUỐT - KHÔNG KHUNG - KHÔNG SHADOW)
    private var tammiChibiArtworkCardsSection: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left Hero Card: HỌC LÍ THUYẾT SGK (3D Chibi Fox Mascot tách nền trong suốt)
            Button(action: {
                if let onNavigateToTheory = onNavigateToTheory {
                    onNavigateToTheory()
                } else {
                    showingTheorySheet = true
                }
            }) {
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
                    .foregroundColor(Color(hex: "#EF4444"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color(hex: "#FEE2E2")))
                    
                    Spacer(minLength: 4)
                    
                    // Nhân vật tách nền tự do, không khung, không shadow!
                    HStack {
                        Spacer()
                        Image("ChibiTheory")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 145)
                        Spacer()
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, minHeight: 240)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                )
            }
            
            // Right 2 Stacked Cards (Nhân vật tách nền tự do!)
            VStack(spacing: 12) {
                // Card Top Right: LUYỆN BÀI TẬP (Chibi Bear Mascot tách nền)
                Button(action: {
                    if let onNavigateToPractice = onNavigateToPractice {
                        onNavigateToPractice()
                    } else {
                        showingExerciseSheet = true
                    }
                }) {
                    HStack(alignment: .center, spacing: 8) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Luyện Bài Tập")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#111827"))
                            Text("5 - 40 câu có lời giải")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        
                        Spacer()
                        
                        // Nhân vật tách nền tự do, không khung, không shadow!
                        Image("ChibiPractice")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 72)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, minHeight: 114)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    )
                }
                
                // Card Bottom Right: TREO MÁY TỰ HỌC (Chibi Bunny Mascot tách nền)
                Button(action: { showingFocusSheet = true }) {
                    HStack(alignment: .center, spacing: 8) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Treo Máy Tự Học")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#111827"))
                            Text("Pomodoro tập trung")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        
                        Spacer()
                        
                        // Nhân vật tách nền tự do, không khung, không shadow!
                        Image("ChibiFocus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 72)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, minHeight: 114)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    )
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - 3. AI Tutor Interactive Banner with 3D Mascot
    private var aiTutorInteractiveBanner: some View {
        Button(action: {
            onOpenAIChat?()
        }) {
            HStack(spacing: 14) {
                // Avatar Mascot tách nền
                Image("ChibiAITutor")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 52, height: 52)
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text("Gia Sư Trí Tuệ Nhân Tạo")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                    Text("Hỏi đáp bài tập, giải thích công thức với Shimy")
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
                        Text("SHIMY AI 🚀")
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
                    
                    Image("ChibiExamBanner")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.trailing, 16)
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
