import SwiftUI
import AVFoundation

/// Treo Máy Học Tập - Chế độ tập trung cao độ (Zen Focus Mode)
/// Đặc điểm:
/// 1. Ảnh nền đêm sao huyền ảo, trăng vàng tỏa sáng và các vì sao lấp lánh
/// 2. Đồng hồ đếm TĂNG DẦN (Count-up stopwatch: 00:00:00 -> ...)
/// 3. Bật chế độ im lặng (Tắt chuông báo, giữ sáng màn hình không tắt)
/// 4. Phát âm thanh thật sự (Sóng biển đêm 🌊, Mưa rơi chill 🌧️, Đêm sao 🌌) có thể tắt/bật âm lượng
struct FocusLockView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @ObservedObject private var ambientSound = AmbientSoundService.shared
    
    // Stopwatch State (Đếm tăng dần)
    @State private var elapsedSeconds: Int = 0
    @State private var isRunning: Bool = true
    @State private var timer: Timer? = nil
    
    // Starry Night Animation State
    @State private var starPulse: Bool = false
    @State private var showingExitAlert: Bool = false
    
    // Inspirational quotes
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
                // Top Navigation Bar & Silence Status
                topNavigationBar
                
                Spacer()
                
                // Big Circular Animated Count-up Stopwatch
                circularStopwatchSection
                
                Spacer()
                
                // Inspirational Study Quote
                quoteSection
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                
                // Ambient Sound Controller (Sóng biển, mưa rơi, đêm sao)
                ambientSoundCard
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
            }
        }
        .onAppear {
            startStopwatch()
            ambientSound.startSound()
            // Giữ màn hình luôn sáng trong lúc treo máy học
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            stopStopwatch()
            ambientSound.stopSound()
            // Khôi phục tự động tắt màn hình
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
    
    // MARK: - 1. Starry Night Sky Background (Nền trời đêm sao & Trăng vàng)
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
                            .font(.system(size: 34))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "#FEF9C3"), Color(hex: "#FACC15")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color(hex: "#FEF08A").opacity(0.6), radius: 10, x: 0, y: 0)
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 28)
                }
                Spacer()
            }
            .ignoresSafeArea()
            
            // 35 Procedural Twinkling Stars
            GeometryReader { geo in
                ForEach(0..<35, id: \.self) { i in
                    let x = CGFloat(abs(sin(Double(i) * 123.45))) * geo.size.width
                    let y = CGFloat(abs(cos(Double(i) * 678.90))) * (geo.size.height * 0.75)
                    let size = CGFloat(2.0 + (Double(i % 3) * 1.5))
                    let isSparkle = (i % 7 == 0)
                    
                    if isSparkle {
                        Image(systemName: "sparkle")
                            .font(.system(size: 10))
                            .foregroundColor(Color.white.opacity(starPulse ? 0.9 : 0.25))
                            .position(x: x, y: y)
                            .animation(.easeInOut(duration: 1.5 + Double(i % 4) * 0.4).repeatForever(autoreverses: true), value: starPulse)
                    } else {
                        Circle()
                            .fill(Color.white.opacity(starPulse ? Double(0.4 + (Double(i % 5) * 0.12)) : 0.2))
                            .frame(width: size, height: size)
                            .position(x: x, y: y)
                            .animation(.easeInOut(duration: 1.2 + Double(i % 3) * 0.5).repeatForever(autoreverses: true), value: starPulse)
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                starPulse = true
            }
        }
    }
    
    // MARK: - 2. Top Navigation Bar & Silence Status Pill
    private var topNavigationBar: some View {
        HStack {
            Button(action: {
                if elapsedSeconds > 30 {
                    showingExitAlert = true
                } else {
                    dismiss()
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(Color.white.opacity(0.12)))
            }
            
            Spacer()
            
            // Silence & Do Not Disturb Pill
            HStack(spacing: 6) {
                Image(systemName: "bell.slash.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#34D399"))
                Text("Chế Độ Im Lặng Đang Bật")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(Capsule().fill(Color.black.opacity(0.35)))
            .overlay(Capsule().stroke(Color(hex: "#34D399").opacity(0.4), lineWidth: 1))
            
            Spacer()
            
            // Done & Save Button
            Button(action: {
                saveAndDismiss()
            }) {
                Text("LƯU")
                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(hex: "#059669"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color(hex: "#D1FAE5")))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
    }
    
    // MARK: - 3. Circular Count-up Stopwatch (ĐỒNG HỒ ĐẾM TĂNG DẦN)
    private var circularStopwatchSection: some View {
        ZStack {
            // Outer Ambient Glow
            Circle()
                .fill(Color(hex: "#059669").opacity(0.08))
                .frame(width: 270, height: 270)
                .blur(radius: 20)
            
            // Background Track
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: 14)
                .frame(width: 240, height: 240)
            
            // Dynamic Rotating Ring that pulses with time
            let rotationAngle = Double(elapsedSeconds % 60) * 6.0
            Circle()
                .trim(from: 0.0, to: 0.35)
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "#10B981"), Color(hex: "#06B6D4")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .frame(width: 240, height: 240)
                .rotationEffect(.degrees(rotationAngle))
                .animation(.linear(duration: 1.0), value: elapsedSeconds)
            
            VStack(spacing: 8) {
                // Glowing Pulse Dot
                HStack(spacing: 6) {
                    Circle()
                        .fill(isRunning ? Color(hex: "#34D399") : Color(hex: "#FACC15"))
                        .frame(width: 8, height: 8)
                        .shadow(color: Color(hex: "#34D399"), radius: 4)
                    
                    Text(isRunning ? "ĐANG TẬP TRUNG HỌC" : "ĐANG TẠM DỪNG")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.75))
                        .tracking(1.2)
                }
                
                // Formatted Count-Up Stopwatch (HH:MM:SS or MM:SS)
                Text(formatElapsedStopwatch(elapsedSeconds))
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .shadow(color: Color.black.opacity(0.5), radius: 6, x: 0, y: 3)
                
                // Play / Pause Button
                Button(action: {
                    togglePlayPause()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                            .font(.system(size: 12, weight: .bold))
                        Text(isRunning ? "Tạm dừng" : "Tiếp tục học")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(Color.white.opacity(0.9))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Capsule().fill(Color.white.opacity(0.12)))
                }
                .padding(.top, 4)
            }
        }
    }
    
    // MARK: - 4. Quote Section
    private var quoteSection: some View {
        VStack(spacing: 4) {
            Image(systemName: "sparkles")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Color(hex: "#FCD34D"))
            
            Text(quotes[currentQuoteIndex])
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(Color.white.opacity(0.85))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
    }
    
    // MARK: - 5. Ambient Sound Controller (ÂM THANH THẬT SỰ)
    private var ambientSoundCard: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: ambientSound.soundIcons[ambientSound.selectedSoundIndex])
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(hex: "#34D399"))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ambientSound.soundNames[ambientSound.selectedSoundIndex])
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        Text(ambientSound.isMuted ? "Đã tắt âm thanh" : "Âm thanh thật đang phát mượt mà")
                            .font(.caption2)
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                }
                
                Spacer()
                
                // Mute / Unmute Button
                Button(action: {
                    ambientSound.toggleMute()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.12))
                            .frame(width: 38, height: 38)
                        
                        Image(systemName: ambientSound.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(ambientSound.isMuted ? Color.gray : Color(hex: "#34D399"))
                    }
                }
            }
            
            // Selector 3 Sound Chips
            HStack(spacing: 8) {
                soundSelectorChip(title: "🌊 Sóng Biển", index: 0)
                soundSelectorChip(title: "🌧️ Mưa Rơi", index: 1)
                soundSelectorChip(title: "🌌 Đêm Sao", index: 2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        )
    }
    
    private func soundSelectorChip(title: String, index: Int) -> some View {
        let isSelected = (ambientSound.selectedSoundIndex == index)
        return Button(action: {
            ambientSound.startSound(soundIndex: index)
        }) {
            Text(title)
                .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? .white : Color.white.opacity(0.65))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(hex: "#059669") : Color.white.opacity(0.08))
                )
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Logic Helpers
    private func startStopwatch() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if isRunning {
                elapsedSeconds += 1
                if elapsedSeconds % 60 == 0 {
                    currentQuoteIndex = (currentQuoteIndex + 1) % quotes.count
                }
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
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
