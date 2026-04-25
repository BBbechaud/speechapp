import SwiftUI

/// Shown after the user ends a live practice session.
struct PracticeCompleteScreen: View {
    let onSeeConversationAnalysis: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: AppSpacing.xxxl)

            PracticeCompleteMascotView()
                .padding(.bottom, AppSpacing.xxl)

            Text("Practice Complete!")
                .font(AppFonts.display(28))
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Spacer(minLength: AppSpacing.xxxl)

            PrimaryButton(title: "See Conversation Analysis") {
                onSeeConversationAnalysis()
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.bottom, AppSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Mascot

private struct PracticeCompleteMascotView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(AppColors.mascotBackdrop)
                .frame(width: 220, height: 220)

            Image(systemName: "star.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColors.accent.opacity(0.85))
                .offset(x: -78, y: -62)
                .accessibilityHidden(true)

            Image(systemName: "sparkle")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(AppColors.accentMedium)
                .offset(x: 72, y: -58)
                .accessibilityHidden(true)

            MascotCharacterView()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Celebration mascot")
    }
}

private struct MascotCharacterView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(AppColors.accent)
                .frame(width: 112, height: 112)

            // Face
            HStack(spacing: 22) {
                Circle()
                    .fill(AppColors.textPrimary.opacity(0.9))
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(AppColors.textPrimary.opacity(0.9))
                    .frame(width: 8, height: 8)
            }
            .offset(y: -14)

            Ellipse()
                .trim(from: 0.5, to: 1.0)
                .stroke(AppColors.textPrimary.opacity(0.88), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 34, height: 18)
                .offset(y: 8)

            // Limbs
            Capsule()
                .fill(AppColors.accent)
                .frame(width: 12, height: 28)
                .offset(x: -52, y: 18)
                .rotationEffect(.degrees(-18))

            Capsule()
                .fill(AppColors.accent)
                .frame(width: 12, height: 28)
                .offset(x: 52, y: 18)
                .rotationEffect(.degrees(18))

            Capsule()
                .fill(AppColors.accent)
                .frame(width: 12, height: 32)
                .offset(x: -58, y: -8)
                .rotationEffect(.degrees(-125))

            Capsule()
                .fill(AppColors.accent)
                .frame(width: 12, height: 32)
                .offset(x: 58, y: -8)
                .rotationEffect(.degrees(35))
        }
    }
}

#Preview {
    NavigationStack {
        PracticeCompleteScreen(onSeeConversationAnalysis: {})
    }
}
