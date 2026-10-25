import SwiftUI

enum MainTab: Int, CaseIterable {
    case home = 0
    case history = 1
    case account = 2
    
    var title: String {
        switch self {
        case .home: return "Trang Chủ"
        case .history: return "Lịch Sử"
        case .account: return "Tài Khoản"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .history: return "clock.arrow.circlepath"
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
                // 3. Main Application with 4-item Flat Bottom Bar (Trang Chủ • Lịch Sử • Shimy • Tài Khoản)
                ZStack(alignment: .bottom) {
                    // Không dùng TabView page-style để cấm kéo vuốt qua lại, bấm chuyển tab mượt mà & giữ nguyên trạng thái không reload
                    ZStack {
                        HomeView(
                            onOpenAIChat: {
                                showingAIChatFullScreen = true
                            },
                            onOpenHistory: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    currentTab = .history
                                }
                            }
                        )
                        .opacity(currentTab == .home ? 1 : 0)
                        .allowsHitTesting(currentTab == .home)
                        
                        StudyHistoryView()
                            .opacity(currentTab == .history ? 1 : 0)
                            .allowsHitTesting(currentTab == .history)
                        
                        AccountView()
                            .opacity(currentTab == .account ? 1 : 0)
                            .allowsHitTesting(currentTab == .account)
                    }
                    
                    // Full-Width Flat Bottom Bar (Trang Chủ - Lịch Sử - Shimy - Tài Khoản)
                    customFlatTabBar
                }
                .ignoresSafeArea(edges: .bottom)
                .fullScreenCover(isPresented: $showingAIChatFullScreen) {
                    AIChatView()
                }
            }
        }
    }
    
    // MARK: - Full-Width Flat Bottom Bar (Bằng phẳng, cân đối 4 nút)
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
                
                // Tab 2: Lịch Sử Học Tập (Tab riêng biệt theo yêu cầu)
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        currentTab = .history
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 20, weight: currentTab == .history ? .bold : .medium))
                            .foregroundColor(currentTab == .history ? AppTheme.primaryDark : AppTheme.textMuted)
                        
                        Text("Lịch Sử")
                            .font(.system(size: 11, weight: currentTab == .history ? .semibold : .regular))
                            .foregroundColor(currentTab == .history ? AppTheme.primaryDark : AppTheme.textMuted)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Center Button: Shimy (Bằng phẳng, cân đối)
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
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text("Shimy")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppTheme.primaryDark)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Tab 3: Tài Khoản
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
