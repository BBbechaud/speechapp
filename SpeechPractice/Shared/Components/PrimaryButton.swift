import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.pill)
                    .fill(AppColors.primary)

                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.9)
                } else {
                    Text(title)
                        .font(AppFonts.label(17, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, AppSpacing.xl)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
        }
        .buttonStyle(PressButtonStyle())
    }
}

struct PressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(
                .spring(response: 0.2, dampingFraction: 0.7),
                value: configuration.isPressed
            )
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Continue to Prep") {}
        PrimaryButton(title: "Start Practice", isLoading: true) {}
    }
    .padding(24)
    .background(AppColors.background)
}
