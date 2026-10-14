import SwiftUI

struct IntroVideoView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0.0
    @State private var textOffset: CGFloat = 20
    @State private var textOpacity: Double = 0.0
    @State private var progressValue: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            // Full bleed emerald gradient background covering battery & notch
            LinearGradient(
                colors: [Color(hex: "#062E29"), Color(hex: "#0A4E46"), Color(hex: "#051D1A")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 28) {
                Spacer()
                
                // 3D Animated Logo
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryMint.opacity(0.15))
                        .frame(width: 170, height: 170)
                        .scaleEffect(logoScale * 1.1)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.primaryMint, Color(hex: "#10B981")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 130, height: 130)
                        .shadow(color: AppTheme.primaryMint.opacity(0.5), radius: 25, x: 0, y: 10)
                    
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.white)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                
                // Title & Slogan
                VStack(spacing: 10) {
                    Text("KhoaStudy")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(1.5)
                    
                    Text("HỌC TẬP THÔNG MINH • DEEPSEEK AI")
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundColor(AppTheme.primaryMint)
                        .tracking(2.0)
                    
                    Text("Bộ GD&ĐT Chuẩn SGK • Ôn Thi Toàn Diện")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.75))
                        .padding(.top, 4)
                }
                .offset(y: textOffset)
                .opacity(textOpacity)
                
                Spacer()
                
                // Bottom Loading Progress & Skip Button
                VStack(spacing: 16) {
                    // Thin Animated Progress Bar
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 200, height: 4)
                        
                        Capsule()
                            .fill(AppTheme.primaryMint)
                            .frame(width: 200 * progressValue, height: 4)
                    }
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            appState.completeIntro()
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text("Bắt Đầu Ngay")
                                .font(.system(size: 15, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(AppTheme.primaryDark)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(Capsule().fill(AppTheme.primaryMint))
                        .shadow(color: AppTheme.primaryMint.opacity(0.4), radius: 10, x: 0, y: 4)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            // Intro animation timeline
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
                textOffset = 0
                textOpacity = 1.0
            }
            
            withAnimation(.linear(duration: 2.5)) {
                progressValue = 1.0
            }
            
            // Auto transition after 3.2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
                if !appState.hasSeenIntro {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        appState.completeIntro()
                    }
                }
            }
        }
    }
}
