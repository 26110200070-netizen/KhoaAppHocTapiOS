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
    @State private var currentTab: MainTab = .home
    @State private var showingAIChatFullScreen: Bool = false
    
    var body: some View {
        Group {
            if !appState.hasSeenIntro {
                // 1. First time / App Launch: Video Intro Animation
                IntroVideoView()
            } else if !appState.isLoggedIn {
                // 2. Mandatory Login Screen
                LoginView()
            } else {
                // 3. Main Application with Floating Bar + Fullscreen AI Chat
                ZStack(alignment: .bottom) {
                    TabView(selection: $currentTab) {
                        HomeView(onOpenAIChat: {
                            showingAIChatFullScreen = true
                        })
                        .tag(MainTab.home)
                        
                        AccountView()
                            .tag(MainTab.account)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .ignoresSafeArea(.keyboard)
                    
                    // Floating Custom Tab Bar with Center AI Chat Trigger
                    customFloatingTabBar
                        .padding(.horizontal, 28)
                        .padding(.bottom, 12)
                }
                .ignoresSafeArea(edges: .bottom)
                .fullScreenCover(isPresented: $showingAIChatFullScreen) {
                    // Dedicated Fullscreen AI Chat (NO TAB BAR OVERLAP, Back < works!)
                    AIChatView()
                }
            }
        }
    }
    
    // MARK: - Floating Tab Bar with Center Glowing AI Button
    private var customFloatingTabBar: some View {
        HStack(spacing: 0) {
            // Tab 1: Trang Chủ
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    currentTab = .home
                }
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "house.fill")
                        .font(.system(size: currentTab == .home ? 22 : 20, weight: currentTab == .home ? .bold : .medium))
                        .foregroundColor(currentTab == .home ? AppTheme.primaryDark : AppTheme.textMuted)
                    
                    Text("Trang Chủ")
                        .font(.system(size: 11, weight: currentTab == .home ? .semibold : .regular))
                        .foregroundColor(currentTab == .home ? AppTheme.primaryDark : AppTheme.textMuted)
                    
                    Circle()
                        .fill(currentTab == .home ? AppTheme.primaryMint : Color.clear)
                        .frame(width: 4, height: 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            
            // Center Button: GIA SƯ AI (Opens Dedicated Fullscreen Chat!)
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
                            .frame(width: 44, height: 44)
                            .shadow(color: AppTheme.primaryMint.opacity(0.4), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .offset(y: -8)
                    
                    Text("Gia Sư AI")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(AppTheme.primaryDark)
                        .offset(y: -6)
                }
                .frame(maxWidth: .infinity)
            }
            
            // Tab 2: Tài Khoản
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    currentTab = .account
                }
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: currentTab == .account ? 22 : 20, weight: currentTab == .account ? .bold : .medium))
                        .foregroundColor(currentTab == .account ? AppTheme.primaryDark : AppTheme.textMuted)
                    
                    Text("Tài Khoản")
                        .font(.system(size: 11, weight: currentTab == .account ? .semibold : .regular))
                        .foregroundColor(currentTab == .account ? AppTheme.primaryDark : AppTheme.textMuted)
                    
                    Circle()
                        .fill(currentTab == .account ? AppTheme.primaryMint : Color.clear)
                        .frame(width: 4, height: 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 8)
        )
    }
}
