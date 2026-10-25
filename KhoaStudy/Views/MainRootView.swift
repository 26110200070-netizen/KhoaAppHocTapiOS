import SwiftUI

enum MainTab: Int, CaseIterable {
    case home = 0
    case theory = 1
    case practice = 2
    case account = 3
    
    var title: String {
        switch self {
        case .home: return "Trang Chủ"
        case .theory: return "Lý Thuyết"
        case .practice: return "Luyện Tập"
        case .account: return "Tài Khoản"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .theory: return "book.fill"
        case .practice: return "pencil.and.list.clipboard"
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
                        HomeView(
                            onNavigateToTheory: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                    currentTab = .theory
                                }
                            },
                            onNavigateToPractice: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                    currentTab = .practice
                                }
                            },
                            onOpenAIChat: {
                                showingAIChatFullScreen = true
                            }
                        )
                        .tag(MainTab.home)
                        
                        TheoryStudyView(onBackToHome: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                currentTab = .home
                            }
                        })
                        .tag(MainTab.theory)
                        
                        ExercisePracticeView()
                            .tag(MainTab.practice)
                        
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
                tabBarItem(tab: .home)
                
                // Tab 2: Lý Thuyết
                tabBarItem(tab: .theory)
                
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
                
                // Tab 3: Luyện Tập
                tabBarItem(tab: .practice)
                
                // Tab 4: Tài Khoản
                tabBarItem(tab: .account)
            }
            .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func tabBarItem(tab: MainTab) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                currentTab = tab
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: tab.iconName)
                    .font(.system(size: 20, weight: currentTab == tab ? .bold : .medium))
                    .foregroundColor(currentTab == tab ? AppTheme.primaryDark : AppTheme.textMuted)
                
                Text(tab.title)
                    .font(.system(size: 10, weight: currentTab == tab ? .bold : .regular))
                    .foregroundColor(currentTab == tab ? AppTheme.primaryDark : AppTheme.textMuted)
                
                Circle()
                    .fill(currentTab == tab ? AppTheme.primaryMint : Color.clear)
                    .frame(width: 4, height: 4)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 28)
        }
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
