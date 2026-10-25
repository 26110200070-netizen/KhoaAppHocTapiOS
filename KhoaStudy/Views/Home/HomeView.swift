import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    var onNavigateToTheory: (() -> Void)? = nil
    var onNavigateToPractice: (() -> Void)? = nil
    var onOpenAIChat: (() -> Void)? = nil
    var onOpenHistory: (() -> Void)? = nil
    
    @ObservedObject private var historyStore = StudyHistoryStore.shared
    @State private var showingTheory: Bool = false
    @State private var showingExercise: Bool = false
    @State private var showingFocusSheet: Bool = false
    @State private var showingExamSheet: Bool = false
    @State private var showingMindmapSheet: Bool = false
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
    }
    
    // MARK: - Home Dashboard Content (Chuẩn 100% theo Ảnh 2 - Không tràn lề, Không lặp chữ)
    private var homeDashboardView: some View {
        ZStack(alignment: .top) {
            // Full-bleed clean background
            Color(hex: "#F8FAF9")
                .ignoresSafeArea()
            
            // Dreamy pastel sky gradient for top status bar and header (Không dùng ảnh chữ tĩnh để tránh đè chữ)
            LinearGradient(
                colors: [
                    Color(hex: "#CFE6FC"),
                    Color(hex: "#E5F2FD"),
                    Color(hex: "#F8FAF9")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 230)
            .ignoresSafeArea(edges: .top)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    // 1. Top Header (✨ Shimy • Lớp 12 | Chào, Anh Khoa Dev 👋 | Mascot Bunny)
                    topHeaderSection
                        .padding(.top, 4)
                    
                    // 2. Hero Banner: Bứt phá điểm số cùng Shimy (3D anime boy with laptop)
                    heroBannerSection
                    
                    // 3. 3-Card Row: Học lí thuyết | Làm bài tập | Treo máy tự học
                    threeFeatureCardsRow
                    
                    // 4. Sơ Đồ Kiến Thức (Node mindmap banner)
                    knowledgeMindmapBanner
                    
                    // 5. Quote Card: "Kiến thức là chìa khóa mở ra mọi cánh cửa tương lai."
                    inspirationalQuoteCard
                    
                    // Spacing above bottom tab bar
                    Spacer().frame(height: 110)
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - 1. Top Header (✨ Shimy • Lớp 12, Chào user, Bunny Avatar)
    private var topHeaderSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 5) {
                    Image(systemName: "sparkles")
                        .foregroundColor(Color(hex: "#0284C7"))
                        .font(.system(size: 11, weight: .bold))
                    Text("Shimy • Lớp \(appState.currentUser.grade)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#4B5563"))
                }
                
                Text("Chào, \(appState.currentUser.username) 👋")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                
                Text("Học hôm nay, vững tương lai!")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(hex: "#6B7280"))
            }
            
            Spacer()
            
            // 3D Mascot Bunny Avatar
            Button(action: {
                onOpenAIChat?()
            }) {
                Image("MascotBunny")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(color: Color(hex: "#38BDF8").opacity(0.35), radius: 6, x: 0, y: 2)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
    }
    
    // MARK: - 2. Hero Banner: Bứt phá điểm số cùng Shimy
    private var heroBannerSection: some View {
        Button(action: {
            onOpenAIChat?()
        }) {
            Image("HeroBanner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - 3. Three Feature Cards Row (Học lí thuyết • Làm bài tập • Treo máy)
    private var threeFeatureCardsRow: some View {
        HStack(spacing: 8) {
            // Card 1: Học lí thuyết (Mở bài giảng SGK chuẩn)
            Button(action: {
                if let onNavigateToTheory = onNavigateToTheory {
                    onNavigateToTheory()
                } else {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showingTheory = true
                    }
                }
            }) {
                Image("CardTheory")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
            }
            .buttonStyle(.plain)
            
            // Card 2: Làm bài tập (Luyện đề, kiểm tra kiến thức)
            Button(action: {
                if let onNavigateToPractice = onNavigateToPractice {
                    onNavigateToPractice()
                } else {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showingExercise = true
                    }
                }
            }) {
                Image("CardPractice")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
            }
            .buttonStyle(.plain)
            
            // Card 3: Treo máy tự học (Pomodoro focus timer)
            Button(action: {
                showingFocusSheet = true
            }) {
                Image("CardFocus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - 4. Sơ Đồ Kiến Thức Banner (Hệ thống hóa toàn bộ kiến thức trực quan)
    private var knowledgeMindmapBanner: some View {
        Button(action: {
            showingMindmapSheet = true
        }) {
            Image("CardMindmap")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - 5. Inspirational Quote Card
    private var inspirationalQuoteCard: some View {
        Image("CardQuote")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 1)
    }
}
