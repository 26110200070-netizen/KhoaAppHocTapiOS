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

// MARK: - Curved Tab Bar Shape (Chuẩn Scoop Notch theo ảnh thiết kế)
struct CurvedTabBarShape: Shape {
    var cornerRadius: CGFloat = 26
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midX = width / 2.0
        
        let scoopWidth: CGFloat = 88
        let scoopDepth: CGFloat = 20
        let scoopStart = midX - scoopWidth / 2.0
        let scoopEnd = midX + scoopWidth / 2.0
        
        // Top-left start
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: 0),
            control: CGPoint(x: 0, y: 0)
        )
        
        // Horizontal line to scoop notch
        path.addLine(to: CGPoint(x: scoopStart, y: 0))
        
        // Smooth scoop dip down to center
        path.addCurve(
            to: CGPoint(x: midX, y: scoopDepth),
            control1: CGPoint(x: scoopStart + scoopWidth * 0.28, y: 0),
            control2: CGPoint(x: midX - scoopWidth * 0.18, y: scoopDepth)
        )
        
        // Smooth scoop rise up to right
        path.addCurve(
            to: CGPoint(x: scoopEnd, y: 0),
            control1: CGPoint(x: midX + scoopWidth * 0.18, y: scoopDepth),
            control2: CGPoint(x: scoopEnd - scoopWidth * 0.28, y: 0)
        )
        
        // Horizontal line to top-right
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: width, y: cornerRadius),
            control: CGPoint(x: width, y: 0)
        )
        
        // Down right side to bottom-right
        path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: width - cornerRadius, y: height),
            control: CGPoint(x: width, y: height)
        )
        
        // Across bottom to bottom-left
        path.addLine(to: CGPoint(x: cornerRadius, y: height))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: height - cornerRadius),
            control: CGPoint(x: 0, y: height)
        )
        
        path.closeSubpath()
        return path
    }
}

struct MainRootView: View {
    @EnvironmentObject var appState: AppState
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
                // 3. Main Application with Floating Curved Bottom Bar
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
                    
                    // Floating Curved Bottom Bar (Trang Chủ • Shimy • Tài Khoản)
                    customCurvedTabBar
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
    }
    
    // MARK: - Floating Curved Bottom Bar chuẩn Thiết Kế Screenshot
    private var customCurvedTabBar: some View {
        ZStack(alignment: .top) {
            // 1. Nền Shape uốn lượn trắng với Scoop notch ở giữa
            CurvedTabBarShape(cornerRadius: 26)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 14, x: 0, y: 4)
                .overlay(
                    CurvedTabBarShape(cornerRadius: 26)
                        .stroke(Color.black.opacity(0.04), lineWidth: 1)
                )
                .frame(height: 68)
            
            // 2. Nội dung 2 nút: Trang Chủ (Trái) - Shimy (Giữa) - Tài Khoản (Phải)
            HStack(spacing: 0) {
                // Tab 1: Trang Chủ
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        currentTab = .home
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 21, weight: currentTab == .home ? .bold : .medium))
                            .foregroundColor(currentTab == .home ? Color(hex: "#0F3E36") : Color(hex: "#9CA3AF"))
                        
                        Text("Trang Chủ")
                            .font(.system(size: 11, weight: currentTab == .home ? .bold : .medium))
                            .foregroundColor(currentTab == .home ? Color(hex: "#0F3E36") : Color(hex: "#9CA3AF"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                }
                .buttonStyle(.plain)
                
                // Khoảng trống ở giữa cho nút tròn Shimy
                Spacer()
                    .frame(width: 88)
                
                // Tab 2: Tài Khoản
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        currentTab = .account
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 21, weight: currentTab == .account ? .bold : .medium))
                            .foregroundColor(currentTab == .account ? Color(hex: "#0F3E36") : Color(hex: "#9CA3AF"))
                        
                        Text("Tài Khoản")
                            .font(.system(size: 11, weight: currentTab == .account ? .bold : .medium))
                            .foregroundColor(currentTab == .account ? Color(hex: "#0F3E36") : Color(hex: "#9CA3AF"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                }
                .buttonStyle(.plain)
            }
            .frame(height: 68)
            
            // 3. Nút tròn Shimy nổi lên giữa rãnh scoop (Elevated Center Button)
            Button(action: {
                showingAIChatFullScreen = true
            }) {
                VStack(spacing: 3) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#10B981"), Color(hex: "#059669")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                            .shadow(color: Color(hex: "#10B981").opacity(0.38), radius: 8, x: 0, y: 3)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("Shimy")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "#0F3E36"))
                }
            }
            .buttonStyle(.plain)
            .offset(y: -14)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}
