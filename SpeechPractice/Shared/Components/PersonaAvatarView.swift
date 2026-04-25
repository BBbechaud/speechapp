import SwiftUI

/// Placeholder persona avatar. Replace with real images when assets are ready.
struct PersonaAvatarView: View {
    let name: String
    let size: CGFloat

    private var initials: String {
        let parts = name.split(separator: " ")
        return parts.prefix(2).compactMap { $0.first }.map(String.init).joined()
    }

    private var backgroundColor: Color {
        // Deterministic color from name
        let colors: [Color] = [
            Color(hex: "#F4E0D0"),
            Color(hex: "#D0E8F4"),
            Color(hex: "#D0F4E4"),
            Color(hex: "#F4D0E8"),
            Color(hex: "#E8F4D0"),
            Color(hex: "#E0D0F4"),
        ]
        let index = abs(name.hashValue) % colors.count
        return colors[index]
    }

    private var foregroundColor: Color {
        AppColors.textSecondary
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)

            Text(initials)
                .font(.system(size: size * 0.35, weight: .semibold, design: .rounded))
                .foregroundStyle(foregroundColor)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    HStack(spacing: 12) {
        PersonaAvatarView(name: "Sarah", size: 64)
        PersonaAvatarView(name: "David", size: 64)
        PersonaAvatarView(name: "Chloe", size: 64)
        PersonaAvatarView(name: "Victor", size: 64)
    }
    .padding()
}
