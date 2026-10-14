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
                // 1. App Launch: 2-second "Shimy" Fade Intro
                IntroVideoView()
            } else if !appState.isLoggedIn {
                // 2. Mandatory Login Screen
                LoginView()
            } else {
                // 3. Main Application with Full-Width Bottom Bar + Fullscreen AI Chat
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
                    // Do NOT ignore top safe area! This preserves top space for battery & clock.
                    
                    // Full-Width Bottom Bar across horizontal screen
                    customFullWidthTabBar
                }
                .ignoresSafeArea(edges: .bottom)
                .fullScreenCover(isPresented: $showingAIChatFullScreen) {
                    // Dedicated Fullscreen AI Chat (NO TAB BAR OVERLAP, Back < works!)
                    AIChatView()
                }
            }
        }
    }
    
    // MARK: - Full-Width Bottom Bar Menu (Full chiều ngang)
    private var customFullWidthTabBar: some View {
        HStack(spacing: 0) {
            // Tab 1: Trang Chủ
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    currentTab = .home
                }
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 22, weight: currentTab == .home ? .bold : .medium))
                        .foregroundColor(currentTab == .home ? AppTheme.primaryDark : AppTheme.textMuted)
                    
                    Text("Trang Chủ")
                        .font(.system(size: 11, weight: currentTab == .home ? .semibold : .regular))
                        .foregroundColor(currentTab == .home ? AppTheme.primaryDark : AppTheme.textMuted)
                    
                    Circle()
                        .fill(currentTab == .home ? AppTheme.primaryMint : Color.clear)
                        .frame(width: 4, height: 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            }
            
            // Center Button: GIA SƯ AI (Mở Fullscreen Chat riêng biệt!)
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
                            .frame(width: 48, height: 48)
                            .shadow(color: AppTheme.primaryMint.opacity(0.4), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .offset(y: -10)
                    
                    Text("Gia Sư AI")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(AppTheme.primaryDark)
                        .offset(y: -8)
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
                        .font(.system(size: 22, weight: currentTab == .account ? .bold : .medium))
                        .foregroundColor(currentTab == .account ? AppTheme.primaryDark : AppTheme.textMuted)
                    
                    Text("Tài Khoản")
                        .font(.system(size: 11, weight: currentTab == .account ? .semibold : .regular))
                        .foregroundColor(currentTab == .account ? AppTheme.primaryDark : AppTheme.textMuted)
                    
                    Circle()
                        .fill(currentTab == .account ? AppTheme.primaryMint : Color.clear)
                        .frame(width: 4, height: 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 22) // Space for home indicator
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: -4)
        )
    }
}
