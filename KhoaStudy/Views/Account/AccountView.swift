import SwiftUI

struct AvatarOption: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let color: Color
}

struct AccountView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAvatarPicker: Bool = false
    @State private var showingEditProfileSheet: Bool = false
    @State private var showingServerConfigSheet: Bool = false
    @State private var serverTestResult: String = ""
    @State private var isTestingServer: Bool = false
    
    // State for editing name & grade
    @State private var editNameInput: String = ""
    @State private var editGradeSelection: Int = 12
    
    private let avatarOptions: [AvatarOption] = [
        AvatarOption(icon: "person.crop.circle.fill", name: "Cá nhân", color: Color(hex: "#10B981")),
        AvatarOption(icon: "graduationcap.fill", name: "Học sinh", color: Color(hex: "#047857")),
        AvatarOption(icon: "sparkles", name: "Tỏa sáng", color: Color(hex: "#F59E0B")),
        AvatarOption(icon: "brain.head.profile", name: "Trí tuệ", color: Color(hex: "#8B5CF6")),
        AvatarOption(icon: "book.fill", name: "Chăm học", color: Color(hex: "#3B82F6")),
        AvatarOption(icon: "star.fill", name: "Ngôi sao", color: Color(hex: "#EAB308")),
        AvatarOption(icon: "flame.fill", name: "Năng nổ", color: Color(hex: "#EF4444")),
        AvatarOption(icon: "heart.fill", name: "Đam mê", color: Color(hex: "#EC4899")),
        AvatarOption(icon: "bolt.fill", name: "Tốc độ", color: Color(hex: "#F97316")),
        AvatarOption(icon: "pencil.and.outline", name: "Sáng tác", color: Color(hex: "#14B8A6")),
        AvatarOption(icon: "wand.and.stars", name: "Phép màu", color: Color(hex: "#6366F1")),
        AvatarOption(icon: "trophy.fill", name: "Thủ khoa", color: Color(hex: "#F59E0B"))
    ]
    
    var body: some View {
        ZStack {
            // Nền phẳng, sáng, sạch sẽ chuẩn phong cách tối giản
            Color(hex: "#F9FAFB")
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Header tiêu đề trang
                    HStack {
                        Text("Tài Khoản")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                        Spacer()
                    }
                    .padding(.top, 14)
                    .padding(.horizontal, 4)
                    
                    // 1. Thẻ Hồ Sơ Học Sinh (Phẳng, 1 lớp, không khung lồng)
                    profileSectionCard
                    
                    // 2. Thẻ Cài Đặt & Kết Nối AI (Phẳng, 1 lớp với divider)
                    settingsSectionCard
                    
                    // 3. Thẻ Thông Tin Ứng Dụng
                    aboutSectionCard
                    
                    // 4. Nút Đăng Xuất
                    logoutButton
                    
                    // Khoảng trống dưới cùng tránh bị thanh tabbar che
                    Spacer().frame(height: 110)
                }
                .padding(.horizontal, 16)
            }
        }
        .sheet(isPresented: $showingAvatarPicker) {
            avatarPickerSheet
        }
        .sheet(isPresented: $showingEditProfileSheet) {
            editProfileSheet
        }
        .sheet(isPresented: $showingServerConfigSheet) {
            GeminiConnectSheet()
        }
        .onAppear {
            testServer()
        }
    }
    
    // MARK: - 1. Thẻ Hồ Sơ Học Sinh (Flat 1-layer, không email rác, hỗ trợ đổi tên)
    private var profileSectionCard: some View {
        HStack(spacing: 16) {
            // Avatar người dùng có nút chỉnh sửa
            Button(action: { showingAvatarPicker = true }) {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#10B981"), Color(hex: "#047857")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                        .shadow(color: Color(hex: "#10B981").opacity(0.25), radius: 6, x: 0, y: 3)
                    
                    Image(systemName: appState.currentUser.avatarName)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                    
                    // Huy hiệu cây bút đổi ảnh
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 22, height: 22)
                            .shadow(color: Color.black.opacity(0.12), radius: 2)
                        
                        Image(systemName: "pencil")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(hex: "#047857"))
                    }
                    .offset(x: 2, y: 2)
                }
            }
            .buttonStyle(.plain)
            
            // Thông tin tên & khối lớp
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(appState.currentUser.username.isEmpty ? "Chưa nhập tên" : appState.currentUser.username)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(appState.currentUser.username.isEmpty ? Color(hex: "#9CA3AF") : Color(hex: "#111827"))
                        .lineLimit(1)
                    
                    Button(action: {
                        editNameInput = appState.currentUser.username
                        editGradeSelection = appState.currentUser.grade
                        showingEditProfileSheet = true
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#10B981"))
                    }
                }
                
                Text("Học sinh • Lớp \(appState.currentUser.grade)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(hex: "#6B7280"))
                
                HStack(spacing: 5) {
                    Circle()
                        .fill(appState.isGeminiConnected ? Color(hex: "#10B981") : Color(hex: "#F59E0B"))
                        .frame(width: 6, height: 6)
                    Text(appState.isGeminiConnected ? "Shimy AI: Sẵn sàng" : "Shimy AI: Chờ kết nối")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(appState.isGeminiConnected ? Color(hex: "#059669") : Color(hex: "#D97706"))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(appState.isGeminiConnected ? Color(hex: "#ECFDF5") : Color(hex: "#FFFBEB"))
                )
                .padding(.top, 2)
            }
            
            Spacer()
            
            // Nút sửa thông tin
            Button(action: {
                editNameInput = appState.currentUser.username
                editGradeSelection = appState.currentUser.grade
                showingEditProfileSheet = true
            }) {
                Text("Đổi tên")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "#047857"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(hex: "#ECFDF5"))
                    .clipShape(Capsule())
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
        )
    }
    
    // MARK: - 2. Thẻ Cài Đặt Học Tập & Kết Nối AI
    private var settingsSectionCard: some View {
        VStack(spacing: 0) {
            // Mục 1: Khối lớp học
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#6366F1"))
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Khối Lớp Đang Học")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#111827"))
                        Text("Chương trình SGK chuẩn Bộ GD&ĐT")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "#9CA3AF"))
                    }
                }
                
                Spacer()
                
                Menu {
                    ForEach(6...12, id: \.self) { g in
                        Button(action: {
                            appState.updateStudentProfile(name: appState.currentUser.username, grade: g)
                        }) {
                            HStack {
                                Text("Lớp \(g)")
                                if appState.currentUser.grade == g {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Lớp \(appState.currentUser.grade)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(hex: "#047857"))
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(hex: "#047857"))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(hex: "#ECFDF5"))
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            
            Divider()
                .padding(.leading, 52)
            
            // Mục 2: Trợ lý AI Shimy (Groq / Gemini)
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#10B981"))
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Dịch Vụ AI Shimy")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#111827"))
                        Text(appState.selectedProvider == .groq ? "Groq Cloud (Siêu Tốc)" : "Google Gemini Cloud")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "#9CA3AF"))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    showingServerConfigSheet = true
                }) {
                    Text("Cấu hình")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "#10B981"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(hex: "#ECFDF5"))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            
            Divider()
                .padding(.leading, 52)
            
            // Mục 3: Ngôn ngữ hiển thị
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: "globe")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#3B82F6"))
                        .frame(width: 24)
                    
                    Text("Ngôn Ngữ")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#111827"))
                }
                
                Spacer()
                
                Menu {
                    ForEach(AppLanguage.allCases, id: \.self) { lang in
                        Button(action: {
                            withAnimation { appState.currentLanguage = lang }
                        }) {
                            HStack {
                                Text(lang.rawValue)
                                if appState.currentLanguage == lang {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(appState.currentLanguage.rawValue)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(hex: "#374151"))
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "#9CA3AF"))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(hex: "#F3F4F6"))
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            
            Divider()
                .padding(.leading, 52)
            
            // Mục 4: Kiểm tra trạng thái AI
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "#14B8A6"))
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Trạng Thái Mạng AI")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#111827"))
                        if !serverTestResult.isEmpty {
                            Text(serverTestResult)
                                .font(.system(size: 11))
                                .foregroundColor(appState.isGeminiConnected ? Color(hex: "#059669") : Color(hex: "#D97706"))
                                .lineLimit(1)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: { testServer() }) {
                    if isTestingServer {
                        ProgressView()
                            .scaleEffect(0.7)
                    } else {
                        Text("Kiểm tra")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(hex: "#047857"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#F3F4F6"))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
        )
    }
    
    // MARK: - 3. Thẻ Thông Tin Ứng Dụng
    private var aboutSectionCard: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                        .frame(width: 24)
                    
                    Text("Phiên Bản")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#111827"))
                }
                
                Spacer()
                
                Text("Shimy v1.2.0 (Build 59)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#6B7280"))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            
            Divider()
                .padding(.leading, 52)
            
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#10B981"))
                        .frame(width: 24)
                    
                    Text("Chương Trình Giáo Dục")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#111827"))
                }
                
                Spacer()
                
                Text("GDPT Mới 2026")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#059669"))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
        )
    }
    
    // MARK: - 4. Nút Đăng Xuất
    private var logoutButton: some View {
        Button(action: {
            withAnimation { appState.logout() }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 15, weight: .bold))
                Text("Đăng Xuất Tài Khoản")
                    .font(.system(size: 14, weight: .bold))
            }
            .foregroundColor(Color(hex: "#DC2626"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(hex: "#FCA5A5").opacity(0.6), lineWidth: 1)
            )
        }
    }
    
    // MARK: - Sheet Đổi Tên Học Sinh & Khối Lớp
    private var editProfileSheet: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("HỌ VÀ TÊN HỌC SINH")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "#6B7280"))
                    
                    TextField("Nhập họ và tên của bạn...", text: $editNameInput)
                        .font(.system(size: 15))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(Color(hex: "#F3F4F6"))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("KHỐI LỚP")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "#6B7280"))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(6...12, id: \.self) { g in
                                let isSelected = (editGradeSelection == g)
                                Button(action: {
                                    editGradeSelection = g
                                }) {
                                    Text("Lớp \(g)")
                                        .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                        .foregroundColor(isSelected ? .white : Color(hex: "#374151"))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule()
                                                .fill(isSelected ? Color(hex: "#047857") : Color(hex: "#F3F4F6"))
                                        )
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    appState.updateStudentProfile(name: editNameInput, grade: editGradeSelection)
                    showingEditProfileSheet = false
                }) {
                    Text("Lưu Thay Đổi")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(hex: "#047857"))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
            .padding(20)
            .navigationTitle("Thông Tin Học Sinh")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Hủy") {
                        showingEditProfileSheet = false
                    }
                }
            }
        }
        .presentationDetents([.fraction(0.45)])
    }
    
    // MARK: - Sheet Chọn Avatar
    private var avatarPickerSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Chọn biểu tượng đại diện phù hợp với bạn")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#6B7280"))
                        .padding(.top, 10)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(avatarOptions) { opt in
                            let isSelected = appState.currentUser.avatarName == opt.icon
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    appState.updateAvatar(opt.icon)
                                }
                            }) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(opt.color.opacity(isSelected ? 0.25 : 0.12))
                                            .frame(width: 58, height: 58)
                                        
                                        Image(systemName: opt.icon)
                                            .font(.system(size: 26))
                                            .foregroundColor(opt.color)
                                        
                                        if isSelected {
                                            Circle()
                                                .strokeBorder(opt.color, lineWidth: 2.5)
                                                .frame(width: 62, height: 62)
                                        }
                                    }
                                    
                                    Text(opt.name)
                                        .font(.caption)
                                        .fontWeight(isSelected ? .bold : .medium)
                                        .foregroundColor(Color(hex: "#111827"))
                                }
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(isSelected ? opt.color : Color(hex: "#E5E7EB"), lineWidth: isSelected ? 1.5 : 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 24)
            }
            .background(Color(hex: "#F9FAFB").ignoresSafeArea())
            .navigationTitle("Đổi Avatar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Xong") {
                        showingAvatarPicker = false
                    }
                    .font(.body.weight(.bold))
                    .foregroundColor(Color(hex: "#047857"))
                }
            }
        }
    }
    
    private func testServer() {
        isTestingServer = true
        GeminiAIService.shared.checkConnection(
            serverUrl: appState.serverUrl,
            appToken: appState.appAuthToken,
            geminiApiKey: appState.geminiApiKey,
            groqApiKey: appState.groqApiKey,
            provider: appState.selectedProvider
        ) { online, msg in
            isTestingServer = false
            appState.isAIConnected = online
            serverTestResult = msg
        }
    }
}
