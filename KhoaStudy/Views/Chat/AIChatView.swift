import SwiftUI
import PhotosUI
import Photos
import UniformTypeIdentifiers
import PDFKit

// MARK: - Recent Photos Loader
class RecentPhotosLoader: ObservableObject {
    @Published var recentImages: [UIImage] = []
    private var hasLoaded: Bool = false
    
    func loadPhotos() {
        guard !hasLoaded else { return }
        hasLoaded = true
        
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if status == .authorized || status == .limited {
            fetchDevicePhotos()
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    DispatchQueue.main.async {
                        self.fetchDevicePhotos()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.loadFallbackPhotos()
                    }
                }
            }
        } else {
            loadFallbackPhotos()
        }
    }
    
    private func fetchDevicePhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 15
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if assets.count == 0 {
            loadFallbackPhotos()
            return
        }
        
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        
        var images: [UIImage] = []
        let group = DispatchGroup()
        
        for i in 0..<min(assets.count, 12) {
            let asset = assets.object(at: i)
            group.enter()
            manager.requestImage(for: asset, targetSize: CGSize(width: 240, height: 240), contentMode: .aspectFill, options: requestOptions) { image, _ in
                if let img = image {
                    images.append(img)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if !images.isEmpty {
                self.recentImages = images
            } else {
                self.loadFallbackPhotos()
            }
        }
    }
    
    private func loadFallbackPhotos() {
        var fallbacks: [UIImage] = []
        if let b1 = UIImage(named: "BannerTheory") { fallbacks.append(b1) }
        if let b2 = UIImage(named: "BannerPractice") { fallbacks.append(b2) }
        if let b3 = UIImage(named: "BannerFocus") { fallbacks.append(b3) }
        self.recentImages = fallbacks
    }
}

