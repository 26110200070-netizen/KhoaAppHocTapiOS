import SwiftUI

struct AIChatView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    @State private var messages: [ChatMessage] = []
    @State private var inputPrompt: String = ""
    @State private var isThinking: Bool = false
    @State private var selectedModel: DeepSeekModel = .chat
    @State private var showingModelInfo: Bool = false
    @State private var streamingText: String = ""
    
    var body: some View {
        ZStack {
            // Edge-to-edge white background filling all safe areas
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
                    .opacity(0.3)
                
                // 2. Chat Conversation (NO boxed card, unboxed AI text!)
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 18) {
                            if messages.isEmpty && !isThinking {
                                emptyStatePrompts
                                    .padding(.top, 40)
                            } else {
                                ForEach(messages) { msg in
                                    chatBubbleRow(msg: msg)
                                        .id(msg.id)
                                }
                            }
                            
                            // Streaming / Typing in progress (Unboxed text)
                            if isThinking {
                                streamingMessageRow
                                    .id("streaming_row")
                            }
                            
                            Spacer().frame(height: 10)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                    }
                    .onChange(of: messages.count) { _ in
                        if let lastId = messages.last?.id {
                            withAnimation { proxy.scrollTo(lastId, anchor: .bottom) }
                        }
                    }
                    .onChange(of: streamingText) { _ in
                        withAnimation { proxy.scrollTo("streaming_row", anchor: .bottom) }
                    }
                }
                
                // 3. Bottom Chat Input Bar (Screenshot 4 Style - No floating menu obstruction!)
                bottomChatInputBar
            }
        }
        .navigationBarHidden(true)
        .alert("Mô Hình Trí Tuệ Nhân Tạo", isPresented: $showingModelInfo) {
            Button("Đóng", role: .cancel) {}
        } message: {
            Text("Đang kết nối: \(appState.deepSeekServerUrl)\nModel: \(selectedModel.displayName)\nPhiên Google DeepSeek đang hoạt động trực tiếp!")
        }
    }
    
    // MARK: - 1. Custom Top Bar (Tammi Style - Screenshot 4)
    private var customTopNavBar: some View {
        HStack(spacing: 12) {
            // Circular Back Button (Bấm vào thoát ngay về trang trước!)
            Button(action: {
                dismiss()
            }) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#1F2937"))
                        .frame(width: 38, height: 38)
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
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.green)
                }
                
                // Dropdown to switch model
                Menu {
                    ForEach(DeepSeekModel.allCases) { model in
                        Button(action: {
                            withAnimation { selectedModel = model }
                        }) {
                            HStack {
                                Text(model.displayName)
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
            
            // Info Button
            Button(action: { showingModelInfo = true }) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#1F2937"))
                        .frame(width: 38, height: 38)
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
    
    // MARK: - Empty State Prompts
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
    
    // MARK: - Chat Bubble Row (UNBOXED AI TEXT - KHÔNG KHUNG BAO BỌC!)
    private func chatBubbleRow(msg: ChatMessage) -> some View {
        HStack(alignment: .top, spacing: 10) {
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
                // AI Response: UNBOXED! Directly on the clean background!
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedStringKey(msg.content))
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "#1F2937"))
                        .lineSpacing(5)
                        .padding(.vertical, 4)
                    
                    // Copy button
                    Button(action: {
                        UIPasteboard.general.string = msg.content
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.on.doc")
                            Text("Sao chép câu trả lời")
                        }
                        .font(.caption2)
                        .foregroundColor(AppTheme.primary)
                    }
                    .padding(.top, 2)
                }
                
                Spacer(minLength: 24)
            }
        }
    }
    
    // MARK: - Streaming Message Row (Word-by-word typewriter - Unboxed)
    private var streamingMessageRow: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                if streamingText.isEmpty {
                    HStack(spacing: 6) {
                        Text("DeepSeek đang trả lời...")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                        ProgressView().scaleEffect(0.7)
                    }
                } else {
                    Text(LocalizedStringKey(streamingText))
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "#1F2937"))
                        .lineSpacing(5)
                }
            }
            Spacer(minLength: 24)
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
            
            // Send / Mic Button
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
        .padding(.top, 10)
        .padding(.bottom, 14) // Clean padding above home indicator, no tab bar collision!
        .background(Color.white)
    }
    
    // MARK: - Send Prompt with Streaming
    private func sendUserPrompt(_ prompt: String) {
        let trimmed = prompt.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        let userMessage = ChatMessage(role: "user", content: trimmed)
        messages.append(userMessage)
        inputPrompt = ""
        isThinking = true
        streamingText = ""
        
        DeepSeekService.shared.sendStreamingChat(
            messages: messages,
            model: selectedModel,
            apiKey: appState.deepSeekApiKey,
            serverUrl: appState.deepSeekServerUrl,
            onToken: { token in
                streamingText += token
            },
            onComplete: {
                let aiMsg = ChatMessage(role: "assistant", content: streamingText)
                messages.append(aiMsg)
                streamingText = ""
                isThinking = false
            },
            onError: { error in
                let errorMsg = ChatMessage(role: "assistant", content: "Lỗi kết nối DeepSeek: \(error.localizedDescription)")
                messages.append(errorMsg)
                streamingText = ""
                isThinking = false
            }
        )
    }
}
