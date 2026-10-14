import SwiftUI

// MARK: - App Color Palette (Inspired by Video Reference)
struct AppTheme {
    // Primary Teals & Emeralds
    static let primaryDark = Color(hex: "#0A3E39")       // Dark forest teal (headers, active tabs)
    static let primary = Color(hex: "#107B6E")           // Classic emerald
    static let primaryMint = Color(hex: "#2CC58A")       // Vibrant mint green (buttons, badges)
    static let primaryLight = Color(hex: "#E8F8F2")      // Soft mint pastel background
    
    // Backgrounds
    static let background = Color(hex: "#F7FAF8")        // Light off-white canvas
    static let cardBackground = Color.white              // Pure white cards
    static let secondaryBg = Color(hex: "#F1F5F3")       // Subtle gray-green container
    
    // Pastel Accent Categories
    static let pastelOrange = Color(hex: "#FFF4ED")
    static let accentOrange = Color(hex: "#F97316")
    static let pastelPurple = Color(hex: "#F3E8FF")
    static let accentPurple = Color(hex: "#9333EA")
    static let pastelBlue = Color(hex: "#E0F2FE")
    static let accentBlue = Color(hex: "#0284C7")
    static let pastelYellow = Color(hex: "#FEF9C3")
    static let accentYellow = Color(hex: "#CA8A04")
    
    // Texts
    static let textPrimary = Color(hex: "#0F2E2A")
    static let textSecondary = Color(hex: "#627B77")
    static let textMuted = Color(hex: "#9EADA9")
    
    // Shadows
    static func softShadow<Content: View>(_ content: Content) -> some View {
        content.shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 5)
    }
}

// MARK: - View Modifiers
struct CleanCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 22
    var padding: CGFloat = 16
    var backgroundColor: Color = AppTheme.cardBackground
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(backgroundColor)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
    }
}

extension View {
    func cleanCard(cornerRadius: CGFloat = 22, padding: CGFloat = 16, bg: Color = AppTheme.cardBackground) -> some View {
        self.modifier(CleanCardModifier(cornerRadius: cornerRadius, padding: padding, backgroundColor: bg))
    }
}

// MARK: - Color Hex Initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
