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
    
    @State private var inputApiKey: String = ""
    @State private var isTesting: Bool = false
    @State private var statusMessage: String = ""
    @State private var isSuccess: Bool? = nil
    @State private var showingSafari: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header Illustration
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color(hex: "#10A37F"), Color(hex: "#059669")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 72, height: 72)
                                .shadow(color: Color(hex: "#10A37F").opacity(0.3), radius: 12, x: 0, y: 6)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        Text("Kết Nối Google Gemini")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        
                        Text("Chat AI học tập trực tiếp từ tài khoản Google của bạn. Miễn phí 100%, không cần mở máy tính hay chạy server!")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .padding(.top, 10)
                    
                    // Step 1: Open Google AI Studio button
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("BƯỚC 1: LẤY KEY MIỄN PHÍ TỪ GOOGLE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.primary)
                            Spacer()
                            Text("1 chạm")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(Color.green.opacity(0.15)))
                                .foregroundColor(.green)
                        }
                        
                        Button(action: {
                            showingSafari = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "safari.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Mở Google AI Studio để lấy Key")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("Đăng nhập tài khoản Google của bạn -> Bấm Get API key")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.85))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.right.square.fill")
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(colors: [Color(hex: "#2563EB"), Color(hex: "#1D4ED8")], startPoint: .leading, endPoint: .trailing))
                            )
                            .shadow(color: Color(hex: "#2563EB").opacity(0.3), radius: 6, x: 0, y: 3)
                        }
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 18).fill(Color(hex: "#F9FAFB")))
                    
                    // Step 2: Paste API Key
                    VStack(alignment: .leading, spacing: 10) {
                        Text("BƯỚC 2: DÁN GEMINI API KEY VÀO ĐÂY")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.primary)
                        
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundColor(AppTheme.accentOrange)
                            
                            TextField("Dán Key bắt đầu bằng AIzaSy...", text: $inputApiKey)
                                .font(.system(size: 14, design: .monospaced))
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                            
                            Button(action: {
                                if let clip = UIPasteboard.general.string {
                                    inputApiKey = clip.trimmingCharacters(in: .whitespacesAndNewlines)
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
                        .padding(14)
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#E5E7EB"), lineWidth: 1))
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 18).fill(Color(hex: "#F9FAFB")))
                    
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
                        saveAndActivateKey()
                    }) {
                        HStack {
                            Spacer()
                            if isTesting {
                                ProgressView().tint(.white)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Lưu & Kích Hoạt Chat Ngay")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primaryDark], startPoint: .leading, endPoint: .trailing))
                        )
                        .shadow(color: AppTheme.primaryMint.opacity(0.35), radius: 8, x: 0, y: 4)
                    }
                    .disabled(inputApiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isTesting)
                    
                    // Why Google AI Studio note
                    VStack(alignment: .leading, spacing: 6) {
                        Text("💡 Vì sao nên dùng Google Gemini trực tiếp:")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.primary)
                        Text("• Không cần bật máy tính hay mở file chạy server.\n• Sử dụng được ở mọi nơi bằng 4G, 5G hay Wi-Fi trường học.\n• Hoàn toàn miễn phí 1.500 câu hỏi/ngày từ Google, tốc độ phản hồi cực nhanh dưới 1 giây!")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                            .lineSpacing(3)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 14).fill(AppTheme.primaryLight))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Cài Đặt Gemini")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
            }
            .sheet(isPresented: $showingSafari) {
                if let url = URL(string: "https://aistudio.google.com/app/apikey") {
                    SafariView(url: url)
                        .ignoresSafeArea()
                }
            }
            .onAppear {
                inputApiKey = appState.geminiApiKey
            }
        }
    }
    
    private func saveAndActivateKey() {
        let cleanKey = inputApiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanKey.isEmpty else { return }
        
        isTesting = true
        statusMessage = "Đang kiểm tra kết nối tới Google Gemini Cloud..."
        isSuccess = nil
        
        GeminiAIService.shared.checkConnection(serverUrl: "", geminiApiKey: cleanKey) { success, msg in
            isTesting = false
            isSuccess = success
            statusMessage = msg
            
            if success {
                appState.geminiApiKey = cleanKey
                appState.isGeminiConnected = true
                UserDefaults.standard.set(cleanKey, forKey: "shimy_gemini_key")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    dismiss()
                }
            }
        }
    }
}
