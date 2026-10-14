import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var usernameInput: String = "Anh Khoa Dev"
    @State private var serverUrlInput: String = "http://192.168.2.16:8000/v1"
    @State private var apiKeyInput: String = ""
    @State private var connectionMessage: String = ""
    @State private var isConnecting: Bool = false
    @State private var isConnectionSuccess: Bool? = nil
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Spacer(minLength: 30)
                    
                    // App Logo & Mascot
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primaryDark], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 88, height: 88)
                                .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 15, x: 0, y: 8)
                            
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        
                        Text("KhoaStudy")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.primaryDark)
                        
                        Text("Học tập thông minh cùng DeepSeek AI")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    // Login Form Card
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Đăng nhập với DeepSeek API")
                            .font(.headline)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        // Username Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Tên đăng nhập của bạn")
                                .font(.caption)
                                .foregroundColor(AppTheme.textSecondary)
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(AppTheme.primaryMint)
                                TextField("Nhập tên đăng nhập...", text: $usernameInput)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppTheme.secondaryBg)
                            )
                        }
                        
                        // Server Endpoint URL
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Endpoint DeepSeek-API Server")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                                Spacer()
                                Text("Deepseek-API (Local)")
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Capsule().fill(AppTheme.primaryLight))
                                    .foregroundColor(AppTheme.primary)
                            }
                            
                            HStack {
                                Image(systemName: "network")
                                    .foregroundColor(AppTheme.primary)
                                TextField("http://192.168.2.16:8000/v1", text: $serverUrlInput)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppTheme.secondaryBg)
                            )
                            
                            // Quick IP Presets
                            HStack(spacing: 8) {
                                Button("IP Wi-Fi (192.168.2.16)") {
                                    serverUrlInput = "http://192.168.2.16:8000/v1"
                                }
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(Color.white))
                                .foregroundColor(AppTheme.primary)
                                
                                Button("Localhost (localhost:8000)") {
                                    serverUrlInput = "http://localhost:8000/v1"
                                }
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(Color.white))
                                .foregroundColor(AppTheme.textSecondary)
                            }
                            .padding(.top, 2)
                        }
                        
                        // DeepSeek API Key (Optional)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("API Token / Bearer Token (Tùy chọn)")
                                .font(.caption)
                                .foregroundColor(AppTheme.textSecondary)
                            HStack {
                                Image(systemName: "key.fill")
                                    .foregroundColor(AppTheme.accentOrange)
                                SecureField("Để trống nếu dùng session server tự động...", text: $apiKeyInput)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppTheme.secondaryBg)
                            )
                        }
                        
                        // Connection Check Feedback
                        if !connectionMessage.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: (isConnectionSuccess == true) ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                                    .foregroundColor((isConnectionSuccess == true) ? .green : .orange)
                                Text(connectionMessage)
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textPrimary)
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill((isConnectionSuccess == true) ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
                            )
                        }
                        
                        // Button Check Connection & Login
                        Button(action: {
                            performServerLogin()
                        }) {
                            HStack {
                                Spacer()
                                if isConnecting {
                                    ProgressView().tint(.white)
                                } else {
                                    Image(systemName: "checkmark.shield.fill")
                                    Text("Đăng Nhập Với DeepSeek")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                }
                                Spacer()
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primary], startPoint: .leading, endPoint: .trailing))
                            )
                            .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .disabled(isConnecting)
                        
                        // Google Account Note
                        VStack(alignment: .leading, spacing: 4) {
                            Text("💡 Cách đăng nhập tài khoản Google:")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.primary)
                            Text("1. Chạy file run_deepseek_server.bat trên máy tính.\n2. Trình duyệt mở lên, đăng nhập tài khoản Google của bạn tại DeepSeek.\n3. Máy chủ sẽ tự động nhận session và đồng bộ với app!")
                                .font(.caption2)
                                .foregroundColor(AppTheme.textSecondary)
                                .lineSpacing(3)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(AppTheme.primaryLight)
                        )
                    }
                    .cleanCard(cornerRadius: 24, padding: 22)
                    
                    // Language Switcher Pills
                    HStack(spacing: 8) {
                        ForEach(AppLanguage.allCases, id: \.self) { lang in
                            Button(action: {
                                withAnimation { appState.currentLanguage = lang }
                            }) {
                                HStack(spacing: 6) {
                                    Text(lang.flag)
                                    Text(lang.rawValue)
                                        .font(.caption)
                                        .fontWeight(appState.currentLanguage == lang ? .bold : .regular)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(appState.currentLanguage == lang ? AppTheme.primaryDark : Color.white)
                                )
                                .foregroundColor(appState.currentLanguage == lang ? .white : AppTheme.textPrimary)
                                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func performServerLogin() {
        isConnecting = true
        connectionMessage = "Đang kết nối DeepSeek Server..."
        
        DeepSeekService.shared.checkConnection(serverUrl: serverUrlInput, apiKey: apiKeyInput) { success, message in
            isConnecting = false
            isConnectionSuccess = success
            connectionMessage = message
            
            // Save state and proceed
            appState.deepSeekServerUrl = serverUrlInput
            appState.deepSeekApiKey = apiKeyInput
            appState.isDeepSeekConnected = success
            
            // Allow login (either server verified or offline mode with credentials)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                appState.login(username: usernameInput, apiKey: apiKeyInput)
            }
        }
    }
}
