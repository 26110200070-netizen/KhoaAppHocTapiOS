import SwiftUI

struct FocusLockView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    @State private var timeRemaining: Int = 25 * 60 // 25 minutes default
    @State private var isRunning: Bool = true
    @State private var selectedAmbientSound: String = "Tiếng Mưa Êm"
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let ambientSounds = ["Tiếng Mưa Êm", "Sóng Biển", "Thư Viện Yên Tĩnh", "Tiếng Gió Rừng"]
    
    var body: some View {
        ZStack {
            // Background Canvas (Matching the video's top map area style)
            Color(hex: "#EDF3F1").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Navigation Bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                            .padding(12)
                            .background(Circle().fill(Color.white))
                            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                    }
                    Spacer()
                    Text("Treo Máy Tự Học")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    // Dummy space for symmetry
                    Circle().fill(Color.clear).frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                
                Spacer()
                
                // Big Circular Animated Progress Timer (Claymorphic / Clean Card Style)
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.7), lineWidth: 16)
                        .frame(width: 230, height: 230)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(25 * 60))
                        .stroke(
                            LinearGradient(colors: [AppTheme.primaryMint, AppTheme.primary], startPoint: .topLeading, endPoint: .bottomTrailing),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )
                        .frame(width: 230, height: 230)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear, value: timeRemaining)
                    
                    VStack(spacing: 6) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 30))
                            .foregroundColor(AppTheme.primaryMint)
                        
                        Text(formatTime(timeRemaining))
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.textPrimary)
                        
                        Text("KHÓA MÁY TẬP TRUNG")
                            .font(.system(size: 11, weight: .heavy))
                            .foregroundColor(AppTheme.primary)
                    }
                }
                .shadow(color: Color.black.opacity(0.06), radius: 15, x: 0, y: 6)
                
                Spacer()
                
                // Bottom Dark Card (MATCHING THE VIDEO'S TRACK ORDER BOTTOM SHEET EXACTLY)
                bottomTrackingSheet
            }
        }
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
            } else if timeRemaining == 0 {
                isRunning = false
                appState.totalStudyMinutes += 25
                appState.focusSessionCount += 1
            }
        }
    }
    
    // MARK: - Dark Teal Bottom Card (Exact Replica of Video Style)
    private var bottomTrackingSheet: some View {
        VStack(spacing: 20) {
            // Handle bar
            Capsule()
                .fill(Color.white.opacity(0.2))
                .frame(width: 44, height: 5)
                .padding(.top, 12)
            
            // Session Info Row 1
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryMint.opacity(0.25))
                        .frame(width: 44, height: 44)
                    Image(systemName: "timer")
                        .font(.title3)
                        .foregroundColor(AppTheme.primaryMint)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("Thời Gian Tự Học Hôm Nay")
                        .font(.caption)
                        .foregroundColor(Color.white.opacity(0.7))
                    Text("\(appState.totalStudyMinutes) Phút (Chuỗi 5 phiên)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Sound Toggle Pill
                Button(action: {
                    // Switch ambient sound
                    if let idx = ambientSounds.firstIndex(of: selectedAmbientSound) {
                        selectedAmbientSound = ambientSounds[(idx + 1) % ambientSounds.count]
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "headphones")
                        Text(selectedAmbientSound)
                    }
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.primaryMint)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.white.opacity(0.12)))
                }
            }
            .padding(.horizontal, 24)
            
            // Session Info Row 2
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryMint.opacity(0.25))
                        .frame(width: 44, height: 44)
                    Image(systemName: "bell.slash.fill")
                        .font(.title3)
                        .foregroundColor(AppTheme.primaryMint)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("Trạng Thái Thiết Bị")
                        .font(.caption)
                        .foregroundColor(Color.white.opacity(0.7))
                    Text("Đã chặn thông báo & Không dùng mạng xã hội")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // Action Button (Start / Pause / Finish)
            Button(action: {
                withAnimation { isRunning.toggle() }
            }) {
                HStack {
                    Spacer()
                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                    Text(isRunning ? "Tạm Dừng Khóa Máy" : "Tiếp Tục Tự Học")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                .foregroundColor(AppTheme.primaryDark)
                .padding(.vertical, 16)
                .background(
                    Capsule().fill(AppTheme.primaryMint)
                )
                .shadow(color: AppTheme.primaryMint.opacity(0.4), radius: 10, x: 0, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color(hex: "#09332D")) // Dark emerald teal matching video
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: -6)
        )
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
