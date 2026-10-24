import SwiftUI

enum AuthMode {
    case login
    case register
}

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var authMode: AuthMode = .login
    
    // Login fields
    @State private var usernameInput: String = "khoadev"
    @State private var passwordInput: String = "123456"
    
    // Register fields
    @State private var registerFullName: String = "Anh Khoa Dev"
    @State private var registerGrade: Int = 12
    
    // Server & Key fields
    @State private var serverUrlInput: String = "http://192.168.2.16:8000/v1"
    @State private var geminiApiKeyInput: String = ""
    
    // Feedback states
    @State private var connectionMessage: String = ""
    @State private var isConnecting: Bool = false
    @State private var isConnectionSuccess: Bool? = nil
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    Spacer(minLength: 20)
                    
                    // App Logo & Header
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primaryDark], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 86, height: 86)
                                .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 15, x: 0, y: 8)
                            
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 38))
                                .foregroundColor(.white)
                        }
                        
                        Text("Shimy")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.primaryDark)
                        
                        Text("Gia sư AI học tập thông minh & Luyện thi K-12")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    // Main Card Form
                    VStack(alignment: .leading, spacing: 18) {
                        // Auth Mode Toggle (Đăng nhập / Đăng ký)
                        HStack(spacing: 0) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) { authMode = .login }
                            }) {
                                Text("Đăng Nhập")
                                    .font(.system(size: 14, weight: authMode == .login ? .bold : .medium))
                                    .foregroundColor(authMode == .login ? .white : AppTheme.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        Capsule()
                                            .fill(authMode == .login ? AppTheme.primary : Color.clear)
                                    )
                            }
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) { authMode = .register }
                            }) {
                                Text("Đăng Ký Tài Khoản")
                                    .font(.system(size: 14, weight: authMode == .register ? .bold : .medium))
                                    .foregroundColor(authMode == .register ? .white : AppTheme.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        Capsule()
                                            .fill(authMode == .register ? AppTheme.primary : Color.clear)
                                    )
                            }
                        }
                        .padding(4)
                        .background(
                            Capsule().fill(AppTheme.secondaryBg)
                        )
                        
                        // Register extra fields
                        if authMode == .register {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Họ và tên của bạn")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                                HStack {
                                    Image(systemName: "person.text.rectangle")
                                        .foregroundColor(AppTheme.primaryMint)
                                    TextField("Ví dụ: Nguyễn Văn A...", text: $registerFullName)
                                }
                                .padding(14)
                                .background(RoundedRectangle(cornerRadius: 16).fill(AppTheme.secondaryBg))
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Khối lớp đang học")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                                Picker("Lớp", selection: $registerGrade) {
                                    ForEach(6...12, id: \.self) { g in
                                        Text("Lớp \(g)").tag(g)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                        
                        // Username Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Tên đăng nhập")
                                .font(.caption)
                                .foregroundColor(AppTheme.textSecondary)
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(AppTheme.primaryMint)
                                TextField("Nhập tên đăng nhập...", text: $usernameInput)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled(true)
                            }
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 16).fill(AppTheme.secondaryBg))
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Mật khẩu")
                                .font(.caption)
                                .foregroundColor(AppTheme.textSecondary)
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(AppTheme.accentOrange)
                                SecureField("Nhập mật khẩu...", text: $passwordInput)
                            }
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 16).fill(AppTheme.secondaryBg))
                        }
                        
                        // Server Endpoint URL
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Máy chủ Backend Shimy")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                                Spacer()
                                Text("Gemini Web Gateway")
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
                                    .font(.system(size: 14, design: .monospaced))
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled(true)
                            }
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 16).fill(AppTheme.secondaryBg))
                            
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
                        
                        // Optional Google AI Studio Gemini API Key
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Google Gemini API Key (Tùy chọn)")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                                Spacer()
                                Text("Cloud Trực Tiếp")
                                    .font(.caption2)
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            
                            HStack {
                                Image(systemName: "key.fill")
                                    .foregroundColor(AppTheme.accentOrange)
                                SecureField("Để trống nếu dùng Gemini Web qua máy chủ...", text: $geminiApiKeyInput)
                                    .font(.system(size: 13, design: .monospaced))
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled(true)
                            }
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 16).fill(AppTheme.secondaryBg))
                        }
                        
                        // Connection / Login Result Message
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
                        
                        // Action Button
                        Button(action: {
                            performAction()
                        }) {
                            HStack {
                                Spacer()
                                if isConnecting {
                                    ProgressView().tint(.white)
                                } else {
                                    Image(systemName: authMode == .login ? "checkmark.shield.fill" : "person.badge.plus")
                                    Text(authMode == .login ? "Đăng Nhập Vào Shimy AI" : "Tạo Tài Khoản & Bắt Đầu Học")
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
                        
                        // Google Gemini Server Guide Note
                        VStack(alignment: .leading, spacing: 5) {
                            Text("💡 Cách kết nối Shimy với Google Gemini:")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.primary)
                            Text("1. Mở file `run_gemini_server.bat` trên máy tính.\n2. Cửa sổ Chromium mở lên, đăng nhập tài khoản Google để lưu session.\n3. Máy chủ Backend tự động bảo vệ chống Google chặn và cung cấp AI cho iPhone!")
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
    
    private func performAction() {
        isConnecting = true
        appState.serverUrl = serverUrlInput.trimmingCharacters(in: .whitespacesAndNewlines)
        appState.geminiApiKey = geminiApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if authMode == .register {
            connectionMessage = "Đang tạo tài khoản trên máy chủ..."
            GeminiAIService.shared.registerToBackend(
                serverUrl: appState.serverUrl,
                username: usernameInput,
                password: passwordInput,
                fullName: registerFullName,
                grade: registerGrade
            ) { success, msg, data in
                isConnecting = false
                isConnectionSuccess = success
                connectionMessage = msg
                
                if success, let d = data {
                    let token = d["token"] as? String ?? ""
                    let role = d["role"] as? String ?? "student"
                    let quota = d["remaining_quota"] as? Int ?? 150
                    appState.login(username: registerFullName, token: token, role: role, remainingQuota: quota, geminiKey: geminiApiKeyInput)
                }
            }
        } else {
            connectionMessage = "Đang xác thực tài khoản & kiểm tra kết nối..."
            GeminiAIService.shared.loginToBackend(
                serverUrl: appState.serverUrl,
                username: usernameInput,
                password: passwordInput
            ) { success, msg, data in
                isConnecting = false
                isConnectionSuccess = success
                connectionMessage = msg
                
                if success, let d = data {
                    let token = d["token"] as? String ?? ""
                    let role = d["role"] as? String ?? "student"
                    let quota = d["remaining_quota"] as? Int ?? 150
                    let name = d["username"] as? String ?? usernameInput
                    appState.login(username: name, token: token, role: role, remainingQuota: quota, geminiKey: geminiApiKeyInput)
                } else {
                    // Fallback: If offline or custom server without auth, verify connection directly
                    GeminiAIService.shared.checkConnection(
                        serverUrl: appState.serverUrl,
                        appToken: "",
                        geminiApiKey: geminiApiKeyInput
                    ) { connOk, connMsg in
                        if connOk {
                            appState.login(username: usernameInput, token: "", role: "student", remainingQuota: 150, geminiKey: geminiApiKeyInput)
                        }
                    }
                }
            }
        }
    }
}
