import SwiftUI

struct AccountView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingSwitchAccountSheet: Bool = false
    @State private var showingServerConfigSheet: Bool = false
    @State private var editServerUrl: String = ""
    @State private var editApiKey: String = ""
    @State private var serverTestResult: String = ""
    @State private var isTestingServer: Bool = false
    
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
                    
                    // 1. User Profile Header Card
                    profileHeaderCard
                    
                    // 2. Study Achievements
                    studyAchievementsCard
                    
                    // 3. Settings & Options
                    settingsListCard
                    
                    // 4. Logout Button
                    logoutButton
                    
                    // Spacing for full-width bottom bar
                    Spacer().frame(height: 90)
                }
                .padding(.horizontal, 16)
            }
        }
        .sheet(isPresented: $showingSwitchAccountSheet) {
            switchAccountSheet
        }
        .sheet(isPresented: $showingServerConfigSheet) {
            serverConfigSheet
        }
        .onAppear {
            testServer()
        }
    }
    
    // MARK: - 1. Profile Header Card
    private var profileHeaderCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primaryDark], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 68, height: 68)
                    .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Image(systemName: appState.currentUser.avatarName)
                    .font(.system(size: 34))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(appState.currentUser.username)
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                Text(appState.currentUser.email)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                
                HStack(spacing: 6) {
                    Text("Lớp \(appState.currentUser.grade)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(AppTheme.primaryLight))
                        .foregroundColor(AppTheme.primary)
                    
                    Text(appState.isDeepSeekConnected ? "DeepSeek: Đã kết nối" : "DeepSeek: Chờ kết nối")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(appState.isDeepSeekConnected ? Color.green.opacity(0.12) : Color.orange.opacity(0.12)))
                        .foregroundColor(appState.isDeepSeekConnected ? .green : .orange)
                }
                .padding(.top, 2)
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
    
    // MARK: - 2. Study Achievements
    private var studyAchievementsCard: some View {
        HStack(spacing: 12) {
            achievementTile(title: "Tổng Tự Học", value: "\(appState.totalStudyMinutes)p", icon: "clock.fill", color: AppTheme.primary)
            achievementTile(title: "Phiên Khóa Máy", value: "\(appState.focusSessionCount) lần", icon: "lock.shield.fill", color: AppTheme.primaryMint)
            achievementTile(title: "Khối Đang Học", value: "\(appState.selectedGrade.displayName)", icon: "book.closed.fill", color: AppTheme.accentOrange)
        }
    }
    
    private func achievementTile(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.headline)
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
    }
    
    // MARK: - 3. Settings List
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
            
            // Switch Account Option
            Button(action: { showingSwitchAccountSheet = true }) {
                HStack {
                    Label("Chuyển đổi tài khoản", systemImage: "person.2.badge.gearshape.fill")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(hex: "#111827"))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(AppTheme.textMuted)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
            }
            
            Divider().padding(.horizontal, 16)
            
            // DeepSeek Server & API Key Diagnostic
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Label("DeepSeek AI Server", systemImage: "network")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(hex: "#111827"))
                    Spacer()
                    
                    Button(action: {
                        editServerUrl = appState.deepSeekServerUrl
                        editApiKey = appState.deepSeekApiKey
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
                
                Text(!appState.deepSeekApiKey.isEmpty ? "Đang dùng DeepSeek Cloud API (sk-...)" : appState.deepSeekServerUrl)
                    .font(.caption2)
                    .foregroundColor(AppTheme.textSecondary)
                
                if !serverTestResult.isEmpty {
                    Text(serverTestResult)
                        .font(.caption2)
                        .foregroundColor(appState.isDeepSeekConnected ? .green : .orange)
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
    
    // MARK: - 4. Logout Button
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
    
    private func testServer() {
        isTestingServer = true
        DeepSeekService.shared.checkConnection(serverUrl: appState.deepSeekServerUrl, apiKey: appState.deepSeekApiKey) { online, msg in
            isTestingServer = false
            appState.isDeepSeekConnected = online
            serverTestResult = msg
        }
    }
    
    private var switchAccountSheet: some View {
        NavigationStack {
            List {
                Section(header: Text("Tài khoản đã lưu")) {
                    ForEach(appState.savedAccounts) { user in
                        Button(action: {
                            appState.switchAccount(to: user)
                            showingSwitchAccountSheet = false
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: user.avatarName)
                                    .font(.title2)
                                    .foregroundColor(AppTheme.primary)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(user.username)
                                        .font(.headline)
                                        .foregroundColor(Color(hex: "#111827"))
                                    Text(user.email)
                                        .font(.caption)
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                                Spacer()
                                if appState.currentUser.id == user.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppTheme.primaryMint)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Chuyển Tài Khoản")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { showingSwitchAccountSheet = false }
                }
            }
        }
    }
    
    private var serverConfigSheet: some View {
        NavigationStack {
            Form {
                Section(header: Text("Chế độ 1: Server máy tính (Miễn phí qua Web)")) {
                    TextField("http://192.168.2.16:8000/v1", text: $editServerUrl)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .font(.system(size: 14, design: .monospaced))
                    
                    Text("💡 Mở file `run_deepseek_server.bat` trên máy tính cùng Wi-Fi.")
                        .font(.caption2)
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Section(header: Text("Chế độ 2: DeepSeek API Key (Chính thức - Không bao giờ bị khóa)")) {
                    SecureField("sk-xxxxxxxxxxxxxxxx", text: $editApiKey)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .font(.system(size: 14, design: .monospaced))
                    
                    Text("💡 Nhập API Key chính thức (bắt đầu bằng sk-), app sẽ gọi trực tiếp đến DeepSeek Cloud mà không cần mở máy tính và hoàn toàn không bao giờ bị khóa.")
                        .font(.caption2)
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Section {
                    Button(action: {
                        appState.deepSeekServerUrl = editServerUrl.trimmingCharacters(in: .whitespacesAndNewlines)
                        appState.deepSeekApiKey = editApiKey.trimmingCharacters(in: .whitespacesAndNewlines)
                        testServer()
                        showingServerConfigSheet = false
                    }) {
                        HStack {
                            Spacer()
                            Text("Lưu Cấu Hình & Kiểm Tra")
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.primaryMint)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Cấu Hình DeepSeek")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Hủy") { showingServerConfigSheet = false }
                }
            }
        }
    }
}
