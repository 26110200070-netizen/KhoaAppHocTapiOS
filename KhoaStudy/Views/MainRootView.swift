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
                // 3. Main Application with 3-item Bottom Bar (Trang Chủ • Shimy • Tài Khoản)
                ZStack(alignment: .bottom) {
                    TabView(selection: $currentTab) {
                        HomeView(
                            onOpenAIChat: {
                                showingAIChatFullScreen = true
                            }
                        )
                        .tag(MainTab.home)
                        
                        AccountView()
                            .tag(MainTab.account)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    // Full-Width Bottom Bar with Raised Center Dome (Trang Chủ - Shimy - Tài Khoản)
                    customFullWidthTabBar
                }
                .ignoresSafeArea(edges: .bottom)
                .fullScreenCover(isPresented: $showingAIChatFullScreen) {
                    AIChatView()
                }
            }
        }
    }
    
    // MARK: - Full-Width Bottom Bar (Trang Chủ - Shimy - Tài Khoản)
    private var customFullWidthTabBar: some View {
        ZStack(alignment: .top) {
            // Background with Raised Center Dome Shape
            RaisedDomeTabBarShape()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: -4)
                .frame(height: 94)
            
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
                    .padding(.top, 30)
                }
                
                // Center Button: Shimy (Nằm vừa vặn trong khung vòm bo tròn)
                Button(action: {
                    showingAIChatFullScreen = true
                }) {
                    VStack(spacing: 3) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 58, height: 58)
                                .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 8, x: 0, y: 3)
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [AppTheme.primaryMint, AppTheme.primaryDark],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 52, height: 52)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text("Shimy")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppTheme.primaryDark)
                    }
                    .frame(maxWidth: .infinity)
                    .offset(y: 4)
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
                    .padding(.top, 30)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Custom Shape with Raised Dome in Center (Khung trồi tròn mềm mại chuẩn icon Shimy)
struct RaisedDomeTabBarShape: Shape {
    var domeHeight: CGFloat = 26
    var domeWidth: CGFloat = 92
    var cornerRadius: CGFloat = 22
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w / 2
        let hw = domeWidth / 2
        
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0),
                          control: CGPoint(x: 0, y: 0))
        
        path.addLine(to: CGPoint(x: cx - hw - 8, y: 0))
        
        path.addCurve(
            to: CGPoint(x: cx, y: -domeHeight),
            control1: CGPoint(x: cx - hw + 10, y: 0),
            control2: CGPoint(x: cx - 26, y: -domeHeight)
        )
        
        path.addCurve(
            to: CGPoint(x: cx + hw + 8, y: 0),
            control1: CGPoint(x: cx + 26, y: -domeHeight),
            control2: CGPoint(x: cx + hw - 10, y: 0)
        )
        
        path.addLine(to: CGPoint(x: w - cornerRadius, y: 0))
        path.addQuadCurve(to: CGPoint(x: w, y: cornerRadius),
                          control: CGPoint(x: w, y: 0))
        
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: 0, y: h))
        path.closeSubpath()
        
        return path
    }
}
