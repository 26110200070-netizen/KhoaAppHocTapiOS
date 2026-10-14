import SwiftUI

enum MainTab: Int, CaseIterable {
    case home = 0
    case account = 1
    
    var titleVi: String {
        switch self {
        case .home: return "Trang Chủ"
        case .account: return "Tài Khoản"
        }
    }
    
    var titleEn: String {
        switch self {
        case .home: return "Home"
        case .account: return "Account"
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
    
    var body: some View {
        Group {
            if appState.isLoggedIn {
                ZStack(alignment: .bottom) {
                    // Content Views
                    TabView(selection: $currentTab) {
                        HomeView()
                            .tag(MainTab.home)
                        
                        AccountView()
                            .tag(MainTab.account)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .ignoresSafeArea(.keyboard)
                    
                    // Floating Custom Tab Bar (Video UI Style)
                    customTabBar
                        .padding(.horizontal, 28)
                        .padding(.bottom, 12)
                }
                .ignoresSafeArea(edges: .bottom)
            } else {
                LoginView()
            }
        }
    }
    
    // MARK: - Floating Bottom Navigation Bar
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
                            .font(.system(size: isSelected ? 22 : 20, weight: isSelected ? .bold : .medium))
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
                    .padding(.vertical, 10)
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
