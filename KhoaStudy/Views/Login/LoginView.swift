import SwiftUI
import SafariServices

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    // Mandatory Student Name Input
    @State private var studentNameInput: String = ""
    
    // Active AI Provider selection on Login
    @State private var selectedProvider: AIProvider = .groq
    
    // Groq configuration inputs
    @State private var groqApiKeyInput: String = ""
    @State private var selectedGroqModel: String = "openai/gpt-oss-120b"
    
    // Gemini configuration inputs
    @State private var geminiApiKeyInput: String = ""
    
    // Feedback and Safari states
    @State private var connectionMessage: String = ""
    @State private var isConnecting: Bool = false
    @State private var isConnectionSuccess: Bool? = nil
    
    @State private var showingSafari: Bool = false
    @State private var safariTargetUrl: URL = URL(string: "https://console.groq.com/keys")!
    
    // Default built-in Groq key for instant trial
    private var defaultGroqApiKey: String {
        let b: [UInt8] = [61, 41, 49, 5, 98, 13, 52, 106, 27, 31, 15, 59, 46, 61, 56, 3, 61, 3, 50, 44, 31, 49, 31, 47, 13, 29, 62, 35, 56, 105, 28, 3, 18, 10, 60, 61, 16, 111, 108, 27, 47, 19, 30, 21, 99, 17, 99, 3, 32, 14, 108, 46, 21, 111, 2, 60]
        let restored = b.map { $0 ^ 0x5A }
        return String(bytes: restored, encoding: .utf8) ?? ""
    }
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Spacer(minLength: 20)
                    
                    // App Logo & Header
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primaryDark], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 76, height: 76)
                                .shadow(color: AppTheme.primaryMint.opacity(0.35), radius: 12, x: 0, y: 6)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 34))
                                .foregroundColor(.white)
                        }
                        
                        Text("Shimy")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.primaryDark)
                        
                        Text("Gia sư AI học tập thông minh & Luyện thi K-12")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    // Main Modern Login Card (Phẳng, gọn gàng, KHÔNG khung lồng khung)
                    VStack(alignment: .leading, spacing: 16) {
                        // 1. Tên Học Sinh (BẮT BUỘC)
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 4) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.primaryMint)
                                Text("Tên Học Sinh (Bắt buộc)")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(hex: "#1F2937"))
                            }
                            
                            TextField("Nhập họ và tên của bạn...", text: $studentNameInput)
                                .font(.system(size: 14))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                                .background(Color(hex: "#F9FAFB"))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        
                        // 2. AI Provider Selection Tabs
                        VStack(alignment: .leading, spacing: 6) {
                            Text("DỊCH VỤ AI:")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            HStack(spacing: 8) {
                                Button(action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedProvider = .groq
                                        connectionMessage = ""
                                        isConnectionSuccess = nil
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "bolt.fill")
                                            .font(.system(size: 12))
                                        Text("Groq Cloud")
                                            .font(.system(size: 13, weight: .bold))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(selectedProvider == .groq ?
                                                  LinearGradient(colors: [Color(hex: "#F97316"), Color(hex: "#EA580C")], startPoint: .leading, endPoint: .trailing) :
                                                  LinearGradient(colors: [Color(hex: "#F3F4F6"), Color(hex: "#F3F4F6")], startPoint: .leading, endPoint: .trailing))
                                    )
                                    .foregroundColor(selectedProvider == .groq ? .white : Color(hex: "#4B5563"))
                                }
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedProvider = .gemini
                                        connectionMessage = ""
                                        isConnectionSuccess = nil
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 12))
                                        Text("Google Gemini")
                                            .font(.system(size: 13, weight: .bold))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(selectedProvider == .gemini ?
                                                  LinearGradient(colors: [Color(hex: "#2563EB"), Color(hex: "#1D4ED8")], startPoint: .leading, endPoint: .trailing) :
                                                  LinearGradient(colors: [Color(hex: "#F3F4F6"), Color(hex: "#F3F4F6")], startPoint: .leading, endPoint: .trailing))
                                    )
                                    .foregroundColor(selectedProvider == .gemini ? .white : Color(hex: "#4B5563"))
                                }
                            }
                        }
                        
                        // 3. Nút Lấy Key Miễn Phí (Đơn giản, đúng yêu cầu)
                        Button(action: {
                            safariTargetUrl = (selectedProvider == .groq) ?
                                URL(string: "https://console.groq.com/keys")! :
                                URL(string: "https://aistudio.google.com/app/apikey")!
                            showingSafari = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "key.fill")
                                    .font(.system(size: 12))
                                Text("Lấy key miễn phí Groq / Gemini")
                                    .font(.system(size: 13, weight: .bold))
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 10, weight: .bold))
                            }
                            .foregroundColor(selectedProvider == .groq ? Color(hex: "#EA580C") : Color(hex: "#2563EB"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 11)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(selectedProvider == .groq ? Color(hex: "#FFF7ED") : Color(hex: "#EFF6FF"))
                            )
                        }
                        
                        // 4. Model selection (cho Groq)
                        if selectedProvider == .groq {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Model Groq:")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                Menu {
                                    ForEach(GroqModel.allCases) { model in
                                        Button(action: {
                                            selectedGroqModel = model.rawValue
                                        }) {
                                            HStack {
                                                Text(model.displayName)
                                                if selectedGroqModel == model.rawValue {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "cpu")
                                            .foregroundColor(Color(hex: "#EA580C"))
                                        Text(GroqModel(rawValue: selectedGroqModel)?.displayName ?? selectedGroqModel)
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(Color(hex: "#111827"))
                                        Spacer()
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.caption)
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 11)
                                    .background(Color(hex: "#F9FAFB"))
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                }
                            }
                        }
                        
                        // 5. Input API Key
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Dán API Key:")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.textSecondary)
                            
                            HStack(spacing: 8) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color(hex: "#9CA3AF"))
                                    .font(.system(size: 12))
                                
                                if selectedProvider == .groq {
                                    TextField("Dán Key bắt đầu bằng gsk_...", text: $groqApiKeyInput)
                                        .font(.system(size: 13, design: .monospaced))
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled(true)
                                } else {
                                    TextField("Dán Key bắt đầu bằng AIzaSy...", text: $geminiApiKeyInput)
                                        .font(.system(size: 13, design: .monospaced))
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled(true)
                                }
                                
                                Button(action: {
                                    if let clip = UIPasteboard.general.string {
                                        let cleanClip = clip.trimmingCharacters(in: .whitespacesAndNewlines)
                                        if selectedProvider == .groq {
                                            groqApiKeyInput = cleanClip
                                        } else {
                                            geminiApiKeyInput = cleanClip
                                        }
                                    }
                                }) {
                                    Text("Dán")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Capsule().fill(Color(hex: "#E5E7EB")))
                                        .foregroundColor(Color(hex: "#1F2937"))
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 11)
                            .background(Color(hex: "#F9FAFB"))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
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
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
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
                                    Text(selectedProvider == .groq ? "Đăng Nhập Với Groq" : "Đăng Nhập Với Gemini")
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                }
                                Spacer()
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(selectedProvider == .groq ?
                                          LinearGradient(colors: [Color(hex: "#F97316"), Color(hex: "#EA580C")], startPoint: .leading, endPoint: .trailing) :
                                          LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primary], startPoint: .leading, endPoint: .trailing))
                            )
                            .shadow(color: (selectedProvider == .groq ? Color(hex: "#F97316") : AppTheme.primaryMint).opacity(0.3), radius: 6, x: 0, y: 3)
                        }
                        .disabled(isLoginDisabled || isConnecting)
                        .opacity(isLoginDisabled ? 0.6 : 1.0)
                        
                        // Secondary Guest Button: Dùng thử ngay với API mặc định Groq tích hợp sẵn
                        Button(action: {
                            enterGuestMode()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "bolt.badge.clock.fill")
                                    .foregroundColor(Color(hex: "#EA580C"))
                                    .font(.system(size: 13))
                                Text("Dùng thử ngay (API Groq tích hợp sẵn)")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Color(hex: "#EA580C"))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color(hex: "#FFF7ED"))
                            )
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 3)
                    )
                    
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
            SafariView(url: safariTargetUrl)
                .ignoresSafeArea()
        }
        .onAppear {
            selectedProvider = appState.selectedProvider
            groqApiKeyInput = appState.groqApiKey
            selectedGroqModel = appState.selectedGroqModel
            geminiApiKeyInput = appState.geminiApiKey
            if !appState.currentUser.username.isEmpty && appState.currentUser.username != "Khách" && appState.currentUser.username != "Học Sinh Khách" {
                studentNameInput = appState.currentUser.username
            }
        }
    }
    
    private var isLoginDisabled: Bool {
        let cleanName = studentNameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return true }
        
        if selectedProvider == .groq {
            return groqApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } else {
            return geminiApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    private func performLogin() {
        let cleanName = studentNameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return }
        
        if selectedProvider == .groq {
            let cleanKey = groqApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !cleanKey.isEmpty else { return }
            
            isConnecting = true
            connectionMessage = "Đang kiểm tra kết nối tới Groq Cloud..."
            isConnectionSuccess = nil
            
            GeminiAIService.shared.checkGroqConnection(apiKey: cleanKey) { success, msg in
                isConnecting = false
                isConnectionSuccess = success
                connectionMessage = msg
                
                if success {
                    appState.login(
                        username: cleanName,
                        token: "",
                        role: "student",
                        remainingQuota: 9999,
                        provider: .groq,
                        geminiKey: geminiApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines),
                        groqKey: cleanKey,
                        groqModel: selectedGroqModel
                    )
                }
            }
        } else {
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
                        username: cleanName,
                        token: "",
                        role: "student",
                        remainingQuota: 9999,
                        provider: .gemini,
                        geminiKey: cleanKey,
                        groqKey: groqApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines),
                        groqModel: selectedGroqModel
                    )
                }
            }
        }
    }
    
    private func enterGuestMode() {
        let cleanName = studentNameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalName = cleanName.isEmpty ? "Học Sinh Khách" : cleanName
        
        // Dùng API mặc định groq tích hợp sẵn
        appState.login(
            username: finalName,
            token: "",
            role: "student",
            remainingQuota: 9999,
            provider: .groq,
            geminiKey: geminiApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines),
            groqKey: defaultGroqApiKey,
            groqModel: "llama-3.3-70b-versatile"
        )
    }
}
