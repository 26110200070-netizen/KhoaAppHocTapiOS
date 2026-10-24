import SwiftUI
import SafariServices

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    // API Key input
    @State private var geminiApiKeyInput: String = ""
    
    // Feedback states
    @State private var connectionMessage: String = ""
    @State private var isConnecting: Bool = false
    @State private var isConnectionSuccess: Bool? = nil
    @State private var showingSafari: Bool = false
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Spacer(minLength: 30)
                    
                    // App Logo & Header
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primaryDark], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 88, height: 88)
                                .shadow(color: AppTheme.primaryMint.opacity(0.35), radius: 16, x: 0, y: 8)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        
                        Text("Shimy")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.primaryDark)
                        
                        Text("Gia sư AI học tập thông minh & Luyện thi K-12")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    // Main Login Card
                    VStack(alignment: .leading, spacing: 18) {
                        // Title
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Đăng Nhập Google Gemini")
                                .font(.system(size: 19, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#111827"))
                            Text("Chỉ cần dán Google Gemini API Key để kích hoạt AI trực tiếp trên điện thoại.")
                                .font(.caption)
                                .foregroundColor(AppTheme.textSecondary)
                                .lineSpacing(2)
                        }
                        
                        // Step 1: Open Google AI Studio to get key
                        Button(action: {
                            showingSafari = true
                        }) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 36, height: 36)
                                    Image(systemName: "safari.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Lấy Key miễn phí từ Google (1 chạm)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("Đăng nhập tài khoản Google -> Bấm Get API key")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.85))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.right.square.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(colors: [Color(hex: "#2563EB"), Color(hex: "#1D4ED8")], startPoint: .leading, endPoint: .trailing))
                            )
                            .shadow(color: Color(hex: "#2563EB").opacity(0.25), radius: 6, x: 0, y: 3)
                        }
                        
                        // Step 2: API Key Input Box
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Dán Gemini API Key của bạn:")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppTheme.primary)
                                Spacer()
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "key.fill")
                                    .foregroundColor(AppTheme.accentOrange)
                                
                                TextField("Dán Key bắt đầu bằng AIzaSy...", text: $geminiApiKeyInput)
                                    .font(.system(size: 13, design: .monospaced))
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled(true)
                                
                                Button(action: {
                                    if let clip = UIPasteboard.general.string {
                                        geminiApiKeyInput = clip.trimmingCharacters(in: .whitespacesAndNewlines)
                                    }
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "doc.on.clipboard")
                                        Text("Dán")
                                    }
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Capsule().fill(Color(hex: "#E5E7EB")))
                                    .foregroundColor(Color(hex: "#1F2937"))
                                }
                            }
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 16).fill(AppTheme.secondaryBg))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#E5E7EB"), lineWidth: 1))
                        }
                        
                        // Status Message
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
                        
                        // Primary Action Button: Log In
                        Button(action: {
                            performLogin()
                        }) {
                            HStack {
                                Spacer()
                                if isConnecting {
                                    ProgressView().tint(.white)
                                } else {
                                    Image(systemName: "arrow.right.circle.fill")
                                    Text("Đăng Nhập & Bắt Đầu Học")
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
                            .shadow(color: AppTheme.primaryMint.opacity(0.35), radius: 8, x: 0, y: 4)
                        }
                        .disabled(geminiApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isConnecting)
                        
                        // Secondary Guest Button
                        Button(action: {
                            enterGuestMode()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "person.crop.circle.badge.questionmark")
                                    .foregroundColor(AppTheme.textSecondary)
                                Text("Dùng thử ngay (Chế độ Khách)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                        }
                        
                        // Helpful Note Box
                        VStack(alignment: .leading, spacing: 5) {
                            Text("💡 Hoàn toàn miễn phí & Tiện lợi:")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.primary)
                            Text("• Không cần mở máy tính chạy server.\n• 1.500 câu hỏi/ngày từ Google, phản hồi siêu tốc dưới 1 giây.\n• Dùng được mọi lúc trên 4G, 5G hay Wi-Fi trường học.")
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
        .sheet(isPresented: $showingSafari) {
            if let url = URL(string: "https://aistudio.google.com/app/apikey") {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            if !appState.geminiApiKey.isEmpty {
                geminiApiKeyInput = appState.geminiApiKey
            }
        }
    }
    
    private func performLogin() {
        let cleanKey = geminiApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanKey.isEmpty else { return }
        
        isConnecting = true
        connectionMessage = "Đang kiểm tra kết nối tới Google Gemini..."
        isConnectionSuccess = nil
        
        GeminiAIService.shared.checkConnection(serverUrl: "", geminiApiKey: cleanKey) { success, msg in
            isConnecting = false
            isConnectionSuccess = success
            connectionMessage = msg
            
            if success {
                appState.login(
                    username: "Học Sinh Shimy",
                    token: "",
                    role: "student",
                    remainingQuota: 9999,
                    geminiKey: cleanKey
                )
            }
        }
    }
    
    private func enterGuestMode() {
        appState.login(
            username: "Khách",
            token: "",
            role: "guest",
            remainingQuota: 150,
            geminiKey: geminiApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
}
