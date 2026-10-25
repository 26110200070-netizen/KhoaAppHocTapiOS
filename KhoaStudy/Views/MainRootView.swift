import SwiftUI

enum MainTab: Int, CaseIterable {
    case home = 0
    case account = 1
    
    var title: String {
        switch self {
        case .home: return "Trang Chủ"
        case .account: return "Tài Khoản"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .account: return "person.crop.circle.fill"
        }
    }
}

struct MainRootView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.scenePhase) private var scenePhase
    @State private var currentTab: MainTab = .home
    @State private var showingAIChatFullScreen: Bool = false
    @State private var showingHistoryFullScreen: Bool = false
    
    var body: some View {
        Group {
            if !appState.hasSeenIntro {
                // 1. App Launch: 2-second "Shimy" Fade Intro
                IntroVideoView()
            } else if !appState.isLoggedIn {
                // 2. Mandatory Login Screen
                LoginView()
            } else {
                // 3. Main Application with 3-item Clean Bottom Bar (Trang Chủ • Shimy • Tài Khoản)
                ZStack(alignment: .bottom) {
                    ZStack {
                        HomeView(
                            onOpenAIChat: {
                                showingAIChatFullScreen = true
                            },
                            onOpenHistory: {
                                showingHistoryFullScreen = true
                            }
                        )
                        .opacity(currentTab == .home ? 1 : 0)
                        .allowsHitTesting(currentTab == .home)
                        
                        AccountView()
                            .opacity(currentTab == .account ? 1 : 0)
                            .allowsHitTesting(currentTab == .account)
                    }
                    
                    // Full-Width Flat Bottom Bar (Trang Chủ - Shimy - Tài Khoản)
                    customFlatTabBar
                }
                .ignoresSafeArea(edges: .bottom)
                .fullScreenCover(isPresented: $showingAIChatFullScreen) {
                    AIChatView()
                }
                .fullScreenCover(isPresented: $showingHistoryFullScreen) {
                    StudyHistoryView(onClose: {
                        showingHistoryFullScreen = false
                    })
                }
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                // Khi người dùng thoát/đóng app ra ngoài, reset để khi vào lại sẽ phát intro Shimy
                appState.hasSeenIntro = false
            }
        }
    }
    
    // MARK: - Full-Width Flat Bottom Bar (Cân đối 3 nút: Trang Chủ • Shimy • Tài Khoản)
    private var customFlatTabBar: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 0) {
                // Tab 1: Trang Chủ
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        currentTab = .home
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 20, weight: currentTab == .home ? .bold : .medium))
                            .foregroundColor(currentTab == .home ? AppTheme.primaryDark : AppTheme.textMuted)
                        
                        Text("Trang Chủ")
                            .font(.system(size: 11, weight: currentTab == .home ? .semibold : .regular))
                            .foregroundColor(currentTab == .home ? AppTheme.primaryDark : AppTheme.textMuted)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Center Button: Shimy (Nổi bật, trợ lý học tập)
                Button(action: {
                    showingAIChatFullScreen = true
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [AppTheme.primaryMint, AppTheme.primaryDark],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 40, height: 40)
                                .shadow(color: AppTheme.primaryMint.opacity(0.35), radius: 6, x: 0, y: 2)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text("Shimy")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppTheme.primaryDark)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Tab 2: Tài Khoản
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        currentTab = .account
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 20, weight: currentTab == .account ? .bold : .medium))
                            .foregroundColor(currentTab == .account ? AppTheme.primaryDark : AppTheme.textMuted)
                        
                        Text("Tài Khoản")
                            .font(.system(size: 11, weight: currentTab == .account ? .semibold : .regular))
                            .foregroundColor(currentTab == .account ? AppTheme.primaryDark : AppTheme.textMuted)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 26)
            .background(Color.white)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: -2)
    }
}

