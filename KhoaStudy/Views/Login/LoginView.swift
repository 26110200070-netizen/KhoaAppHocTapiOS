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
                    
                    // App Logo & Header (Crisp, engineering-grade)
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "#059669"), Color(hex: "#047857")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 58, height: 58)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 26))
                                .foregroundColor(.white)
                        }
                        
                        Text("Shimy")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        
                        Text("Gia sư AI học tập thông minh & Luyện thi K-12")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#6B7280"))
                    }
                    .padding(.top, 6)
                    
                    // Main Modern Login Surface (Single-layer, 1px border, NO nested boxes)
                    VStack(alignment: .leading, spacing: 16) {
                        // Section Header
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color(hex: "#059669"))
                                .frame(width: 6, height: 6)
                            Text("ĐĂNG NHẬP HỆ THỐNG")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(hex: "#059669"))
                                .tracking(0.6)
                        }
                        
                        // 1. Tên Học Sinh
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Tên Học Sinh")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "#111827"))
                            
                            TextField("Nhập họ và tên của bạn...", text: $studentNameInput)
                                .font(.system(size: 14))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                                )
                        }
                        
                        // 2. Chọn Nhà Cung Cấp AI (Segmented Flat Switcher)
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Dịch Vụ AI")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Color(hex: "#111827"))
                                
                                Spacer()
                                
                                Button(action: {
                                    safariTargetUrl = (selectedProvider == .groq) ?
                                        URL(string: "https://console.groq.com/keys")! :
                                        URL(string: "https://aistudio.google.com/app/apikey")!
                                    showingSafari = true
                                }) {
                                    HStack(spacing: 3) {
                                        Text("Lấy API key")
                                        Image(systemName: "arrow.up.right")
                                            .font(.system(size: 9, weight: .bold))
                                    }
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(hex: "#059669"))
                                }
                                .buttonStyle(.plain)
                            }
                            
                            HStack(spacing: 8) {
                                Button(action: {
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                        selectedProvider = .groq
                                        connectionMessage = ""
                                        isConnectionSuccess = nil
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "bolt.fill")
                                            .font(.system(size: 11))
                                        Text("Groq Cloud (Siêu Tốc)")
                                            .font(.system(size: 12.5, weight: selectedProvider == .groq ? .bold : .medium))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(selectedProvider == .groq ? Color(hex: "#111827") : Color.white)
                                    .foregroundColor(selectedProvider == .groq ? .white : Color(hex: "#4B5563"))
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(Color(hex: selectedProvider == .groq ? "#111827" : "#E5E7EB"), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                        selectedProvider = .gemini
                                        connectionMessage = ""
                                        isConnectionSuccess = nil
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 11))
                                        Text("Google Gemini")
                                            .font(.system(size: 12.5, weight: selectedProvider == .gemini ? .bold : .medium))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(selectedProvider == .gemini ? Color(hex: "#111827") : Color.white)
                                    .foregroundColor(selectedProvider == .gemini ? .white : Color(hex: "#4B5563"))
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(Color(hex: selectedProvider == .gemini ? "#111827" : "#E5E7EB"), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        
                        // 3. Model selection (cho Groq)
                        if selectedProvider == .groq {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Model AI")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Color(hex: "#111827"))
                                
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
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(hex: "#059669"))
                                        Text(GroqModel(rawValue: selectedGroqModel)?.displayName ?? selectedGroqModel)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(Color(hex: "#111827"))
                                        Spacer()
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.system(size: 10))
                                            .foregroundColor(Color(hex: "#9CA3AF"))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        
                        // 4. Input API Key (Clean single border, no inner capsule)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("API Key")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "#111827"))
                            
                            HStack(spacing: 8) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color(hex: "#9CA3AF"))
                                    .font(.system(size: 12))
                                
                                if selectedProvider == .groq {
                                    TextField("gsk_...", text: $groqApiKeyInput)
                                        .font(.system(size: 13, design: .monospaced))
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled(true)
                                } else {
                                    TextField("AIzaSy...", text: $geminiApiKeyInput)
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
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Color(hex: "#059669"))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                            )
                        }
                        
                        // Status Message
                        if !connectionMessage.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: (isConnectionSuccess == true) ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                                    .foregroundColor((isConnectionSuccess == true) ? Color(hex: "#059669") : Color(hex: "#D97706"))
                                    .font(.system(size: 13))
                                Text(connectionMessage)
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "#111827"))
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke((isConnectionSuccess == true) ? Color(hex: "#10B981").opacity(0.4) : Color(hex: "#F59E0B").opacity(0.4), lineWidth: 1)
                            )
                        }
                        
                        // Primary Action Button: Log In
                        Button(action: {
                            performLogin()
                        }) {
                            HStack(spacing: 6) {
                                Spacer()
                                if isConnecting {
                                    ProgressView().tint(.white)
                                } else {
                                    Text(selectedProvider == .groq ? "Đăng Nhập Với Groq" : "Đăng Nhập Với Gemini")
                                        .font(.system(size: 14, weight: .bold))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 12, weight: .bold))
                                }
                                Spacer()
                            }
                            .foregroundColor(.white)
                            .frame(height: 44)
                            .background(Color(hex: "#059669"))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                        .disabled(isLoginDisabled || isConnecting)
                        .opacity(isLoginDisabled ? 0.5 : 1.0)
                        .buttonStyle(.plain)
                        
                        // Secondary Guest Button: Dùng thử ngay với API mặc định Groq tích hợp sẵn
                        Button(action: {
                            enterGuestMode()
                        }) {
                            HStack(spacing: 6) {
                                Spacer()
                                Image(systemName: "bolt.badge.clock.fill")
                                    .font(.system(size: 12))
                                Text("Dùng thử nhanh không cần API key")
                                    .font(.system(size: 13, weight: .semibold))
                                Spacer()
                            }
                            .foregroundColor(Color(hex: "#4B5563"))
                            .frame(height: 38)
                            .background(Color(hex: "#F3F4F6"))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(18)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                    )
                    
                    // Language Switcher (Flat segmented tabs)
                    HStack(spacing: 8) {
                        ForEach(AppLanguage.allCases, id: \.self) { lang in
                            let isSelected = (appState.currentLanguage == lang)
                            Button(action: {
                                withAnimation { appState.currentLanguage = lang }
                            }) {
                                HStack(spacing: 4) {
                                    Text(lang.flag)
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    Text(lang.rawValue)
                                        .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(isSelected ? Color(hex: "#111827") : Color.white)
                                .foregroundColor(isSelected ? .white : Color(hex: "#4B5563"))
                                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .stroke(Color(hex: isSelected ? "#111827" : "#E5E7EB"), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 4)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
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
            groqModel: "openai/gpt-oss-120b"
        )
    }
}
