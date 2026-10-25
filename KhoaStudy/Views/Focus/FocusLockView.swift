import SwiftUI
import AVFoundation

// MARK: - Cute Mascot Model
struct CuteMascotItem: Identifiable {
    let id: String
    let name: String
    let imageName: String
    let price: Int
    let description: String
}

/// Treo Máy Học Tập - Chế độ tập trung cao độ (Zen Focus Mode)
/// 1. Hiển thị thú cưng học tập cute tương tác thời gian (Animation thở, nổi, phản hồi khi chạm)
/// 2. Cơ chế tích lũy Xu: Mỗi 1 giờ (3600s) tự học nhận 1 Xu để đổi thú cưng mới
/// 3. Đồng hồ đếm tăng dần chuẩn xác, giao diện đêm sao tĩnh lặng
/// 4. Âm thanh thật (Sóng biển, Mưa rơi, Đêm sao), tắt thông báo, giữ màn hình luôn sáng
/// 5. Tuyệt đối không dùng emoji theo tiêu chuẩn taste-skill
struct FocusLockView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @ObservedObject private var ambientSound = AmbientSoundService.shared
    
    // Stopwatch State (Đếm tăng dần)
    @State private var elapsedSeconds: Int = 0
    @State private var isRunning: Bool = true
    @State private var timer: Timer? = nil
    
    // Coin Economy State
    @State private var coins: Int = 2
    @State private var unlockedMascotIds: Set<String> = ["MascotCat"]
    @State private var activeMascotId: String = "MascotCat"
    @State private var showingShopSheet: Bool = false
    @State private var coinAwardNotice: String? = nil
    
    // Mascot Interaction & Animation
    @State private var mascotFloat: Bool = false
    @State private var mascotWiggle: Bool = false
    @State private var speechBubbleText: String? = nil
    @State private var speechBubbleTimer: Timer? = nil
    
    // Starry Night Animation State
    @State private var starPulse: Bool = false
    @State private var showingExitAlert: Bool = false
    
    // 6 Cute Animal Mascots
    let mascots: [CuteMascotItem] = [
        CuteMascotItem(id: "MascotCat", name: "Mèo Cam Chăm Chỉ", imageName: "MascotCat", price: 0, description: "Bé mèo đeo kính tròn cần mẫn đọc từng trang sách."),
        CuteMascotItem(id: "MascotShiba", name: "Cún Shiba Cử Nhân", imageName: "MascotShiba", price: 1, description: "Chú cún Shiba đội mũ tốt nghiệp ghi chép bài học."),
        CuteMascotItem(id: "MascotPanda", name: "Gấu Trúc Nỗ Lực", imageName: "MascotPanda", price: 1, description: "Bé gấu trúc ôm bút chì khổng lồ vẽ nên ước mơ."),
        CuteMascotItem(id: "MascotBunny", name: "Thỏ Trắng Tập Trung", imageName: "MascotBunny", price: 2, description: "Bé thỏ trắng tai dài ngồi học yên lặng không xao nhãng."),
        CuteMascotItem(id: "MascotOwl", name: "Cú Mèo Học Giả", imageName: "MascotOwl", price: 2, description: "Cú mèo thông thái thức thấu đêm canh giữ kiến thức."),
        CuteMascotItem(id: "MascotKoala", name: "Koala Yên Tĩnh", imageName: "MascotKoala", price: 2, description: "Bé Koala điềm tĩnh giúp bạn giữ vững nhịp học êm đềm.")
    ]
    
    // Inspirational quotes (NO EMOJIS)
    let quotes = [
        "Tập trung sâu là chìa khóa mở cánh cửa thủ khoa.",
        "Mỗi phút bạn kiên trì hôm nay là điểm số nở hoa ngày mai.",
        "Điện thoại tắt, tương lai bật. Giữ vững nhịp độ!",
        "Thành công không đến từ may mắn, mà từ những giờ tự học tĩnh lặng."
    ]
    @State private var currentQuoteIndex: Int = 0
    
    var body: some View {
        ZStack {
            // 1. Starry Night Canvas Background
            starryNightBackground
            
            VStack(spacing: 0) {
                // Top Navigation Bar (Coins, Silence Status, Exit)
                topNavigationBar
                
                // Coin Award Toast Notice
                if let notice = coinAwardNotice {
                    Text(notice)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "#FEF08A"))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.black.opacity(0.6)))
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 4)
                }
                
                Spacer()
                
                // 2. Cute Mascot with Interactive Animation
                cuteMascotSection
                
                Spacer()
                
                // 3. Digital Stopwatch Count-Up
                stopwatchDigitalDisplay
                    .padding(.bottom, 12)
                
                // 4. Inspirational Study Quote
                quoteSection
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
                
                // 5. Ambient Sound Controller (Sóng biển, mưa rơi, đêm sao)
                ambientSoundCard
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
        }
        .sheet(isPresented: $showingShopSheet) {
            mascotShopSheet
        }
        .onAppear {
            loadCoinData()
            startStopwatch()
            ambientSound.startSound()
            UIApplication.shared.isIdleTimerDisabled = true
            
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                mascotFloat = true
            }
        }
        .onDisappear {
            stopStopwatch()
            ambientSound.stopSound()
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .alert("Kết Thúc Phiên Học?", isPresented: $showingExitAlert) {
            Button("Ở Lại Học Tiếp", role: .cancel) {}
            Button("Lưu & Thoát", role: .none) {
                saveAndDismiss()
            }
        } message: {
            let mins = elapsedSeconds / 60
            Text("Bạn đã học tập trung được \(mins > 0 ? "\(mins) phút" : "\(elapsedSeconds) giây"). Bạn có muốn lưu kết quả này vào hồ sơ không?")
        }
    }
    
    // MARK: - 1. Starry Night Sky Background
    private var starryNightBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "#050914"),
                    Color(hex: "#0B152A"),
                    Color(hex: "#101D38")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Crescent Moon at top right
            VStack {
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#FEF08A").opacity(0.12))
                            .frame(width: 80, height: 80)
                            .blur(radius: 12)
                        
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "#FEF9C3"), Color(hex: "#FACC15")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color(hex: "#FEF08A").opacity(0.5), radius: 8, x: 0, y: 0)
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 24)
                }
                Spacer()
            }
            .ignoresSafeArea()
            
            // Procedural Twinkling Stars
            GeometryReader { geo in
                ForEach(0..<30, id: \.self) { i in
                    let x = CGFloat(abs(sin(Double(i) * 123.45))) * geo.size.width
                    let y = CGFloat(abs(cos(Double(i) * 678.90))) * (geo.size.height * 0.75)
                    let size = CGFloat(2.0 + (Double(i % 3) * 1.5))
                    
                    Circle()
                        .fill(Color.white.opacity(starPulse ? Double(0.35 + (Double(i % 5) * 0.12)) : 0.18))
                        .frame(width: size, height: size)
                        .position(x: x, y: y)
                        .animation(.easeInOut(duration: 1.2 + Double(i % 3) * 0.5).repeatForever(autoreverses: true), value: starPulse)
                }
            }
            .ignoresSafeArea()
            .onAppear {
                starPulse = true
            }
        }
    }
    
    // MARK: - 2. Top Navigation Bar (Coins, Silence Status, Shop, Exit)
    private var topNavigationBar: some View {
        HStack(spacing: 12) {
            Button(action: {
                if elapsedSeconds > 30 {
                    showingExitAlert = true
                } else {
                    dismiss()
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(9)
                    .background(Circle().fill(Color.white.opacity(0.12)))
            }
            
            // Silence Status Pill
            HStack(spacing: 5) {
                Image(systemName: "bell.slash.fill")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(hex: "#34D399"))
                Text("Chế Độ Im Lặng")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.black.opacity(0.35)))
            
            Spacer()
            
            // Coin Balance & Mascot Shop Button
            Button(action: {
                showingShopSheet = true
            }) {
                HStack(spacing: 5) {
                    Image(systemName: "circle.circle.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "#FACC15"))
                    Text("\(coins) Xu")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "#FEF08A"))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color(hex: "#D97706").opacity(0.35)))
                .overlay(Capsule().stroke(Color(hex: "#FACC15").opacity(0.4), lineWidth: 1))
            }
            
            // Save Button
            Button(action: {
                saveAndDismiss()
            }) {
                Text("LƯU")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(hex: "#059669"))
                    .padding(.horizontal, 11)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color(hex: "#D1FAE5")))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
    }
    
    // MARK: - 3. Cute Mascot Section (Interactive Animation)
    private var cuteMascotSection: some View {
        let currentMascot = mascots.first(where: { $0.id == activeMascotId }) ?? mascots[0]
        
        return VStack(spacing: 10) {
            // Speech Bubble when tapped
            if let speech = speechBubbleText {
                Text(speech)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(Color.white)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 2)
                    .transition(.scale.combined(with: .opacity))
            }
            
            // Cute Mascot Image with Floating & Breathing
            Button(action: {
                handleMascotTap()
            }) {
                ZStack {
                    // Soft Ambient Halo
                    Circle()
                        .fill(Color(hex: "#10B981").opacity(0.12))
                        .frame(width: 220, height: 220)
                        .blur(radius: 20)
                    
                    Image(currentMascot.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190, height: 190)
                        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                        .shadow(color: Color.black.opacity(0.35), radius: 12, x: 0, y: 6)
                        .scaleEffect(mascotFloat ? 1.03 : 0.97)
                        .offset(y: mascotFloat ? -8 : 6)
                        .rotationEffect(.degrees(mascotWiggle ? 4 : 0))
                }
            }
            .buttonStyle(.plain)
            
            // Mascot Name & Study Badge
            HStack(spacing: 6) {
                Text(currentMascot.name)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.9))
                
                Button(action: { showingShopSheet = true }) {
                    Text("Đổi")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "#34D399"))
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.white.opacity(0.12)))
                }
            }
        }
    }
    
    // MARK: - 4. Digital Stopwatch Display (HH:MM:SS)
    private var stopwatchDigitalDisplay: some View {
        VStack(spacing: 8) {
            // Count-Up Stopwatch Text (Clean tabular figures)
            Text(formatElapsedStopwatch(elapsedSeconds))
                .font(.system(size: 44, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.4), radius: 6, x: 0, y: 2)
            
            // Play / Pause Button
            Button(action: {
                togglePlayPause()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 11, weight: .bold))
                    Text(isRunning ? "Tạm dừng" : "Tiếp tục học")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(Color.white.opacity(0.9))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(Capsule().fill(Color.white.opacity(0.12)))
            }
        }
    }
    
    // MARK: - 5. Quote Section
    private var quoteSection: some View {
        VStack(spacing: 4) {
            Text(quotes[currentQuoteIndex])
                .font(.system(size: 12.5, weight: .medium, design: .rounded))
                .foregroundColor(Color.white.opacity(0.85))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
    }
    
    // MARK: - 6. Ambient Sound Controller (NO EMOJIS, SF SYMBOLS)
    private var ambientSoundCard: some View {
        VStack(spacing: 10) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: ambientSound.soundIcons[ambientSound.selectedSoundIndex])
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(hex: "#34D399"))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ambientSound.soundNames[ambientSound.selectedSoundIndex])
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                        Text(ambientSound.isMuted ? "Đã tắt âm thanh" : "Âm thanh thật đang phát")
                            .font(.caption2)
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    ambientSound.toggleMute()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.12))
                            .frame(width: 34, height: 34)
                        Image(systemName: ambientSound.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(ambientSound.isMuted ? Color.gray : Color(hex: "#34D399"))
                    }
                }
            }
            
            // Selector 3 Sound Chips with SF Symbols
            HStack(spacing: 8) {
                soundSelectorChip(title: "Sóng Biển", icon: "water.waves", index: 0)
                soundSelectorChip(title: "Mưa Rơi", icon: "cloud.rain.fill", index: 1)
                soundSelectorChip(title: "Đêm Sao", icon: "sparkles", index: 2)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        )
    }
    
    private func soundSelectorChip(title: String, icon: String, index: Int) -> some View {
        let isSelected = (ambientSound.selectedSoundIndex == index)
        return Button(action: {
            ambientSound.startSound(soundIndex: index)
        }) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 11))
                Text(title)
                    .font(.system(size: 11, weight: isSelected ? .bold : .medium))
            }
            .foregroundColor(isSelected ? .white : Color.white.opacity(0.65))
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(isSelected ? Color(hex: "#059669") : Color.white.opacity(0.08))
            )
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Mascot Shop Sheet (Đổi thú cưng cute bằng Xu)
    private var mascotShopSheet: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    // Coin balance header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("KHO THÚ CƯNG TỰ HỌC")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(hex: "#6B7280"))
                            Text("Tích Xu Tự Học Mỗi Giờ")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#111827"))
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "circle.circle.fill")
                                .foregroundColor(Color(hex: "#D97706"))
                            Text("\(coins) Xu")
                                .font(.system(size: 15, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(hex: "#D97706"))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color(hex: "#FEF3C7")))
                    }
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                    
                    Text("Cứ mỗi 1 giờ tự học tập trung, bạn sẽ tự động nhận thêm 1 Xu để mở khóa hình ảnh các bé thú cưng đồng hành mới!")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#6B7280"))
                        .padding(.horizontal, 4)
                    
                    // Mascot Grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                        ForEach(mascots) { mascot in
                            let isUnlocked = unlockedMascotIds.contains(mascot.id)
                            let isEquipped = (activeMascotId == mascot.id)
                            
                            VStack(spacing: 8) {
                                Image(mascot.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                
                                Text(mascot.name)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(hex: "#111827"))
                                    .lineLimit(1)
                                
                                Text(mascot.description)
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(hex: "#6B7280"))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .frame(height: 28)
                                
                                // Action Button
                                if isEquipped {
                                    Text("Đang dùng")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(Color(hex: "#059669"))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Capsule().fill(Color(hex: "#D1FAE5")))
                                } else if isUnlocked {
                                    Button(action: {
                                        activeMascotId = mascot.id
                                        saveCoinData()
                                        showingShopSheet = false
                                    }) {
                                        Text("Chọn dùng")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Capsule().fill(Color(hex: "#111827")))
                                    }
                                } else {
                                    Button(action: {
                                        unlockMascot(mascot: mascot)
                                    }) {
                                        HStack(spacing: 4) {
                                            Text("Mở khóa")
                                            Text("(\(mascot.price) Xu)")
                                        }
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(coins >= mascot.price ? Color(hex: "#0D9488") : Color(hex: "#9CA3AF"))
                                        )
                                    }
                                    .disabled(coins < mascot.price)
                                }
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(isEquipped ? Color(hex: "#059669") : Color(hex: "#E5E7EB"), lineWidth: isEquipped ? 2 : 1)
                                    )
                            )
                        }
                    }
                }
                .padding(16)
            }
            .background(Color(hex: "#F8FAF9").ignoresSafeArea())
            .navigationTitle("Cửa Hàng Thú Cưng")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Xong") { showingShopSheet = false }
                        .font(.system(size: 13, weight: .bold))
                }
            }
        }
    }
    
    // MARK: - Logic Helpers
    private func handleMascotTap() {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
            mascotWiggle.toggle()
        }
        
        let encouragement = [
            "Tập trung rất tốt, tiếp tục nhé!",
            "Chăm chỉ quá, điểm số sẽ nở hoa!",
            "Cố lên, bạn đã tập trung được \(elapsedSeconds / 60) phút!",
            "Sắp đủ 1 giờ để nhận thêm 1 Xu rồi!"
        ]
        speechBubbleText = encouragement.randomElement()
        
        speechBubbleTimer?.invalidate()
        speechBubbleTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            withAnimation { speechBubbleText = nil }
        }
    }
    
    private func unlockMascot(mascot: CuteMascotItem) {
        guard coins >= mascot.price else { return }
        coins -= mascot.price
        unlockedMascotIds.insert(mascot.id)
        activeMascotId = mascot.id
        saveCoinData()
    }
    
    private func loadCoinData() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "user_focus_coins") != nil {
            coins = defaults.integer(forKey: "user_focus_coins")
        } else {
            coins = 2
            defaults.set(2, forKey: "user_focus_coins")
        }
        
        if let savedIds = defaults.stringArray(forKey: "user_unlocked_mascot_ids") {
            unlockedMascotIds = Set(savedIds)
        } else {
            unlockedMascotIds = ["MascotCat"]
            defaults.set(["MascotCat"], forKey: "user_unlocked_mascot_ids")
        }
        
        if let activeId = defaults.string(forKey: "user_active_mascot_id"), !activeId.isEmpty {
            activeMascotId = activeId
        } else {
            activeMascotId = "MascotCat"
        }
    }
    
    private func saveCoinData() {
        let defaults = UserDefaults.standard
        defaults.set(coins, forKey: "user_focus_coins")
        defaults.set(Array(unlockedMascotIds), forKey: "user_unlocked_mascot_ids")
        defaults.set(activeMascotId, forKey: "user_active_mascot_id")
    }
    
    private func startStopwatch() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if isRunning {
                elapsedSeconds += 1
                
                // Quote rotation every minute
                if elapsedSeconds % 60 == 0 {
                    currentQuoteIndex = (currentQuoteIndex + 1) % quotes.count
                }
                
                // Every 1 hour (3600 seconds) -> Award 1 Xu
                if elapsedSeconds > 0 && elapsedSeconds % 3600 == 0 {
                    awardOneCoin()
                }
            }
        }
    }
    
    private func awardOneCoin() {
        coins += 1
        saveCoinData()
        withAnimation {
            coinAwardNotice = "Chúc mừng! Bạn đã hoàn thành 1 giờ tự học và nhận được 1 Xu!"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            withAnimation {
                coinAwardNotice = nil
            }
        }
    }
    
    private func stopStopwatch() {
        timer?.invalidate()
        timer = nil
    }
    
    private func togglePlayPause() {
        isRunning.toggle()
        if isRunning {
            if !ambientSound.isPlaying {
                ambientSound.startSound()
            }
        } else {
            ambientSound.stopSound()
        }
    }
    
    private func saveAndDismiss() {
        stopStopwatch()
        ambientSound.stopSound()
        
        let earnedMinutes = max(1, elapsedSeconds / 60)
        appState.totalStudyMinutes += earnedMinutes
        appState.focusSessionCount += 1
        
        dismiss()
    }
    
    private func formatElapsedStopwatch(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
