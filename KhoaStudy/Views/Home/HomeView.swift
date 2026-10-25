import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    var onNavigateToTheory: (() -> Void)? = nil
    var onNavigateToPractice: (() -> Void)? = nil
    var onOpenAIChat: (() -> Void)? = nil
    var onOpenHistory: (() -> Void)? = nil
    
    @ObservedObject private var historyStore = StudyHistoryStore.shared
    @ObservedObject private var examStore = ExamHistoryStore.shared
    @State private var showingTheory: Bool = false
    @State private var showingExercise: Bool = false
    @State private var showingFocusSheet: Bool = false
    @State private var showingExamSheet: Bool = false
    @State private var showingMindmapSheet: Bool = false
    @State private var showingStatisticsSheet: Bool = false
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
        .fullScreenCover(isPresented: $showingMindmapSheet) {
            KnowledgeMindmapView(onOpenAIChatWithTopic: { topic in
                onOpenAIChat?()
            })
        }
        .fullScreenCover(isPresented: $showingStatisticsSheet) {
            StudyStatisticsView()
        }
    }
    
    // MARK: - Home Dashboard Content
    private var homeDashboardView: some View {
        ZStack(alignment: .top) {
            // Full-bleed clean background
            Color(hex: "#F8FAF9")
                .ignoresSafeArea(.all)
            
            // 1. Realistic blue sky with fluffy clouds at top
            // Width strictly locked to UIScreen.main.bounds.width with .clipped() to eliminate horizontal overflow
            VStack(spacing: 0) {
                Image("HeaderSkyBg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 210)
                    .clipped()
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width, alignment: .top)
            .clipped()
            .ignoresSafeArea(edges: .top)
            
            // 2. Scrollable dashboard content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // 1. Top Header (✨ Shimy • Lớp 12 | Chào, Anh Khoa Dev 👋 | 📊 + 🎓 + 🔔)
                    topHeaderSection
                        .padding(.top, 6)
                    
                    // 2. Banner Sơ Đồ Kiến Thức ("Hình dung lộ trình, làm chủ bài học")
                    knowledgeMindmapBanner
                    
                    // 3. Khối 3 Thẻ Học Tập: Học Lí Thuyết 9:16 + Luyện Bài Tập & Treo Máy
                    tammiChibiArtworkCardsSection
                    
                    // 4. Banner Sơ Đồ Thống Kê Học Tập (MỚI)
                    studyStatisticsInteractiveBanner
                    
                    // 5. Banner Lịch Sử Học Tập (Dài ngang)
                    studyHistoryInteractiveBanner
                    
                    // 6. Banner Ôn Thi Bứt Phá Điểm Cao (Màu đỏ)
                    tammiPromoExamBanner
                    
                    // Spacing above bottom tab bar
                    Spacer().frame(height: 110)
                }
                .padding(.horizontal, 16)
            }
            .frame(width: UIScreen.main.bounds.width)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - 1. Top Header (Bầu trời nền, Chào user, 📊 Thống kê, 🎓 Sơ đồ tư duy, 🔔 Chuông)
    private var topHeaderSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 5) {
                    Image(systemName: "sparkles")
                        .foregroundColor(Color(hex: "#059669"))
                        .font(.system(size: 12, weight: .bold))
                    Text("Shimy • Lớp \(appState.currentUser.grade)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "#4B5563"))
                }
                
                Text("Chào, \(appState.currentUser.username) 👋")
                    .font(.system(size: 21, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
            }
            
            Spacer()
            
            // Top Right Action Buttons: 📊 (Thống kê) & 🎓 (Nón tốt nghiệp) & 🔔 (Chuông)
            HStack(spacing: 8) {
                // Statistics Button
                Button(action: {
                    showingStatisticsSheet = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#D1FAE5"))
                            .frame(width: 42, height: 42)
                            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 17))
                            .foregroundColor(Color(hex: "#059669"))
                    }
                }
                
                // Graduate Cap Button (Mindmap)
                Button(action: {
                    showingMindmapSheet = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#E0F2FE"))
                            .frame(width: 42, height: 42)
                            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        Image(systemName: "graduationcap.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: "#0284C7"))
                    }
                }
                
                // Bell Notification Button
                Button(action: {
                    onOpenAIChat?()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 42, height: 42)
                            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        Image(systemName: "bell.fill")
                            .font(.system(size: 17))
                            .foregroundColor(Color(hex: "#4B5563"))
                        
                        // Red notification dot
                        Circle()
                            .fill(Color(hex: "#EF4444"))
                            .frame(width: 8, height: 8)
                            .offset(x: 7, y: -7)
                    }
                }
            }
        }
        .padding(.horizontal, 2)
        .padding(.vertical, 4)
    }
    
    // MARK: - 2. Banner Sơ Đồ Kiến Thức (Hình dung lộ trình, làm chủ bài học)
    private var knowledgeMindmapBanner: some View {
        Button(action: {
            showingMindmapSheet = true
        }) {
            Image("CardMindmap")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - 3. Khối 3 Thẻ Học Tập (Học lí thuyết SGK 9:16 + Luyện bài tập & Treo máy tự học)
    private var tammiChibiArtworkCardsSection: some View {
        let screenW = UIScreen.main.bounds.width
        let availableW = max(screenW - 32 - 24 - 10, 280) // màn hình - padding(16*2) - container(12*2) - spacing(10)
        let leftW = availableW * 0.408
        let rightW = availableW * 0.592
        let totalH = leftW * (16.0 / 9.0)
        let topH = (totalH - 10) * 0.565
        let bottomH = totalH - 10 - topH
        
        return HStack(alignment: .top, spacing: 10) {
            // Left Hero Card: HỌC LÍ THUYẾT SGK (Chuẩn tỉ lệ 9:16)
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
                    .scaledToFill()
                    .frame(width: leftW, height: totalH)
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
                        .scaledToFill()
                        .frame(width: rightW, height: topH)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                
                // Card Bottom Right: TREO MÁY TỰ HỌC (Ảnh có sẵn chữ)
                Button(action: { showingFocusSheet = true }) {
                    Image("BannerFocus")
                        .resizable()
                        .scaledToFill()
                        .frame(width: rightW, height: bottomH)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .frame(width: rightW, height: totalH)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 3)
        )
    }
    
    // MARK: - 4. Banner Sơ Đồ Thống Kê Học Tập (Phẳng, hiện đại, KHÔNG khung lồng khung)
    private var studyStatisticsInteractiveBanner: some View {
        Button(action: {
            showingStatisticsSheet = true
        }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#D1FAE5"), Color(hex: "#A7F3D0")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "chart.bar.xaxis")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(hex: "#059669"))
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text("Sơ Đồ Thống Kê")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        
                        Text("MỚI")
                            .font(.system(size: 9, weight: .heavy))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(hex: "#059669"))
                            .clipShape(Capsule())
                    }
                    
                    let totalHours = appState.totalStudyMinutes / 60
                    let totalMins = appState.totalStudyMinutes % 60
                    let timeStr = totalHours > 0 ? "\(totalHours)h \(totalMins)p" : "\(totalMins)p"
                    let examSubtitle: String = {
                        if examStore.records.isEmpty {
                            return "Đã nạp \(historyStore.historyList.count) bài • Tự học \(timeStr) • Chưa thi thử"
                        } else {
                            let avg = examStore.records.map { $0.score }.reduce(0, +) / Double(examStore.records.count)
                            return "Đã nạp \(historyStore.historyList.count) bài • Tự học \(timeStr) • ĐTB \(String(format: "%.1f", avg))"
                        }
                    }()
                    Text(examSubtitle)
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.gray.opacity(0.45))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - 5. Banner Lịch Sử Học Tập (Chuẩn Ảnh 2)
    private var studyHistoryInteractiveBanner: some View {
        Button(action: {
            onOpenHistory?()
        }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#E0F2FE"), Color(hex: "#BAE6FD")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(hex: "#0284C7"))
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text("Lịch Sử Học Tập")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        
                        if !historyStore.historyList.isEmpty {
                            Text("\(historyStore.historyList.count)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(hex: "#0284C7"))
                                .clipShape(Capsule())
                        }
                    }
                    Text(historyStore.historyList.isEmpty ? "Chưa có bài học nào được lưu gần đây" : "Gần nhất: \(historyStore.historyList.first?.topicItem.title ?? "Xem lại bài giảng")")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.gray.opacity(0.45))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - 5. Banner Ôn Thi Bứt Phá Điểm Cao (Màu đỏ chuẩn Ảnh 2)
    private var tammiPromoExamBanner: some View {
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
                    
                    Text("Ôn Thi Bứt Phá Điểm Cao...")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineSpacing(2)
                    
                    Button(action: { showingExamSheet = true }) {
                        Text("LÀM ĐỀ THI NGAY")
                            .font(.system(size: 11, weight: .heavy))
                            .foregroundColor(Color(hex: "#DC2626"))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(Capsule().fill(Color.white))
                    }
                    .padding(.top, 4)
                }
                .padding(18)
                
                Spacer()
                
                Image("ChibiExamBanner")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 88, height: 88)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .padding(.trailing, 16)
            }
        }
        .frame(height: 135)
        .shadow(color: Color(hex: "#DC2626").opacity(0.25), radius: 10, x: 0, y: 5)
    }
}