// MARK: - Camera Picker View
struct CameraPickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPickerView
        
        init(_ parent: CameraPickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let img = info[.originalImage] as? UIImage {
                parent.selectedImage = img
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - AIChatView
struct AIChatView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    @State private var messages: [ChatMessage] = []
    @State private var inputPrompt: String = ""
    @State private var isThinking: Bool = false
    @State private var selectedModel: GeminiAIModel = .flash
    @State private var streamingText: String = ""
    @State private var showingNewChatConfirmation: Bool = false
    
    // Popup & capability states
    @State private var showingPlusDrawer: Bool = false
    @State private var isWebSearchActive: Bool = false
    @State private var isDeepReasoningActive: Bool = false
    
    // Gemini Direct Connection Sheet
    @State private var showingGeminiConnectSheet: Bool = false
    
    // Attachments
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var attachedImage: UIImage? = nil
    @State private var attachedFileName: String? = nil
    @State private var attachedFileContent: String? = nil
    @State private var showingPhotoPicker: Bool = false
    @State private var showingDocumentPicker: Bool = false
    @State private var showingCameraPicker: Bool = false
    
    // Recent photos loader
    @StateObject private var recentPhotosLoader = RecentPhotosLoader()
    
    var body: some View {
        ZStack {
            // Edge-to-edge white background filling all safe areas
            Color.white
                .ignoresSafeArea()
                .onTapGesture {
                    hideKeyboard()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showingPlusDrawer = false
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
                
                // Prompt banner if AI service is not connected yet
                if !appState.hasActiveAI {
                    Button(action: { showingGeminiConnectSheet = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .foregroundColor(AppTheme.accentOrange)
                                .font(.system(size: 13))
                            Text("Chạm vào đây để kết nối Groq Cloud hoặc Google Gemini (Miễn phí 100%)")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(hex: "#92400E"))
                                .lineLimit(1)
                            Spacer()
                            Text("Kết nối")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(hex: "#B45309"))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(hex: "#B45309"))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(hex: "#FEF3C7"))
                    }
                }
                
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
                            showingPlusDrawer = false
                        }
                    }
                    .onChange(of: messages.count) { _ in
                        saveChatMessages()
                        if let lastId = messages.last?.id {
                            withAnimation(.easeOut(duration: 0.3)) {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // 3. Modern AI Input Card (Ảnh 1, 3)
                modernInputCard
                
                // 4. Attachment Drawer (Ảnh 2)
                if showingPlusDrawer {
                    attachmentDrawer
                }
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
        .sheet(isPresented: $showingCameraPicker) {
            CameraPickerView(selectedImage: $attachedImage)
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
                let ext = selectedUrl.pathExtension.lowercased()
                
                // Extract PDF text via PDFKit
                if ext == "pdf", let pdfDoc = PDFDocument(url: selectedUrl) {
                    var fullText = ""
                    for i in 0..<min(pdfDoc.pageCount, 25) {
                        if let page = pdfDoc.page(at: i), let str = page.string {
                            fullText += "--- Trang \(i+1) ---\n" + str + "\n"
                        }
                    }
                    if !fullText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        self.attachedFileContent = fullText
                        return
                    }
                }
                
                // Plain Text / Markdown / Code
                if let content = try? String(contentsOf: selectedUrl, encoding: .utf8) {
                    self.attachedFileContent = content
                } else if let content = try? String(contentsOf: selectedUrl, encoding: .ascii) {
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
        .sheet(isPresented: $showingGeminiConnectSheet) {
            GeminiConnectSheet()
        }
        .onAppear {
            loadChatMessages()
            recentPhotosLoader.loadPhotos()
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
                
                // Dropdown to switch model based on active provider
                Menu {
                    if appState.selectedProvider == .groq {
                        ForEach(GroqModel.allCases) { m in
                            Button(action: {
                                appState.selectedGroqModel = m.rawValue
                                UserDefaults.standard.set(m.rawValue, forKey: "shimy_groq_model")
                            }) {
                                HStack {
                                    Text(m.displayName)
                                    if appState.selectedGroqModel == m.rawValue {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } else {
                        ForEach(GeminiAIModel.allCases) { m in
                            Button(action: {
                                selectedModel = m
                            }) {
                                HStack {
                                    Text(m.displayName)
                                    if selectedModel == m {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(activeModelLabel)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            // New Chat Button
            Button(action: {
                if !messages.isEmpty {
                    showingNewChatConfirmation = true
                } else {
                    startNewChat()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#F3F4F6"))
                        .frame(width: 38, height: 38)
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#1F2937"))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
    private var activeModelLabel: String {
        if appState.selectedProvider == .groq {
            let current = appState.selectedGroqModel
            return GroqModel(rawValue: current)?.shortName ?? current
        } else {
            return selectedModel.displayName
        }
    }
    
    // MARK: - Empty State Prompts
    private var emptyStatePrompts: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(AppTheme.primaryLight)
                    .frame(width: 76, height: 76)
                Image(systemName: "sparkles")
                    .font(.system(size: 36))
                    .foregroundColor(AppTheme.primary)
            }
            
            Text("Chào bạn! Mình là Shimy")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
            
            Text("Gia sư AI toàn diện hỗ trợ giải bài tập, tóm tắt lý thuyết, tra cứu thông tin SGK và luyện thi THPT / THCS.")
                .font(.system(size: 14))
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
    
    // MARK: - Chat Bubble Row (Ảnh 4)
    private func chatBubbleRow(msg: ChatMessage) -> some View {
        HStack(alignment: .top, spacing: 10) {
            if msg.role == "user" {
                Spacer(minLength: 40)
                
                VStack(alignment: .leading, spacing: 8) {
                    // Attached Image Thumbnail if present (Ảnh 4)
                    if let b64 = msg.attachedImageBase64,
                       let data = Data(base64Encoded: b64),
                       let uiImg = UIImage(data: data) {
                        Image(uiImage: uiImg)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 220, maxHeight: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                            )
                    }
                    
                    // Attached Document name if present
                    if let fname = msg.attachedFileName {
                        HStack(spacing: 6) {
                            Image(systemName: "doc.fill")
                                .foregroundColor(AppTheme.primary)
                            Text(fname)
                                .font(.system(size: 13, weight: .medium))
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.8)))
                    }
                    
                    // Text prompt
                    Text(msg.content)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#111827"))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color(hex: "#F0F4F9"))
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
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#F9FAFB"))
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - 3. Modern AI Input Card (Ảnh 1, 3)
    private var modernInputCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Attached Image Thumbnail (Ảnh 3)
            if let img = attachedImage {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                        )
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            attachedImage = nil
                            selectedPhotoItem = nil
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#1F2937"))
                                .frame(width: 22, height: 22)
                            Image(systemName: "xmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .offset(x: 6, y: -6)
                    }
                }
                .padding(.top, 4)
                .padding(.leading, 4)
            } else if let fileName = attachedFileName {
                HStack(spacing: 8) {
                    Image(systemName: "doc.fill")
                        .foregroundColor(AppTheme.primary)
                    Text(fileName)
                        .font(.system(size: 13, weight: .medium))
                        .lineLimit(1)
                        .foregroundColor(Color(hex: "#111827"))
                    Spacer()
                    Button(action: {
                        withAnimation {
                            attachedFileName = nil
                            attachedFileContent = nil
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: "#F3F4F6")))
            }
            
            // Text Input Field
            TextField("Hỏi Shimy bất cứ điều gì...", text: $inputPrompt, axis: .vertical)
                .font(.system(size: 16))
                .lineLimit(1...5)
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
            
            // Bottom Action Row
            HStack(alignment: .center, spacing: 8) {
                // "Suy nghĩ" pill
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isDeepReasoningActive.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "atom")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Suy nghĩ")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(isDeepReasoningActive ? Color(hex: "#F3E8FF") : Color.white)
                    )
                    .overlay(
                        Capsule()
                            .stroke(isDeepReasoningActive ? Color(hex: "#9333EA") : Color(hex: "#E5E7EB"), lineWidth: 1)
                    )
                    .foregroundColor(isDeepReasoningActive ? Color(hex: "#9333EA") : Color(hex: "#1F2937"))
                }
                
                // "Tìm kiếm" pill
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isWebSearchActive.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "globe")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Tìm kiếm")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(isWebSearchActive ? Color(hex: "#EBF3FE") : Color.white)
                    )
                    .overlay(
                        Capsule()
                            .stroke(isWebSearchActive ? Color(hex: "#2563EB").opacity(0.4) : Color(hex: "#E5E7EB"), lineWidth: 1)
                    )
                    .foregroundColor(isWebSearchActive ? Color(hex: "#2563EB") : Color(hex: "#1F2937"))
                }
                
                Spacer()
                
                // Plus / Close Button
                Button(action: {
                    hideKeyboard()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        showingPlusDrawer.toggle()
                        if showingPlusDrawer {
                            recentPhotosLoader.loadPhotos()
                        }
                    }
                }) {
                    ZStack {
                        Circle()
                            .stroke(Color(hex: "#111827"), lineWidth: 2)
                            .frame(width: 34, height: 34)
                        Image(systemName: showingPlusDrawer ? "xmark" : "plus")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(hex: "#111827"))
                    }
                }
                
                // Send Button (↑)
                Button(action: {
                    if isThinking {
                        stopChatGeneration()
                    } else {
                        sendUserPrompt(inputPrompt)
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#3B82F6"))
                            .frame(width: 36, height: 36)
                        if isThinking {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white)
                                .frame(width: 12, height: 12)
                        } else {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .disabled(inputPrompt.trimmingCharacters(in: .whitespaces).isEmpty && attachedImage == nil && attachedFileContent == nil && !isThinking)
                .opacity((inputPrompt.trimmingCharacters(in: .whitespaces).isEmpty && attachedImage == nil && attachedFileContent == nil && !isThinking) ? 0.6 : 1.0)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, showingPlusDrawer ? 4 : 10)
    }
    
    // MARK: - 4. Attachment Drawer (Ảnh 2)
    private var attachmentDrawer: some View {
        VStack(spacing: 14) {
            // Row 1: Recent photos horizontal carousel
            if !recentPhotosLoader.recentImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(recentPhotosLoader.recentImages.indices, id: \.self) { idx in
                            let img = recentPhotosLoader.recentImages[idx]
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    attachedImage = img
                                    showingPlusDrawer = false
                                }
                            }) {
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 76, height: 76)
                                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                                        )
                                    
                                    // Selection circle badge on top right
                                    Circle()
                                        .fill(Color.black.opacity(0.4))
                                        .frame(width: 20, height: 20)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 1.5)
                                        )
                                        .padding(5)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
            
            // Row 2: 3 Action Cards (Chụp ảnh • Album • Tệp)
            HStack(spacing: 12) {
                // 1. Chụp ảnh
                Button(action: {
                    showingPlusDrawer = false
                    showingCameraPicker = true
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "camera")
                            .font(.system(size: 26, weight: .regular))
                            .foregroundColor(Color(hex: "#111827"))
                        Text("Chụp ảnh")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "#111827"))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 94)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // 2. Album
                Button(action: {
                    showingPlusDrawer = false
                    showingPhotoPicker = true
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 26, weight: .regular))
                            .foregroundColor(Color(hex: "#111827"))
                        Text("Album")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "#111827"))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 94)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // 3. Tệp
                Button(action: {
                    showingPlusDrawer = false
                    showingDocumentPicker = true
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "paperclip")
                            .font(.system(size: 26, weight: .regular))
                            .foregroundColor(Color(hex: "#111827"))
                        Text("Tệp")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "#111827"))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 94)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 12)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    // MARK: - Actions
    private func sendUserPrompt(_ prompt: String) {
        let trimmed = prompt.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty || attachedImage != nil || attachedFileContent != nil else { return }
        
        hideKeyboard()
        showingPlusDrawer = false
        
        // If no active AI key configured, guide user to connect in 1 tap
        if !appState.hasActiveAI && appState.appAuthToken.isEmpty {
            showingGeminiConnectSheet = true
            return
        }
        
        var displayPrompt = trimmed
        if displayPrompt.isEmpty {
            if attachedImage != nil {
                displayPrompt = "Phân tích và giải giúp em bài tập trong ảnh này."
            } else if let fname = attachedFileName {
                displayPrompt = "Đọc và giải thích tệp \(fname) giúp em."
            }
        }
        
        let imageBase64 = attachedImage?.jpegData(compressionQuality: 0.6)?.base64EncodedString()
        let fileContent = attachedFileContent
        let fileName = attachedFileName
        let webSearch = isWebSearchActive
        let deepReasoning = isDeepReasoningActive
        
        let userMessage = ChatMessage(
            role: "user",
            content: displayPrompt,
            attachedImageBase64: imageBase64,
            attachedFileName: fileName
        )
        messages.append(userMessage)
        inputPrompt = ""
        isThinking = true
        streamingText = ""
        
        // Reset single-shot attachments
        attachedImage = nil
        selectedPhotoItem = nil
        attachedFileName = nil
        attachedFileContent = nil
        
        GeminiAIService.shared.sendStreamingChat(
            messages: messages,
            model: selectedModel,
            groqModel: appState.selectedGroqModel,
            provider: appState.selectedProvider,
            appToken: appState.appAuthToken,
            serverUrl: appState.serverUrl,
            geminiApiKey: appState.geminiApiKey,
            groqApiKey: appState.groqApiKey,
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
        clearChatMessages()
        streamingText = ""
        isThinking = false
        inputPrompt = ""
        attachedImage = nil
        selectedPhotoItem = nil
        attachedFileName = nil
        attachedFileContent = nil
        showingPlusDrawer = false
    }
    
    private func saveChatMessages() {
        if let data = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(data, forKey: "shimy_chat_messages_v1")
        }
    }
    
    private func loadChatMessages() {
        if let data = UserDefaults.standard.data(forKey: "shimy_chat_messages_v1"),
           let saved = try? JSONDecoder().decode([ChatMessage].self, from: data) {
            self.messages = saved
        }
    }
    
    private func clearChatMessages() {
        UserDefaults.standard.removeObject(forKey: "shimy_chat_messages_v1")
    }
    
    private func startPresetTopic(_ prompt: String) {
        startNewChat()
        sendUserPrompt(prompt)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
