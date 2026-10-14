import SwiftUI

struct IntroVideoView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var textOpacity: Double = 0.0
    @State private var textScale: CGFloat = 0.92
    
    var body: some View {
        ZStack {
            // Pure white edge-to-edge background
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 8) {
                // "Shimy" logo with modern typography and gentle subtle gradient
                Text("Shimy")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "#0F172A"), Color(hex: "#334155")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .tracking(2.5)
                    .scaleEffect(textScale)
                    .opacity(textOpacity)
            }
        }
        .onAppear {
            // Smooth fade-in over 0.8s
            withAnimation(.easeOut(duration: 0.8)) {
                textOpacity = 1.0
                textScale = 1.0
            }
            
            // Auto-advance after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    appState.completeIntro()
                }
            }
        }
    }
}
