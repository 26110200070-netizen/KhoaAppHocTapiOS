import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct AIChatView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    @State private var messages: [ChatMessage] = []
    @State private var inputPrompt: String = ""
    @State private var isThinking: Bool = false
    @State private var selectedModel: GeminiAIModel = .flash // Default is Flash!
    @State private var streamingText: String = ""
    @State private var showingNewChatConfirmation: Bool = false
    
    // Popup & capability states
    @State private var showingPlusPopup: Bool = false
    @State private var isWebSearchActive: Bool = false
    @State private var isDeepReasoningActive: Bool = false
    
    // Attachments
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var attachedImage: UIImage? = nil
    @State private var attachedFileName: String? = nil
    @State private var attachedFileContent: String? = nil
    @State private var showingPhotoPicker: Bool = false
    @State private var showingDocumentPicker: Bool = false
    
    var body: some View {
        ZStack {
            // Edge-to-edge white background filling all safe areas
            Color.white
                .ignoresSafeArea()
                .onTapGesture {
                    hideKeyboard()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showingPlusPopup = false
                    }
                }
            
            // Decorative subtle 4-point stars watermark
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
                // 1. Custom Top Bar
                customTopNavBar
                
                Divider().opacity(0.3)
                
                // 2. Chat Conversation
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
                            
                            // Streaming / Typing in progress
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
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showingPlusPopup = false
                        }
                    }
                    .onChange(of: messages.count) { _ in
                        if let lastId = messages.last?.id {
                            withAnimation(.easeOut(duration: 0.3)) {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // 3. Attachments & Active Badges Bar (if any active)
                if hasActiveAttachmentsOrModes {
                    activeBadgesAndAttachmentsBar
                }
                
                // 4. Plus Pop-up Menu (Ascends right above the plus button)
                if showingPlusPopup {
                    plusFeaturesPopup
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                // 5. Bottom Chat Input Bar (Icon photo & emoji removed!)
                bottomChatInputBar
            }
        }
        .navigationBarHidden(true)
        .photosPicker(isPresented: $showingPhotoPicker, selection: $selectedPhotoItem, matching: .images)
        .onChange(of: selectedPhotoItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        self.attachedImage = image
                    }
                }
            }
        }
        .fileImporter(
            isPresented: $showingDocumentPicker,
            allowedContentTypes: [.plainText, .text, .pdf, .data]
        ) { result in
            switch result {
            case .success(let selectedUrl):
                let accessing = selectedUrl.startAccessingSecurityScopedResource()
                defer {
                    if accessing { selectedUrl.stopAccessingSecurityScopedResource() }
                }
                
                self.attachedFileName = selectedUrl.lastPathComponent
                if let content = try? String(contentsOf: selectedUrl, encoding: .utf8) {
                    self.attachedFileContent = content
                } else if let data = try? Data(contentsOf: selectedUrl) {
                    self.attachedFileContent = "Tệp đính kèm (\(data.count) bytes)."
                }
            case .failure(let error):
                print("Lỗi chọn tệp: \(error.localizedDescription)")
            }
        }
        .confirmationDialog("Tạo cuộc trò chuyện mới?", isPresented: $showingNewChatConfirmation, titleVisibility: .visible) {
            Button("Xác nhận tạo chat mới", role: .destructive) {
                startNewChat()
            }
            Button("Hủy", role: .cancel) {}
        } message: {
            Text("Nội dung cuộc trò chuyện hiện tại sẽ được làm mới.")
        }
    }
    
    // MARK: - 1. Custom Top Bar
    private var customTopNavBar: some View {
        HStack(spacing: 12) {
            // Circular Back Button
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
                    Text("Shimy")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.green)
                }
                
                // Dropdown to switch model
                Menu {
                    ForEach(GeminiAIModel.allCases) { model in
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
            
            // New Chat / Switch Chat Button
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
            Text("Bạn cần Shimy hỗ trợ phần nào hôm nay?")
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
    
    // MARK: - Chat Bubble Row
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
                VStack(alignment: .leading, spacing: 8) {
                    MarkdownRendererView(content: msg.content)
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
    
    // MARK: - Streaming Message Row
    private var streamingMessageRow: some View {
        VStack(alignment: .leading, spacing: 6) {
            if streamingText.isEmpty {
                HStack(spacing: 6) {
                    Text("Shimy đang suy nghĩ và soạn câu trả lời...")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textSecondary)
                    ProgressView().scaleEffect(0.7)
                }
            } else {
                MarkdownRendererView(content: streamingText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Attachments & Active Badges
    private var hasActiveAttachmentsOrModes: Bool {
        isWebSearchActive || isDeepReasoningActive || attachedImage != nil || attachedFileName != nil
    }
    
    private var activeBadgesAndAttachmentsBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if isWebSearchActive {
                    HStack(spacing: 4) {
                        Image(systemName: "globe")
                        Text("Web Search: BẬT")
                        Button(action: { isWebSearchActive = false }) {
                            Image(systemName: "xmark.circle.fill").font(.caption2)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(Color(hex: "#1D4ED8"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color(hex: "#DBEAFE")))
                }
                
                if isDeepReasoningActive {
                    HStack(spacing: 4) {
                        Image(systemName: "brain.head.profile")
                        Text("Suy luận sâu: BẬT")
                        Button(action: { isDeepReasoningActive = false }) {
                            Image(systemName: "xmark.circle.fill").font(.caption2)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(Color(hex: "#7C3AED"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color(hex: "#EDE9FE")))
                }
                
                if let img = attachedImage {
                    HStack(spacing: 6) {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        Text("Ảnh đính kèm")
                        Button(action: { attachedImage = nil; selectedPhotoItem = nil }) {
                            Image(systemName: "xmark.circle.fill").font(.caption2)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(Color(hex: "#065F46"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color(hex: "#D1FAE5")))
                }
                
                if let fname = attachedFileName {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.fill")
                        Text(fname)
                            .lineLimit(1)
                        Button(action: { attachedFileName = nil; attachedFileContent = nil }) {
                            Image(systemName: "xmark.circle.fill").font(.caption2)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(Color(hex: "#92400E"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color(hex: "#FEF3C7")))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
        }
    }
    
    // MARK: - Plus Features Pop-up Card (Trồi lên ngay trên nút dấu cộng)
    private var plusFeaturesPopup: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Web Search
            Button(action: {
                withAnimation {
                    isWebSearchActive.toggle()
                    showingPlusPopup = false
                }
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(isWebSearchActive ? Color(hex: "#2563EB") : Color(hex: "#F3F4F6"))
                            .frame(width: 34, height: 34)
                        Image(systemName: "globe")
                            .font(.system(size: 15))
                            .foregroundColor(isWebSearchActive ? .white : Color(hex: "#1F2937"))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tìm kiếm Web")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#111827"))
                        Text("Cập nhật thông tin và giáo trình mới nhất")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text(isWebSearchActive ? "Đang bật" : "Bật")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(isWebSearchActive ? Color(hex: "#2563EB") : AppTheme.textMuted)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
            }
            
            Divider()
            
            // Deep Reasoning
            Button(action: {
                withAnimation {
                    isDeepReasoningActive.toggle()
                    showingPlusPopup = false
                }
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(isDeepReasoningActive ? Color(hex: "#7C3AED") : Color(hex: "#F3F4F6"))
                            .frame(width: 34, height: 34)
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 15))
                            .foregroundColor(isDeepReasoningActive ? .white : Color(hex: "#1F2937"))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Suy luận sâu (Think)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#111827"))
                        Text("Mô hình R1 phân tích logic từng bước")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text(isDeepReasoningActive ? "Đang bật" : "Bật")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(isDeepReasoningActive ? Color(hex: "#7C3AED") : AppTheme.textMuted)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
            }
            
            Divider()
            
            // Upload Photo
            Button(action: {
                showingPlusPopup = false
                showingPhotoPicker = true
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#F3F4F6"))
                            .frame(width: 34, height: 34)
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "#1F2937"))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tải ảnh lên")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#111827"))
                        Text("Chọn hình ảnh bài tập từ thư viện ảnh")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundColor(AppTheme.textMuted)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
            }
            
            Divider()
            
            // Upload File
            Button(action: {
                showingPlusPopup = false
                showingDocumentPicker = true
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#F3F4F6"))
                            .frame(width: 34, height: 34)
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "#1F2937"))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tải tệp tài liệu")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#111827"))
                        Text("Đính kèm tệp PDF, TXT, DOC")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundColor(AppTheme.textMuted)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
            }
        }
        .padding(6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: -6)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 6)
    }
    
    // MARK: - 5. Bottom Chat Input Bar
    private var bottomChatInputBar: some View {
        HStack(spacing: 12) {
            // Plus Button (Black circle that triggers popup)
            Button(action: {
                hideKeyboard()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    showingPlusPopup.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(showingPlusPopup ? AppTheme.primaryMint : Color(hex: "#1F2937"))
                        .frame(width: 38, height: 38)
                    Image(systemName: showingPlusPopup ? "xmark" : "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            // Text Input Field (Capsule)
            HStack {
                TextField("Hỏi Shimy bất cứ điều gì...", text: $inputPrompt)
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
            
            // ACTION BUTTON: Stop / Send / Mic
            if isThinking {
                Button(action: {
                    stopChatGeneration()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#1F2937"))
                            .frame(width: 38, height: 38)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white)
                            .frame(width: 13, height: 13)
                    }
                }
            } else if !inputPrompt.trimmingCharacters(in: .whitespaces).isEmpty || attachedImage != nil || attachedFileContent != nil {
                Button(action: {
                    sendUserPrompt(inputPrompt)
                }) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.primaryMint)
                            .frame(width: 38, height: 38)
                        Image(systemName: "arrow.up")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            } else {
                Button(action: {}) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "#1F2937"))
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
        guard !trimmed.isEmpty || attachedImage != nil || attachedFileContent != nil else { return }
        
        hideKeyboard()
        showingPlusPopup = false
        
        var displayPrompt = trimmed
        if displayPrompt.isEmpty {
            if attachedImage != nil {
                displayPrompt = "Phân tích và giải giúp em bài tập trong ảnh này."
            } else if let fname = attachedFileName {
                displayPrompt = "Đọc và giải thích tệp \(fname) giúp em."
            }
        }
        
        let userMessage = ChatMessage(role: "user", content: displayPrompt)
        messages.append(userMessage)
        inputPrompt = ""
        isThinking = true
        streamingText = ""
        
        let imageBase64 = attachedImage?.jpegData(compressionQuality: 0.6)?.base64EncodedString()
        let fileContent = attachedFileContent
        let webSearch = isWebSearchActive
        let deepReasoning = isDeepReasoningActive
        
        // Reset single-shot attachments
        attachedImage = nil
        selectedPhotoItem = nil
        attachedFileName = nil
        attachedFileContent = nil
        
        GeminiAIService.shared.sendStreamingChat(
            messages: messages,
            model: selectedModel,
            appToken: appState.appAuthToken,
            serverUrl: appState.serverUrl,
            geminiApiKey: appState.geminiApiKey,
            isWebSearch: webSearch,
            isDeepReasoning: deepReasoning,
            attachedImageBase64: imageBase64,
            attachedFileContent: fileContent,
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
                let errorMsg = ChatMessage(role: "assistant", content: "Lỗi kết nối Shimy: \(error.localizedDescription)")
                messages.append(errorMsg)
                streamingText = ""
                isThinking = false
            }
        )
    }
    
    private func stopChatGeneration() {
        GeminiAIService.shared.stopStreaming()
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
        attachedImage = nil
        selectedPhotoItem = nil
        attachedFileName = nil
        attachedFileContent = nil
    }
    
    private func startPresetTopic(_ prompt: String) {
        startNewChat()
        sendUserPrompt(prompt)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
