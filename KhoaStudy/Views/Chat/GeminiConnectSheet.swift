import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        config.barCollapsingEnabled = true
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.dismissButtonStyle = .close
        return vc
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

struct GeminiConnectSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    @State private var activeTab: AIProvider = .groq
    
    // Groq fields
    @State private var inputGroqKey: String = ""
    @State private var selectedGroqModel: String = "openai/gpt-oss-120b"
    
    // Gemini fields
    @State private var inputGeminiKey: String = ""
    
    // Feedback & state
    @State private var isTesting: Bool = false
    @State private var statusMessage: String = ""
    @State private var isSuccess: Bool? = nil
    
    @State private var showingSafari: Bool = false
    @State private var safariUrl: URL = URL(string: "https://console.groq.com/keys")!
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    // Header Illustration
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    colors: activeTab == .groq ? [Color(hex: "#F97316"), Color(hex: "#EA580C")] : [Color(hex: "#10A37F"), Color(hex: "#059669")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 68, height: 68)
                                .shadow(color: (activeTab == .groq ? Color(hex: "#F97316") : Color(hex: "#10A37F")).opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: activeTab == .groq ? "bolt.fill" : "sparkles")
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        Text("Cài Đặt & Chuyển Đổi AI")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        
                        Text("Linh hoạt chuyển đổi giữa Groq Cloud siêu tốc và Google Gemini chính hãng.")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .padding(.top, 6)
                    
                    // Switcher Tabs
                    HStack(spacing: 8) {
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                activeTab = .groq
                                statusMessage = ""
                                isSuccess = nil
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "bolt.fill")
                                Text("Groq Cloud")
                                    .fontWeight(.bold)
                            }
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(activeTab == .groq ? Color(hex: "#F97316") : Color(hex: "#F3F4F6"))
                            )
                            .foregroundColor(activeTab == .groq ? .white : Color(hex: "#4B5563"))
                        }
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                activeTab = .gemini
                                statusMessage = ""
                                isSuccess = nil
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "sparkles")
                                Text("Google Gemini")
                                    .fontWeight(.bold)
                            }
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(activeTab == .gemini ? Color(hex: "#2563EB") : Color(hex: "#F3F4F6"))
                            )
                            .foregroundColor(activeTab == .gemini ? .white : Color(hex: "#4B5563"))
                        }
                    }
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color(hex: "#F3F4F6")))
                    
                    if activeTab == .groq {
                        groqConfigView
                    } else {
                        geminiConfigView
                    }
                    
                    // Status feedback
                    if !statusMessage.isEmpty {
                        HStack(spacing: 8) {
                            Image(systemName: (isSuccess == true) ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                                .foregroundColor((isSuccess == true) ? .green : .red)
                            Text(statusMessage)
                                .font(.caption)
                                .foregroundColor(Color(hex: "#111827"))
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill((isSuccess == true) ? Color.green.opacity(0.12) : Color.red.opacity(0.12))
                        )
                    }
                    
                    // Save Button
                    Button(action: {
                        saveAndActivate()
                    }) {
                        HStack {
                            Spacer()
                            if isTesting {
                                ProgressView().tint(.white)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Lưu & Kích Hoạt \(activeTab.shortName)")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(activeTab == .groq ?
                                      LinearGradient(colors: [Color(hex: "#F97316"), Color(hex: "#EA580C")], startPoint: .leading, endPoint: .trailing) :
                                      LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primaryDark], startPoint: .leading, endPoint: .trailing))
                        )
                        .shadow(color: (activeTab == .groq ? Color(hex: "#F97316") : AppTheme.primaryMint).opacity(0.35), radius: 8, x: 0, y: 4)
                    }
                    .disabled(isSaveDisabled || isTesting)
                    
                    // Info Comparison
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Gợi ý chọn dịch vụ AI:")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.primary)
                        Text("• Chọn Groq Cloud: Nếu bạn muốn phản hồi tức thì dưới 0.5s và không bao giờ bị báo lỗi quá tải hay giới hạn tần suất.\n• Chọn Gemini: Nếu bạn muốn giải các bài toán có hình ảnh phức tạp hoặc cần đối chiếu sách giáo khoa mới nhất.")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                            .lineSpacing(3)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 14).fill(AppTheme.primaryLight))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }
            .navigationTitle("Cài Đặt Dịch Vụ AI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
            }
            .sheet(isPresented: $showingSafari) {
                SafariView(url: safariUrl)
                    .ignoresSafeArea()
            }
            .onAppear {
                activeTab = appState.selectedProvider
                inputGroqKey = appState.groqApiKey
                selectedGroqModel = appState.selectedGroqModel
                inputGeminiKey = appState.geminiApiKey
            }
        }
    }
    
    // MARK: - Groq Config View
    private var groqConfigView: some View {
        VStack(spacing: 14) {
            // Step 1: Open Groq Console
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("BƯỚC 1: LẤY KEY MIỄN PHÍ TỪ GROQ")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#EA580C"))
                    Spacer()
                    Text("Tức thì")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.orange.opacity(0.15)))
                        .foregroundColor(.orange)
                }
                
                Button(action: {
                    safariUrl = URL(string: "https://console.groq.com/keys")!
                    showingSafari = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "safari.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Mở Groq Console để lấy Key")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            Text("Đăng nhập -> Bấm Create API Key -> Sao chép")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.85))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right.square.fill")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(LinearGradient(colors: [Color(hex: "#F97316"), Color(hex: "#EA580C")], startPoint: .leading, endPoint: .trailing))
                    )
                }
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(hex: "#FFF7ED")))
            
            // Step 2: Choose Groq Model
            VStack(alignment: .leading, spacing: 6) {
                Text("BƯỚC 2: CHỌN MODEL GROQ MIỄN PHÍ")
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
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#E5E7EB"), lineWidth: 1))
                }
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(hex: "#F9FAFB")))
            
            // Step 3: Paste Groq Key
            VStack(alignment: .leading, spacing: 8) {
                Text("BƯỚC 3: DÁN GROQ API KEY VÀO ĐÂY")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.primary)
                
                HStack {
                    Image(systemName: "key.fill")
                        .foregroundColor(Color(hex: "#EA580C"))
                    
                    TextField("Dán Key bắt đầu bằng gsk_...", text: $inputGroqKey)
                        .font(.system(size: 13, design: .monospaced))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    Button(action: {
                        if let clip = UIPasteboard.general.string {
                            inputGroqKey = clip.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.on.clipboard")
                            Text("Dán")
                        }
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color(hex: "#E5E7EB")))
                        .foregroundColor(Color(hex: "#1F2937"))
                    }
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#E5E7EB"), lineWidth: 1))
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(hex: "#F9FAFB")))
        }
    }
    
    // MARK: - Gemini Config View
    private var geminiConfigView: some View {
        VStack(spacing: 14) {
            // Step 1: Open Google AI Studio
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("BƯỚC 1: LẤY KEY MIỄN PHÍ TỪ GOOGLE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2563EB"))
                    Spacer()
                    Text("1 chạm")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.green.opacity(0.15)))
                        .foregroundColor(.green)
                }
                
                Button(action: {
                    safariUrl = URL(string: "https://aistudio.google.com/app/apikey")!
                    showingSafari = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "safari.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Mở Google AI Studio để lấy Key")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            Text("Đăng nhập tài khoản Google -> Bấm Get API key")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.85))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right.square.fill")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(LinearGradient(colors: [Color(hex: "#2563EB"), Color(hex: "#1D4ED8")], startPoint: .leading, endPoint: .trailing))
                    )
                }
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(hex: "#EFF6FF")))
            
            // Step 2: Paste Gemini Key
            VStack(alignment: .leading, spacing: 8) {
                Text("BƯỚC 2: DÁN GEMINI API KEY VÀO ĐÂY")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.primary)
                
                HStack {
                    Image(systemName: "key.fill")
                        .foregroundColor(AppTheme.accentOrange)
                    
                    TextField("Dán Key bắt đầu bằng AIzaSy...", text: $inputGeminiKey)
                        .font(.system(size: 13, design: .monospaced))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    Button(action: {
                        if let clip = UIPasteboard.general.string {
                            inputGeminiKey = clip.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.on.clipboard")
                            Text("Dán")
                        }
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color(hex: "#E5E7EB")))
                        .foregroundColor(Color(hex: "#1F2937"))
                    }
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#E5E7EB"), lineWidth: 1))
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(hex: "#F9FAFB")))
        }
    }
    
    private var isSaveDisabled: Bool {
        if activeTab == .groq {
            return inputGroqKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } else {
            return inputGeminiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    private func saveAndActivate() {
        if activeTab == .groq {
            let cleanKey = inputGroqKey.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !cleanKey.isEmpty else { return }
            
            isTesting = true
            statusMessage = "Đang kiểm tra kết nối tới Groq Cloud LPU..."
            isSuccess = nil
            
            GeminiAIService.shared.checkGroqConnection(apiKey: cleanKey) { success, msg in
                isTesting = false
                isSuccess = success
                statusMessage = msg
                
                if success {
                    appState.selectedProvider = .groq
                    appState.groqApiKey = cleanKey
                    appState.selectedGroqModel = selectedGroqModel
                    appState.isAIConnected = true
                    
                    UserDefaults.standard.set("Groq", forKey: "shimy_ai_provider")
                    UserDefaults.standard.set(cleanKey, forKey: "shimy_groq_key")
                    UserDefaults.standard.set(selectedGroqModel, forKey: "shimy_groq_model")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        dismiss()
                    }
                }
            }
        } else {
            let cleanKey = inputGeminiKey.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !cleanKey.isEmpty else { return }
            
            isTesting = true
            statusMessage = "Đang kiểm tra kết nối tới Google Gemini Cloud..."
            isSuccess = nil
            
            GeminiAIService.shared.checkConnection(serverUrl: "", geminiApiKey: cleanKey) { success, msg in
                isTesting = false
                isSuccess = success
                statusMessage = msg
                
                if success {
                    appState.selectedProvider = .gemini
                    appState.geminiApiKey = cleanKey
                    appState.isAIConnected = true
                    
                    UserDefaults.standard.set("Gemini", forKey: "shimy_ai_provider")
                    UserDefaults.standard.set(cleanKey, forKey: "shimy_gemini_key")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        dismiss()
                    }
                }
            }
        }
    }
}
