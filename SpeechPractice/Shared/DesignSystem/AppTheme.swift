import SwiftUI

// MARK: - Color Palette

enum AppColors {
    // Accent
    static let accent        = Color(hex: "#E8632A")
    static let accentSubtle  = Color(hex: "#FFF0E8")
    static let accentMedium  = Color(hex: "#FFDCC8")

    // Backgrounds
    static let background    = Color(hex: "#F2F2F7") // iOS system grouped
    static let surface       = Color.white
    static let surfaceRaised = Color(hex: "#F9F9F9")
    /// Soft halo behind practice-complete mascot (warm peach).
    static let mascotBackdrop = Color(hex: "#FCE8DE")

    // Text
    static let textPrimary   = Color(hex: "#1A1A1A")
    static let textSecondary = Color(hex: "#666666")
    static let textTertiary  = Color(hex: "#9A9A9A")

    // Difficulty
    static let easyFg        = Color(hex: "#27AE60")
    static let easyBg        = Color(hex: "#E8F8EF")
    static let mediumFg      = Color(hex: "#E8632A")
    static let mediumBg      = Color(hex: "#FFF0E8")
    static let hardFg        = Color(hex: "#D93025")
    static let hardBg        = Color(hex: "#FDE8E7")

    // UI
    static let separator     = Color(hex: "#E8E8E8")
    static let tabInactive   = Color(hex: "#9E9E9E")
}

// MARK: - Typography

enum AppFonts {
    static func display(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func title(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func label(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

// MARK: - Spacing

enum AppSpacing {
    static let xs:   CGFloat = 4
    static let sm:   CGFloat = 8
    static let md:   CGFloat = 12
    static let base: CGFloat = 16
    static let lg:   CGFloat = 20
    static let xl:   CGFloat = 24
    static let xxl:  CGFloat = 32
    static let xxxl: CGFloat = 48
}

// MARK: - Corner Radii

enum AppRadius {
    static let sm:   CGFloat = 8
    static let md:   CGFloat = 12
    static let lg:   CGFloat = 16
    static let xl:   CGFloat = 20
    static let xxl:  CGFloat = 28
    static let pill: CGFloat = 999
}

// MARK: - Shadows

extension View {
    func cardShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
            .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
    }

    func subtleShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Press Feedback

struct PressScaleModifier: ViewModifier {
    @State private var isPressed = false
    let scale: CGFloat

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

extension View {
    func pressScale(_ scale: CGFloat = 0.97) -> some View {
        modifier(PressScaleModifier(scale: scale))
    }
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 200, 200, 200)
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
