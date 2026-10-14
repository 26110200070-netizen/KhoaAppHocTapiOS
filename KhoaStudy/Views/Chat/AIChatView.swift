import SwiftUI

struct AIChatView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    @State private var messages: [ChatMessage] = []
    @State private var inputPrompt: String = ""
    @State private var isThinking: Bool = false
    @State private var selectedModel: DeepSeekModel = .chat
    @State private var showingModelInfo: Bool = false
    
    var body: some View {
        ZStack {
            // Background Canvas with subtle watermark matching Screenshot 4
            Color.white.ignoresSafeArea()
            
            // Decorative subtle 4-point stars watermark (Screenshot 4 style)
            GeometryReader { geo in
                ZStack {
                    Image(systemName: "sparkle")
                        .font(.system(size: 260))
                        .foregroundColor(Color(hex: "#F8FAF9"))
                        .offset(x: geo.size.width * 0.35, y: geo.size.height * 0.15)
                    Image(systemName: "sparkle")
                        .font(.system(size: 180))
                        .foregroundColor(Color(hex: "#F8FAF9"))
                        .offset(x: -geo.size.width * 0.3, y: geo.size.height * 0.55)
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Custom Top Bar (Tammi Style - Screenshot 4)
                customTopNavBar
                
                Divider()
                    .opacity(0.4)
                
                // 2. Chat Conversation (NO boxed card, edge-to-edge flow)
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 16) {
                            if messages.isEmpty {
                                emptyStatePrompts
                                    .padding(.top, 40)
                            } else {
                                ForEach(messages) { msg in
                                    chatBubbleRow(msg: msg)
                                        .id(msg.id)
                                }
                            }
                            
                            if isThinking {
                                thinkingBubble
                                    .id("thinking_row")
                            }
                            
                            Spacer().frame(height: 20)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    }
                    .onChange(of: messages.count) { _ in
                        if let lastId = messages.last?.id {
                            withAnimation { proxy.scrollTo(lastId, anchor: .bottom) }
                        }
                    }
                    .onChange(of: isThinking) { thinking in
                        if thinking {
                            withAnimation { proxy.scrollTo("thinking_row", anchor: .bottom) }
                        }
                    }
                }
                
                // 3. Bottom Chat Input Bar (Exact Replica of Screenshot 4)
                bottomChatInputBar
            }
        }
        .navigationBarHidden(true)
        .alert("Thông tin mô hình DeepSeek", isPresented: $showingModelInfo) {
            Button("Đóng", role: .cancel) {}
        } message: {
            Text("Đang kết nối: \(appState.deepSeekServerUrl)\nModel đang chọn: \(selectedModel.displayName)\nServer được cấp phiên từ tài khoản Google của bạn!")
        }
    }
    
    // MARK: - 1. Custom Top Bar (Tammi Style - Screenshot 4)
    private var customTopNavBar: some View {
        HStack(spacing: 12) {
            // Circular Back Button
            Button(action: { dismiss() }) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#1F2937"))
                        .frame(width: 36, height: 36)
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            // Avatar Circle
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primaryDark], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 44, height: 44)
                Image(systemName: "sparkles")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            
            // Name & Model Selector
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("DeepSeek AI")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    
                    // Green Verified Checkmark
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.green)
                }
                
                // Interactive Model Picker Dropdown
                Menu {
                    ForEach(DeepSeekModel.allCases) { model in
                        Button(action: {
                            withAnimation { selectedModel = model }
                        }) {
                            HStack {
                                Text("\(model.displayName) (\(model.badge))")
                                if selectedModel == model {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedModel.displayName)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            // Info Button (Screenshot 4)
            Button(action: { showingModelInfo = true }) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#1F2937"))
                        .frame(width: 36, height: 36)
                    Image(systemName: "info")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
    // MARK: - Empty State with Quick Prompts
    private var emptyStatePrompts: some View {
        VStack(spacing: 16) {
            Text("Bạn cần gia sư DeepSeek hỗ trợ phần nào hôm nay?")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 10) {
                promptButton("📐 Giải thích định lý đạo hàm lớp 12 và các dạng bài thi")
                promptButton("🧪 Hướng dẫn cân bằng phương trình oxi hóa - khử môn Hóa")
                promptButton("🇬🇧 Mẹo phân biệt Past Simple và Past Continuous")
                promptButton("📚 Tóm tắt giá trị nhân đạo tác phẩm Vợ Nhặt - Ngữ Văn")
            }
        }
        .padding(.horizontal, 10)
    }
    
    private func promptButton(_ text: String) -> some View {
        Button(action: { sendUserPrompt(text) }) {
            HStack {
                Text(text)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(hex: "#374151"))
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.caption2)
                    .foregroundColor(AppTheme.primaryMint)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(hex: "#F9FAFB"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
            )
        }
    }
    
    // MARK: - Chat Bubble Row (No enclosing boxing, Markdown support)
    private func chatBubbleRow(msg: ChatMessage) -> some View {
        HStack(alignment: .bottom, spacing: 10) {
            if msg.role == "user" {
                Spacer(minLength: 48)
                
                Text(msg.content)
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(AppTheme.primaryMint)
                    )
            } else {
                // AI Message Bubble with Markdown rendering
                VStack(alignment: .leading, spacing: 8) {
                    MarkdownMessageView(content: msg.content)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(Color(hex: "#F3F4F6"))
                        )
                    
                    // Copy button
                    Button(action: {
                        UIPasteboard.general.string = msg.content
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.on.doc")
                            Text("Sao chép lời giải")
                        }
                        .font(.caption2)
                        .foregroundColor(AppTheme.primary)
                        .padding(.leading, 6)
                    }
                }
                
                Spacer(minLength: 32)
            }
        }
    }
    
    // MARK: - Thinking Bubble
    private var thinkingBubble: some View {
        HStack {
            HStack(spacing: 8) {
                Text("DeepSeek đang giải...")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                ProgressView().scaleEffect(0.7)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule().fill(Color(hex: "#F3F4F6"))
            )
            Spacer()
        }
    }
    
    // MARK: - 3. Bottom Chat Input Bar (Screenshot 4 Style)
    private var bottomChatInputBar: some View {
        HStack(spacing: 12) {
            // Plus Button (Black circle)
            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#1F2937"))
                        .frame(width: 36, height: 36)
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            // Image Attachment Icon
            Button(action: {}) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#1F2937"))
            }
            
            // Text Input Field (Capsule)
            HStack {
                TextField("Nhập tin nhắn...", text: $inputPrompt)
                    .font(.system(size: 15))
                
                if !inputPrompt.isEmpty {
                    Button(action: { inputPrompt = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color(hex: "#F3F4F6"))
            )
            
            // Smile Emoji Button
            Button(action: {}) {
                Image(systemName: "face.smiling")
                    .font(.system(size: 22))
                    .foregroundColor(Color(hex: "#1F2937"))
            }
            
            // Microphone or Send Button
            if inputPrompt.trimmingCharacters(in: .whitespaces).isEmpty {
                Button(action: {}) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "#1F2937"))
                }
            } else {
                Button(action: {
                    sendUserPrompt(inputPrompt)
                }) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.primaryMint)
                            .frame(width: 36, height: 36)
                        Image(systemName: "arrow.up")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(isThinking)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.white)
    }
    
    // MARK: - Actions
    private func sendUserPrompt(_ prompt: String) {
        let trimmed = prompt.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        let userMessage = ChatMessage(role: "user", content: trimmed)
        messages.append(userMessage)
        inputPrompt = ""
        isThinking = true
        
        DeepSeekService.shared.sendChat(
            messages: messages,
            model: selectedModel,
            apiKey: appState.deepSeekApiKey,
            serverUrl: appState.deepSeekServerUrl
        ) { result in
            isThinking = false
            switch result {
            case .success(let answer):
                let aiMsg = ChatMessage(role: "assistant", content: answer)
                messages.append(aiMsg)
            case .failure(let error):
                let errorMsg = ChatMessage(role: "assistant", content: "Lỗi kết nối DeepSeek: \(error.localizedDescription)")
                messages.append(errorMsg)
            }
        }
    }
}
