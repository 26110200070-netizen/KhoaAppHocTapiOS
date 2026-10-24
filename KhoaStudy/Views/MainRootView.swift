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
    
    // MARK: - Full-Width Bottom Bar Menu with Raised Center Dome (Khung trồi tròn chuẩn icon Shimy)
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
                
                // Center Button: Shimy (Nằm vừa vặn, bo tròn ôm khít icon Shimy!)
                Button(action: {
                    showingAIChatFullScreen = true
                }) {
                    VStack(spacing: 3) {
                        ZStack {
                            // Viền trắng bảo vệ ôm tròn
                            Circle()
                                .fill(Color.white)
                                .frame(width: 58, height: 58)
                                .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 8, x: 0, y: 3)
                            
                            // Shimy Avatar Circle
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [AppTheme.primaryMint, AppTheme.primaryDark],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 52, height: 52)
                            
                            // Sparkles Icon
                            Image(systemName: "sparkles")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text("Shimy")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppTheme.primaryDark)
                    }
                    .frame(maxWidth: .infinity)
                    .offset(y: 4) // Nằm trọn vẹn, cân đối bên trong khung trồi tròn
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
        let topY = domeHeight
        let centerX = w / 2.0
        let halfDome = domeWidth / 2.0
        
        // 1. Bottom Left -> Top Left corner
        path.move(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: 0, y: topY + cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: topY),
            control: CGPoint(x: 0, y: topY)
        )
        
        // 2. Flat wing towards center dome
        path.addLine(to: CGPoint(x: centerX - halfDome, y: topY))
        
        // 3. Smooth, organic, continuous Rounded Dome (bo tròn mềm mại, không có cạnh vuông)
        // Left rise: smooth horizontal tangent at start, curving organically up to apex (centerX, 0)
        path.addCurve(
            to: CGPoint(x: centerX, y: 0),
            control1: CGPoint(x: centerX - halfDome + 22, y: topY),
            control2: CGPoint(x: centerX - 18, y: 0)
        )
        // Right descent: smooth horizontal tangent at apex, descending symmetrically to right wing
        path.addCurve(
            to: CGPoint(x: centerX + halfDome, y: topY),
            control1: CGPoint(x: centerX + 18, y: 0),
            control2: CGPoint(x: centerX + halfDome - 22, y: topY)
        )
        
        // 4. Flat wing to Top Right corner
        path.addLine(to: CGPoint(x: w - cornerRadius, y: topY))
        path.addQuadCurve(
            to: CGPoint(x: w, y: topY + cornerRadius),
            control: CGPoint(x: w, y: topY)
        )
        
        // 5. Right edge down & close
        path.addLine(to: CGPoint(x: w, y: h))
        path.closeSubpath()
        
        return path
    }
}
