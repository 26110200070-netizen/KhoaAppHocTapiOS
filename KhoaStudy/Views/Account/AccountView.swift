import SwiftUI

struct AvatarOption: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let color: Color
}

struct AccountView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAvatarPicker: Bool = false
    @State private var showingServerConfigSheet: Bool = false
    @State private var serverTestResult: String = ""
    @State private var isTestingServer: Bool = false
    
    private let avatarOptions: [AvatarOption] = [
        AvatarOption(icon: "person.crop.circle.fill", name: "Cá nhân", color: AppTheme.primaryMint),
        AvatarOption(icon: "graduationcap.fill", name: "Học sinh", color: AppTheme.primary),
        AvatarOption(icon: "sparkles", name: "Tỏa sáng", color: AppTheme.accentOrange),
        AvatarOption(icon: "brain.head.profile", name: "Trí tuệ", color: Color.purple),
        AvatarOption(icon: "book.fill", name: "Chăm học", color: Color.blue),
        AvatarOption(icon: "star.fill", name: "Ngôi sao", color: Color.yellow),
        AvatarOption(icon: "flame.fill", name: "Năng nổ", color: Color.red),
        AvatarOption(icon: "heart.fill", name: "Đam mê", color: Color.pink),
        AvatarOption(icon: "bolt.fill", name: "Tốc độ", color: Color.orange),
        AvatarOption(icon: "pencil.and.outline", name: "Sáng tác", color: Color.teal),
        AvatarOption(icon: "wand.and.stars", name: "Phép màu", color: Color.indigo),
        AvatarOption(icon: "trophy.fill", name: "Thủ khoa", color: Color.yellow)
    ]
    
    var body: some View {
        ZStack {
            // Background covers 100% behind battery & home indicator
            Color(hex: "#F8FAF9")
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    // Custom Header Title (Clean breathing space below battery & clock)
                    HStack {
                        Text("Tài Khoản")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        Spacer()
                    }
                    .padding(.top, 14)
                    .padding(.horizontal, 4)
                    
                    // 1. User Profile Header Card (Interactive Avatar)
                    profileHeaderCard
                    
                    // 2. Settings & Shimy Gateway
                    settingsListCard
                    
                    // 3. Logout Button
                    logoutButton
                    
                    // Spacing for full-width bottom bar
                    Spacer().frame(height: 110)
                }
                .padding(.horizontal, 16)
            }
        }
        .sheet(isPresented: $showingAvatarPicker) {
            avatarPickerSheet
        }
        .sheet(isPresented: $showingServerConfigSheet) {
            GeminiConnectSheet()
        }
        .onAppear {
            testServer()
        }
    }
    
    // MARK: - 1. Profile Header Card
    private var profileHeaderCard: some View {
        HStack(spacing: 16) {
            Button(action: { showingAvatarPicker = true }) {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primaryDark], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 72, height: 72)
                        .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: appState.currentUser.avatarName)
                        .font(.system(size: 34))
                        .foregroundColor(.white)
                    
                    // Edit badge
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                            .shadow(color: Color.black.opacity(0.12), radius: 3)
                        
                        Image(systemName: "pencil")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppTheme.primary)
                    }
                    .offset(x: 2, y: 2)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Text(appState.currentUser.username)
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    
                    Button(action: { showingAvatarPicker = true }) {
                        Text("Đổi avatar")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(AppTheme.primaryMint)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(AppTheme.primaryMint.opacity(0.12)))
                    }
                }
                
                Text(appState.currentUser.email)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(appState.isGeminiConnected ? Color.green : Color.orange)
                        .frame(width: 7, height: 7)
                    Text(appState.isGeminiConnected ? "Shimy AI: Sẵn sàng" : "Shimy AI: Chờ kết nối")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(appState.isGeminiConnected ? .green : .orange)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Capsule().fill(appState.isGeminiConnected ? Color.green.opacity(0.1) : Color.orange.opacity(0.1)))
            }
            
            Spacer()
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
    
    // MARK: - 2. Settings List
    private var settingsListCard: some View {
        VStack(spacing: 0) {
            // Language Option
            HStack {
                Label("Ngôn ngữ hiển thị", systemImage: "globe")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: "#111827"))
                Spacer()
                
                Menu {
                    ForEach(AppLanguage.allCases, id: \.self) { lang in
                        Button(action: {
                            withAnimation { appState.currentLanguage = lang }
                        }) {
                            HStack {
                                Text("\(lang.flag) \(lang.rawValue)")
                                if appState.currentLanguage == lang {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text("\(appState.currentLanguage.flag) \(appState.currentLanguage.rawValue)")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppTheme.primary)
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption2)
                            .foregroundColor(AppTheme.primary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(AppTheme.primaryLight))
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            
            Divider().padding(.horizontal, 16)
            
            // Shimy Server & Gemini Diagnostic (Compact & Clean)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Label("Shimy Gemini Gateway", systemImage: "network")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(hex: "#111827"))
                    Spacer()
                    
                    Button(action: {
                        showingServerConfigSheet = true
                    }) {
                        Text("Cấu hình")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.primaryMint)
                    }
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(AppTheme.textMuted)
                    
                    Button(action: { testServer() }) {
                        if isTestingServer {
                            ProgressView().scaleEffect(0.7)
                        } else {
                            Text("Kiểm tra")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.primary)
                        }
                    }
                }
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(appState.isGeminiConnected ? Color.green : Color.orange)
                        .frame(width: 7, height: 7)
                    
                    Text(appState.selectedProvider == .groq ? "Groq Cloud LPU (\(GroqModel(rawValue: appState.selectedGroqModel)?.shortName ?? appState.selectedGroqModel))" : (!appState.geminiApiKey.isEmpty ? "Google Cloud Direct" : appState.serverUrl))
                        .font(.caption2)
                        .foregroundColor(AppTheme.textSecondary)
                        .lineLimit(1)
                    
                    if !serverTestResult.isEmpty {
                        Text("•")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textMuted)
                        Text(serverTestResult)
                            .font(.caption2)
                            .foregroundColor(appState.isGeminiConnected ? .green : .orange)
                            .lineLimit(1)
                    }
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            
            Divider().padding(.horizontal, 16)
            
            // Version
            HStack {
                Label("Phiên bản", systemImage: "info.circle.fill")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: "#111827"))
                Spacer()
                Text("Shimy v1.2.0")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
    
    // MARK: - 3. Logout Button
    private var logoutButton: some View {
        Button(action: {
            withAnimation { appState.logout() }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Đăng Xuất Tài Khoản")
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.red.opacity(0.08))
            )
        }
    }
    
    // MARK: - Avatar Picker Sheet
    private var avatarPickerSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Chọn biểu tượng đại diện phù hợp với bạn")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textSecondary)
                        .padding(.top, 14)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(avatarOptions) { opt in
                            let isSelected = appState.currentUser.avatarName == opt.icon
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    appState.updateAvatar(opt.icon)
                                }
                            }) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(opt.color.opacity(isSelected ? 0.25 : 0.12))
                                            .frame(width: 64, height: 64)
                                        
                                        Image(systemName: opt.icon)
                                            .font(.system(size: 30))
                                            .foregroundColor(opt.color)
                                        
                                        if isSelected {
                                            Circle()
                                                .strokeBorder(opt.color, lineWidth: 3)
                                                .frame(width: 68, height: 68)
                                        }
                                    }
                                    
                                    Text(opt.name)
                                        .font(.caption)
                                        .fontWeight(isSelected ? .bold : .medium)
                                        .foregroundColor(Color(hex: "#111827"))
                                }
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(isSelected ? opt.color.opacity(0.08) : Color.white)
                                        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 30)
            }
            .background(Color(hex: "#F8FAF9").ignoresSafeArea())
            .navigationTitle("Đổi Avatar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Xong") {
                        showingAvatarPicker = false
                    }
                    .font(.body.weight(.bold))
                    .foregroundColor(AppTheme.primaryMint)
                }
            }
        }
    }
    
    private func testServer() {
        isTestingServer = true
        GeminiAIService.shared.checkConnection(
            serverUrl: appState.serverUrl,
            appToken: appState.appAuthToken,
            geminiApiKey: appState.geminiApiKey,
            groqApiKey: appState.groqApiKey,
            provider: appState.selectedProvider
        ) { online, msg in
            isTestingServer = false
            appState.isAIConnected = online
            serverTestResult = msg
        }
    }
}
