import SwiftUI

struct AIChatView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    @State private var messages: [ChatMessage] = []
    @State private var inputPrompt: String = ""
    @State private var isThinking: Bool = false
    @State private var selectedModel: DeepSeekModel = .chat
    @State private var streamingText: String = ""
    @State private var showingNewChatConfirmation: Bool = false
    
    var body: some View {
        ZStack {
            // Edge-to-edge white background filling all safe areas
            Color.white
                .ignoresSafeArea()
                .onTapGesture {
                    hideKeyboard()
                }
            
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
            .allowsHitTesting(false)
            
            VStack(spacing: 0) {
                // 1. Custom Top Bar (Tammi Style - Screenshot 4)
                customTopNavBar
                
                Divider()
                    .opacity(0.3)
                
                // 2. Chat Conversation (Full-width AI response, no auto-scroll during streaming)
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
                            
                            // Streaming / Typing in progress (Full width unboxed text)
                            if isThinking {
                                streamingMessageRow
                                    .id("streaming_row")
                            }
                            
                            Spacer().frame(height: 10)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                    }
                    .scrollDismissesKeyboard(.immediately)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }
                    // Only scroll when a new user or AI message is appended; NEVER on every streaming token!
                    .onChange(of: messages.count) { _ in
                        if let lastId = messages.last?.id {
                            withAnimation(.easeOut(duration: 0.3)) {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // 3. Bottom Chat Input Bar (With Stop Square Button during generation!)
                bottomChatInputBar
            }
        }
        .navigationBarHidden(true)
        .confirmationDialog("Tạo cuộc trò chuyện mới?", isPresented: $showingNewChatConfirmation, titleVisibility: .visible) {
            Button("Xác nhận tạo chat mới", role: .destructive) {
                startNewChat()
            }
            Button("Hủy", role: .cancel) {}
        } message: {
            Text("Nội dung cuộc trò chuyện hiện tại sẽ được làm mới.")
        }
    }
    
    // MARK: - 1. Custom Top Bar (Tammi Style - Screenshot 4)
    private var customTopNavBar: some View {
        HStack(spacing: 12) {
            // Circular Back Button (Bấm vào lập tức hạ phím và thoát ngay!)
            Button(action: {
                hideKeyboard()
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
            
            // New Chat / Switch Chat Button (Icon square.and.pencil thay cho dấu chấm than)
            Menu {
                Button(action: {
                    showingNewChatConfirmation = true
                }) {
                    Label("Tạo đoạn chat mới", systemImage: "plus.bubble.fill")
                }
                
                Section("Chủ đề học tập mẫu") {
                    Button("📐 Đạo hàm & Khảo sát hàm số") {
                        startPresetTopic("Giải thích bản chất định lý đạo hàm lớp 12 và phương pháp làm bài")
                    }
                    Button("🧪 Cân bằng phản ứng Oxi hóa - Khử") {
                        startPresetTopic("Hướng dẫn các bước cân bằng phương trình oxi hóa - khử môn Hóa")
                    }
                    Button("📚 Tác phẩm Vợ Nhặt - Ngữ Văn") {
                        startPresetTopic("Tóm tắt giá trị nhân đạo tác phẩm Vợ Nhặt - Kim Lân")
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#1F2937"))
                        .frame(width: 38, height: 38)
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 15, weight: .bold))
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
        Button(action: {
            sendUserPrompt(text)
        }) {
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
    
    // MARK: - Chat Bubble Row (AI CHAT DÀI HẾT CHIỀU NGANG - KHÔNG BỊ BÓ HẸP!)
    private func chatBubbleRow(msg: ChatMessage) -> some View {
        HStack(alignment: .top, spacing: 10) {
            if msg.role == "user" {
                Spacer(minLength: 40)
                
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
                // AI Response: FULL WIDTH DÀI HẾT CHIỀU NGANG!
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedStringKey(msg.content))
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "#1F2937"))
                        .lineSpacing(5)
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
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
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    // MARK: - Streaming Message Row (Full width unboxed)
    private var streamingMessageRow: some View {
        VStack(alignment: .leading, spacing: 6) {
            if streamingText.isEmpty {
                HStack(spacing: 6) {
                    Text("DeepSeek đang soạn câu trả lời...")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textSecondary)
                    ProgressView().scaleEffect(0.7)
                }
            } else {
                Text(LocalizedStringKey(streamingText))
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "#1F2937"))
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - 3. Bottom Chat Input Bar (Khi AI đang chat: Icon Ô Vuông để DỪNG CHAT!)
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
            
            // ACTION BUTTON: Khi AI đang chat -> Nút Ô Vuông để DỪNG CHAT!
            if isThinking {
                Button(action: {
                    stopChatGeneration()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#1F2937"))
                            .frame(width: 36, height: 36)
                        // Biểu tượng ô vuông dừng chat
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white)
                            .frame(width: 13, height: 13)
                    }
                }
            } else if inputPrompt.trimmingCharacters(in: .whitespaces).isEmpty {
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
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 14)
        .background(Color.white)
    }
    
    // MARK: - Actions
    private func sendUserPrompt(_ prompt: String) {
        let trimmed = prompt.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        hideKeyboard()
        
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
    
    private func stopChatGeneration() {
        DeepSeekService.shared.stopStreaming()
        if !streamingText.isEmpty {
            let aiMsg = ChatMessage(role: "assistant", content: streamingText)
            messages.append(aiMsg)
            streamingText = ""
        }
        isThinking = false
    }
    
    private func startNewChat() {
        stopChatGeneration()
        messages.removeAll()
        streamingText = ""
        isThinking = false
        inputPrompt = ""
    }
    
    private func startPresetTopic(_ prompt: String) {
        startNewChat()
        sendUserPrompt(prompt)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
