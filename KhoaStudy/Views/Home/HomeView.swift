import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    var onNavigateToTheory: (() -> Void)? = nil
    var onNavigateToPractice: (() -> Void)? = nil
    var onOpenAIChat: (() -> Void)? = nil
    
    @ObservedObject private var historyStore = StudyHistoryStore.shared
    @State private var showingTheory: Bool = false
    @State private var showingExercise: Bool = false
    @State private var showingFocusSheet: Bool = false
    @State private var showingExamSheet: Bool = false
    @State private var selectedHistoryTopic: TheoryTopicItem? = nil
    
    var body: some View {
        ZStack {
            if let historyTopic = selectedHistoryTopic {
                TheoryLessonDetailView(topicItem: historyTopic, onBack: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedHistoryTopic = nil
                    }
                })
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            } else if showingTheory {
                TheoryStudyView(onBackToHome: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showingTheory = false
                    }
                })
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            } else if showingExercise {
                ExercisePracticeView(onBackToHome: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showingExercise = false
                    }
                })
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            } else {
                homeDashboardView
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            }
        }
        .fullScreenCover(isPresented: $showingFocusSheet) {
            FocusLockView()
        }
        .fullScreenCover(isPresented: $showingExamSheet) {
            ExamListView(curriculum: CurriculumStore.shared.allCurriculums.first)
        }
    }
    
    // MARK: - Home Dashboard Content
    private var homeDashboardView: some View {
        ZStack {
            // Full-bleed background color 100% covering battery bar, notch & home indicator
            Color(hex: "#F8FAF9")
                .ignoresSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    // 1. Top Header (Greeting + User Profile right under status bar)
                    topHeaderSection
                        .padding(.top, 14)
                    
                    // 2. Banner Cards (Ảnh mới có sẵn chữ, không đè text thừa)
                    tammiChibiArtworkCardsSection
                    
                    // 3. Lịch Sử Học Tập (Ghi nhận bài học đã mở, vuốt trái để xóa)
                    if !historyStore.historyList.isEmpty {
                        studyHistorySection
                    }
                    
                    // 4. AI Tutor Interactive Banner with 3D Mascot
                    aiTutorInteractiveBanner
                    
                    // 5. Large Promo Exam Banner (Ôn Thi Bứt Phá)
                    tammiPromoExamBanner
                    
                    // Spacing above bottom bar
                    Spacer().frame(height: 110)
                }
                .padding(.horizontal, 16)
            }
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
    
    // MARK: - 2. Banner Cards (Bọc khối thống nhất bo tròn, màu trắng xám nhẹ)
    private var tammiChibiArtworkCardsSection: some View {
        HStack(alignment: .top, spacing: 10) {
            // Left Hero Card: HỌC LÍ THUYẾT SGK (Ảnh có sẵn chữ)
            Button(action: {
                if let onNavigateToTheory = onNavigateToTheory {
                    onNavigateToTheory()
                } else {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showingTheory = true
                    }
                }
            }) {
                Image("BannerTheory")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .buttonStyle(.plain)
            
            // Right 2 Stacked Cards: Luyện bài tập & Treo máy tự học
            VStack(spacing: 10) {
                // Card Top Right: LUYỆN BÀI TẬP (Ảnh có sẵn chữ)
                Button(action: {
                    if let onNavigateToPractice = onNavigateToPractice {
                        onNavigateToPractice()
                    } else {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showingExercise = true
                        }
                    }
                }) {
                    Image("BannerPractice")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                
                // Card Bottom Right: TREO MÁY TỰ HỌC (Ảnh có sẵn chữ)
                Button(action: { showingFocusSheet = true }) {
                    Image("BannerFocus")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(hex: "#FAFAFC"))
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
        )
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
    
    // MARK: - 5. Study History Section (Lịch Sử Học Tập)
    private var studyHistorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(AppTheme.primaryMint)
                    .font(.system(size: 15, weight: .bold))
                Text("Lịch Sử Học Tập")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                Spacer()
            }
            .padding(.horizontal, 2)
            
            ForEach(historyStore.groupedSections, id: \.sectionTitle) { group in
                VStack(alignment: .center, spacing: 8) {
                    // Tiêu đề nhóm theo ngày: -- hôm nay --, -- hôm qua --
                    Text("-- \(group.sectionTitle) --")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(AppTheme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 2)
                    
                    VStack(spacing: 8) {
                        ForEach(group.items) { item in
                            SwipeableHistoryRow(
                                item: item,
                                onSelect: {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        selectedHistoryTopic = item.topicItem
                                    }
                                },
                                onDelete: {
                                    historyStore.remove(id: item.id)
                                }
                            )
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Swipeable History Row (Vuốt Trái Để Xóa Chuẩn iOS)
struct SwipeableHistoryRow: View {
    let item: StudyHistoryItem
    let onSelect: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var isSwiped: Bool = false
    
    private let buttonWidth: CGFloat = 72
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Nút Xóa đỏ nằm phía dưới bên phải
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        onDelete()
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 16, weight: .bold))
                        Text("Xóa")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(width: buttonWidth)
                    .frame(maxHeight: .infinity)
                    .background(Color(hex: "#EF4444"))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            
            // Thẻ nội dung chính
            Button(action: {
                if isSwiped {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        offset = 0
                        isSwiped = false
                    }
                } else {
                    onSelect()
                }
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#ECFDF5"))
                            .frame(width: 38, height: 38)
                        Image(systemName: "book.fill")
                            .font(.system(size: 15))
                            .foregroundColor(AppTheme.primaryMint)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.displaySubtitle)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.gray.opacity(0.5))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
                )
            }
            .buttonStyle(.plain)
            .offset(x: offset)
            .gesture(
                DragGesture(minimumDistance: 15)
                    .onChanged { value in
                        if value.translation.width < 0 {
                            // Vuốt sang trái
                            let drag = value.translation.width + (isSwiped ? -buttonWidth : 0)
                            offset = max(-buttonWidth - 15, drag)
                        } else if isSwiped && value.translation.width > 0 {
                            // Kéo ngược lại về phải
                            offset = min(0, -buttonWidth + value.translation.width)
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            if value.translation.width < -30 {
                                offset = -buttonWidth
                                isSwiped = true
                            } else {
                                offset = 0
                                isSwiped = false
                            }
                        }
                    }
            )
        }
    }
}
