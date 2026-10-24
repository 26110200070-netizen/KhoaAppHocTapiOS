import SwiftUI
import SafariServices

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    // Active AI Provider selection on Login
    @State private var selectedProvider: AIProvider = .groq
    
    // Groq configuration inputs
    @State private var groqApiKeyInput: String = ""
    @State private var selectedGroqModel: String = "llama-3.3-70b-versatile"
    
    // Gemini configuration inputs
    @State private var geminiApiKeyInput: String = ""
    
    // Feedback and Safari states
    @State private var connectionMessage: String = ""
    @State private var isConnecting: Bool = false
    @State private var isConnectionSuccess: Bool? = nil
    
    @State private var showingSafari: Bool = false
    @State private var safariTargetUrl: URL = URL(string: "https://console.groq.com/keys")!
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Spacer(minLength: 20)
                    
                    // App Logo & Header
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primaryDark], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 82, height: 82)
                                .shadow(color: AppTheme.primaryMint.opacity(0.35), radius: 14, x: 0, y: 7)
                            
                            Image(systemName: "sparkles")
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
                    
                    // Main Login Card
                    VStack(alignment: .leading, spacing: 18) {
                        // AI Provider Selection Tabs
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CHỌN DỊCH VỤ AI:")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(AppTheme.textSecondary)
                            
                            HStack(spacing: 8) {
                                // Groq Tab
                                Button(action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedProvider = .groq
                                        connectionMessage = ""
                                        isConnectionSuccess = nil
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "bolt.fill")
                                            .font(.system(size: 13))
                                        VStack(alignment: .leading, spacing: 1) {
                                            Text("Groq Cloud")
                                                .font(.system(size: 13, weight: .bold))
                                            Text("Siêu tốc • Không nghẽn")
                                                .font(.system(size: 9))
                                                .opacity(0.85)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedProvider == .groq ?
                                                  LinearGradient(colors: [Color(hex: "#F97316"), Color(hex: "#EA580C")], startPoint: .leading, endPoint: .trailing) :
                                                  LinearGradient(colors: [Color(hex: "#F3F4F6"), Color(hex: "#F3F4F6")], startPoint: .leading, endPoint: .trailing))
                                    )
                                    .foregroundColor(selectedProvider == .groq ? .white : Color(hex: "#4B5563"))
                                }
                                
                                // Gemini Tab
                                Button(action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedProvider = .gemini
                                        connectionMessage = ""
                                        isConnectionSuccess = nil
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 13))
                                        VStack(alignment: .leading, spacing: 1) {
                                            Text("Google Gemini")
                                                .font(.system(size: 13, weight: .bold))
                                            Text("Chính hãng Google")
                                                .font(.system(size: 9))
                                                .opacity(0.85)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedProvider == .gemini ?
                                                  LinearGradient(colors: [Color(hex: "#2563EB"), Color(hex: "#1D4ED8")], startPoint: .leading, endPoint: .trailing) :
                                                  LinearGradient(colors: [Color(hex: "#F3F4F6"), Color(hex: "#F3F4F6")], startPoint: .leading, endPoint: .trailing))
                                    )
                                    .foregroundColor(selectedProvider == .gemini ? .white : Color(hex: "#4B5563"))
                                }
                            }
                        }
                        
                        Divider()
                        
                        if selectedProvider == .groq {
                            groqLoginSection
                        } else {
                            geminiLoginSection
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
                                    Text(selectedProvider == .groq ? "Đăng Nhập Với Groq" : "Đăng Nhập Với Gemini")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                }
                                Spacer()
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedProvider == .groq ?
                                          LinearGradient(colors: [Color(hex: "#F97316"), Color(hex: "#EA580C")], startPoint: .leading, endPoint: .trailing) :
                                          LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primary], startPoint: .leading, endPoint: .trailing))
                            )
                            .shadow(color: (selectedProvider == .groq ? Color(hex: "#F97316") : AppTheme.primaryMint).opacity(0.35), radius: 8, x: 0, y: 4)
                        }
                        .disabled(isLoginDisabled || isConnecting)
                        
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
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(Color(hex: "#D97706"))
                                Text("Giải pháp cho lỗi giới hạn tần suất (Rate Limit):")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "#92400E"))
                            }
                            Text("• Google Gemini Free giới hạn 15 câu/phút, vào giờ cao điểm rất dễ bị tạm ngừng phản hồi.\n• Groq Cloud chạy trên chip phần cứng LPU: tốc độ 500-800 từ/giây, hạn mức 14.400 câu/ngày, hoàn toàn không lo bị nghẽn tần suất!\n• Bạn có thể đổi qua lại giữa Groq và Gemini bất cứ lúc nào.")
                                .font(.caption2)
                                .foregroundColor(Color(hex: "#78350F"))
                                .lineSpacing(3)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(hex: "#FEF3C7"))
                        )
                    }
                    .cleanCard(cornerRadius: 24, padding: 20)
                    
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
        }
    }
    
    // MARK: - Groq Login Section
    private var groqLoginSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Đăng Nhập Groq Cloud")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                Text("Tốc độ siêu nhanh, không lo quá tải, miễn phí 100%.")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            // Step 1: Open Groq Console Button
            Button(action: {
                safariTargetUrl = URL(string: "https://console.groq.com/keys")!
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
                        Text("Lấy Key miễn phí từ Groq (1 chạm)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        Text("Đăng nhập -> Bấm Create API Key -> Dán vào app")
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
                        .fill(LinearGradient(colors: [Color(hex: "#F97316"), Color(hex: "#C2410C")], startPoint: .leading, endPoint: .trailing))
                )
                .shadow(color: Color(hex: "#F97316").opacity(0.25), radius: 6, x: 0, y: 3)
            }
            
            // Step 2: Groq Model Picker
            VStack(alignment: .leading, spacing: 6) {
                Text("Chọn Model Groq miễn phí:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.primary)
                
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
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 14).fill(AppTheme.secondaryBg))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#E5E7EB"), lineWidth: 1))
                }
                
                if let modelObj = GroqModel(rawValue: selectedGroqModel) {
                    Text(modelObj.description)
                        .font(.caption2)
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            
            // Step 3: API Key Input Box
            VStack(alignment: .leading, spacing: 6) {
                Text("Dán Groq API Key của bạn:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.primary)
                
                HStack(spacing: 8) {
                    Image(systemName: "key.fill")
                        .foregroundColor(Color(hex: "#EA580C"))
                    
                    TextField("Dán Key bắt đầu bằng gsk_...", text: $groqApiKeyInput)
                        .font(.system(size: 13, design: .monospaced))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    Button(action: {
                        if let clip = UIPasteboard.general.string {
                            groqApiKeyInput = clip.trimmingCharacters(in: .whitespacesAndNewlines)
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
        }
    }
    
    // MARK: - Gemini Login Section
    private var geminiLoginSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Đăng Nhập Google Gemini")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                Text("Trí tuệ học tập thế hệ mới từ chính Google.")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            // Step 1: Open Google AI Studio to get key
            Button(action: {
                safariTargetUrl = URL(string: "https://aistudio.google.com/app/apikey")!
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
                        Text("Đăng nhập Google -> Bấm Get API key -> Dán vào app")
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
            
            // Step 2: Gemini API Key Input Box
            VStack(alignment: .leading, spacing: 6) {
                Text("Dán Gemini API Key của bạn:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.primary)
                
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
        }
    }
    
    private var isLoginDisabled: Bool {
        if selectedProvider == .groq {
            return groqApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } else {
            return geminiApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    private func performLogin() {
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
                        username: "Học Sinh Shimy",
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
                        username: "Học Sinh Shimy",
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
        appState.login(
            username: "Khách",
            token: "",
            role: "guest",
            remainingQuota: 150,
            provider: selectedProvider,
            geminiKey: geminiApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines),
            groqKey: groqApiKeyInput.trimmingCharacters(in: .whitespacesAndNewlines),
            groqModel: selectedGroqModel
        )
    }
}
