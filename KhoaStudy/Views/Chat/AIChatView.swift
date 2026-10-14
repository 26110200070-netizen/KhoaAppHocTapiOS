import SwiftUI

struct AIChatView: View {
    @EnvironmentObject var appState: AppState
    @State private var messages: [ChatMessage] = []
    @State private var inputPrompt: String = ""
    @State private var isThinking: Bool = false
    @State private var isServerOnline: Bool = false
    @State private var connectionStatusText: String = "Đang kiểm tra kết nối..."
    
    // Quick prompt suggestions
    let samplePrompts = [
        "Giải thích cho em định lý đạo hàm lớp 12",
        "Cho em 3 bài trắc nghiệm Hóa học có giải",
        "Mẹo nhớ nhanh các thì Tiếng Anh",
        "Tóm tắt tác phẩm Vợ Nhặt - Ngữ Văn",
        "Phương pháp giải con lắc lò xo - Vật lý"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 1. Connection Status Pill
                    serverStatusHeader
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 6)
                    
                    // 2. Chat History Area
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 16) {
                                // Welcome Card
                                if messages.isEmpty {
                                    welcomeAICard
                                        .padding(.top, 10)
                                }
                                
                                ForEach(messages) { msg in
                                    messageRow(msg: msg)
                                        .id(msg.id)
                                }
                                
                                // Thinking Pulse Indicator
                                if isThinking {
                                    thinkingIndicatorRow
                                        .id("thinking_indicator")
                                }
                                
                                Spacer().frame(height: 20)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        }
                        .onChange(of: messages.count) { _ in
                            if let lastId = messages.last?.id {
                                withAnimation { proxy.scrollTo(lastId, anchor: .bottom) }
                            }
                        }
                        .onChange(of: isThinking) { thinking in
                            if thinking {
                                withAnimation { proxy.scrollTo("thinking_indicator", anchor: .bottom) }
                            }
                        }
                    }
                    
                    // 3. Quick Suggestions Row
                    quickSuggestionsRow
                        .padding(.bottom, 8)
                    
                    // 4. Message Input Bar
                    bottomInputBar
                        .padding(.horizontal, 20)
                        .padding(.bottom, 95) // Spacing above floating tab bar
                }
            }
            .navigationTitle("Gia Sư DeepSeek AI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        messages.removeAll()
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
            .onAppear {
                checkDeepSeekServer()
            }
        }
    }
    
    // MARK: - Server Status Header
    private var serverStatusHeader: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(isServerOnline ? Color.green : Color.orange)
                .frame(width: 8, height: 8)
            
            Text(isServerOnline ? "DeepSeek Engine: Đã kết nối" : "DeepSeek: \(appState.deepSeekServerUrl)")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(AppTheme.textSecondary)
            
            Spacer()
            
            Button(action: { checkDeepSeekServer() }) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("Kiểm tra")
                }
                .font(.caption2)
                .foregroundColor(AppTheme.primary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        )
    }
    
    // MARK: - Welcome Card
    private var welcomeAICard: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppTheme.primaryLight)
                    .frame(width: 68, height: 68)
                Image(systemName: "sparkles")
                    .font(.system(size: 32))
                    .foregroundColor(AppTheme.primaryMint)
            }
            
            Text("Xin chào \(appState.currentUser.username)! 🎓")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.textPrimary)
            
            Text("Tôi là Gia sư DeepSeek AI. Bạn có thể hỏi bất kỳ bài học, công thức hay đề bài nào của THCS và THPT!")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(4)
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .cleanCard(cornerRadius: 24, padding: 20)
    }
    
    // MARK: - Message Row
    private func messageRow(msg: ChatMessage) -> some View {
        HStack(alignment: .top, spacing: 10) {
            if msg.role == "user" {
                Spacer(minLength: 40)
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(msg.content)
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(AppTheme.primaryMint)
                        )
                    
                    Text(formatTime(msg.timestamp))
                        .font(.caption2)
                        .foregroundColor(AppTheme.textMuted)
                }
            } else {
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryLight)
                        .frame(width: 36, height: 36)
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.primary)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(msg.content)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textPrimary)
                        .lineSpacing(4)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.white)
                        )
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                    
                    HStack(spacing: 12) {
                        Text(formatTime(msg.timestamp))
                            .font(.caption2)
                            .foregroundColor(AppTheme.textMuted)
                        
                        Button(action: {
                            UIPasteboard.general.string = msg.content
                        }) {
                            HStack(spacing: 3) {
                                Image(systemName: "doc.on.doc")
                                Text("Sao chép")
                            }
                            .font(.caption2)
                            .foregroundColor(AppTheme.primary)
                        }
                    }
                    .padding(.leading, 6)
                }
                
                Spacer(minLength: 30)
            }
        }
    }
    
    // MARK: - Thinking Pulse Indicator
    private var thinkingIndicatorRow: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(AppTheme.primaryLight)
                    .frame(width: 36, height: 36)
                Image(systemName: "sparkles")
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.primaryMint)
            }
            
            HStack(spacing: 6) {
                Text("DeepSeek đang suy nghĩ...")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                ProgressView()
                    .scaleEffect(0.7)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule().fill(Color.white)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
            
            Spacer()
        }
    }
    
    // MARK: - Quick Suggestions Row
    private var quickSuggestionsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(samplePrompts, id: \.self) { prompt in
                    Button(action: {
                        sendUserPrompt(prompt)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "bolt.fill")
                                .font(.caption2)
                                .foregroundColor(AppTheme.primaryMint)
                            Text(prompt)
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Capsule().fill(Color.white))
                        .foregroundColor(AppTheme.textPrimary)
                        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Bottom Input Bar
    private var bottomInputBar: some View {
        HStack(spacing: 10) {
            HStack {
                TextField("Hỏi gia sư DeepSeek bất kỳ bài tập nào...", text: $inputPrompt)
                    .font(.system(size: 14))
                
                if !inputPrompt.isEmpty {
                    Button(action: { inputPrompt = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppTheme.textMuted)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            
            // Send Button
            Button(action: {
                sendUserPrompt(inputPrompt)
            }) {
                ZStack {
                    Circle()
                        .fill(inputPrompt.trimmingCharacters(in: .whitespaces).isEmpty ? AppTheme.textMuted.opacity(0.4) : AppTheme.primaryMint)
                        .frame(width: 46, height: 46)
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                }
                .shadow(color: AppTheme.primaryMint.opacity(0.3), radius: 6, x: 0, y: 3)
            }
            .disabled(inputPrompt.trimmingCharacters(in: .whitespaces).isEmpty || isThinking)
        }
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
    
    private func checkDeepSeekServer() {
        DeepSeekService.shared.checkConnection(serverUrl: appState.deepSeekServerUrl) { online, message in
            self.isServerOnline = online
            self.connectionStatusText = message
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
