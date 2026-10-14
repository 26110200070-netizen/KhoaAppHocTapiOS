import SwiftUI

enum MainTab: Int, CaseIterable {
    case home = 0
    case aiChat = 1
    case account = 2
    
    var titleVi: String {
        switch self {
        case .home: return "Trang Chủ"
        case .aiChat: return "Gia Sư AI"
        case .account: return "Tài Khoản"
        }
    }
    
    var titleEn: String {
        switch self {
        case .home: return "Home"
        case .aiChat: return "AI Tutor"
        case .account: return "Account"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .aiChat: return "sparkles"
        case .account: return "person.crop.circle.fill"
        }
    }
}

struct MainRootView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentTab: MainTab = .home
    
    var body: some View {
        Group {
            if appState.isLoggedIn {
                ZStack(alignment: .bottom) {
                    // Content Views
                    TabView(selection: $currentTab) {
                        HomeView()
                            .tag(MainTab.home)
                        
                        AIChatView()
                            .tag(MainTab.aiChat)
                        
                        AccountView()
                            .tag(MainTab.account)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .ignoresSafeArea(.keyboard)
                    
                    // Floating Custom Tab Bar (Video UI Style)
                    customTabBar
                        .padding(.horizontal, 24)
                        .padding(.bottom, 12)
                }
                .ignoresSafeArea(edges: .bottom)
            } else {
                LoginView()
            }
        }
    }
    
    // MARK: - Floating Bottom Navigation Bar (Video Style with Active Dot)
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(MainTab.allCases, id: \.self) { tab in
                let isSelected = (currentTab == tab)
                
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        currentTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: isSelected ? 21 : 19, weight: isSelected ? .bold : .medium))
                            .foregroundColor(isSelected ? AppTheme.primaryDark : AppTheme.textMuted)
                        
                        Text(appState.currentLanguage == .vietnamese ? tab.titleVi : tab.titleEn)
                            .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                            .foregroundColor(isSelected ? AppTheme.primaryDark : AppTheme.textMuted)
                        
                        // Active dot pill indicator (matching video)
                        Circle()
                            .fill(isSelected ? AppTheme.primaryMint : Color.clear)
                            .frame(width: 4, height: 4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
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
