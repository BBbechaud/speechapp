import SwiftUI

/// Shown after the user ends a live practice session.
struct PracticeCompleteScreen: View {
    let onReviewFeedback: () -> Void

    @State private var appeared = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: AppColors.primarySubtle.opacity(0.5), location: 0),
                    .init(color: AppColors.background, location: 0.42),
                    .init(color: AppColors.background, location: 1),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: AppSpacing.xxl)

                PracticeCompleteMascotView(appeared: appeared, reduceMotion: reduceMotion)
                    .padding(.bottom, AppSpacing.xl)

                VStack(spacing: AppSpacing.md) {
                    Text("Practice complete")
                        .font(AppFonts.display(28))
                        .foregroundStyle(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .accessibilityAddTraits(.isHeader)

                    Text("You showed up and spoke out loud—that’s what builds confidence. See how you did and what to try next.")
                        .font(AppFonts.body(16))
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .padding(.horizontal, AppSpacing.lg)
                }
                .padding(.bottom, AppSpacing.lg)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)
                .animation(
                    reduceMotion ? .easeOut(duration: 0.22) : .spring(response: 0.48, dampingFraction: 0.82).delay(0.06),
                    value: appeared
                )

                Spacer(minLength: AppSpacing.xxl)

                PrimaryButton(title: "See Conversation Analysis") {
                    onReviewFeedback()
                }
                .padding(.horizontal, AppSpacing.base)
                .padding(.bottom, AppSpacing.xl)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 14)
                .animation(
                    reduceMotion ? .easeOut(duration: 0.22) : .spring(response: 0.48, dampingFraction: 0.82).delay(0.14),
                    value: appeared
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            appeared = true
        }
    }
}

// MARK: - Mascot

private struct PracticeCompleteMascotView: View {
    let appeared: Bool
    let reduceMotion: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            AppColors.surface.opacity(0.92),
                            AppColors.mascotBackdrop,
                        ],
                        center: .center,
                        startRadius: 24,
                        endRadius: 130
                    )
                )
                .frame(width: 244, height: 244)
                .subtleShadow()

            Circle()
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            AppColors.primaryMedium.opacity(0.9),
                            AppColors.primary.opacity(0.35),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
                .frame(width: 236, height: 236)

            Image(systemName: "star.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppColors.primary.opacity(0.88))
                .offset(x: -86, y: -68)
                .accessibilityHidden(true)

            Image(systemName: "sparkle")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppColors.primaryMedium)
                .offset(x: 80, y: -64)
                .accessibilityHidden(true)

            MascotCharacterView(appeared: appeared, reduceMotion: reduceMotion)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Celebration mascot")
        .opacity(appeared || reduceMotion ? 1 : 0)
        .offset(y: appeared || reduceMotion ? 0 : 18)
        .scaleEffect(appeared || reduceMotion ? 1 : 0.9)
        .animation(
            reduceMotion ? .easeOut(duration: 0.2) : .spring(response: 0.52, dampingFraction: 0.76),
            value: appeared
        )
    }
}

private struct MascotCharacterView: View {
    let appeared: Bool
    let reduceMotion: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(AppColors.primary)
                .frame(width: 112, height: 112)
                .subtleShadow()

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
                .fill(AppColors.primary)
                .frame(width: 12, height: 28)
                .offset(x: -52, y: 18)
                .rotationEffect(.degrees(-18))

            Capsule()
                .fill(AppColors.primary)
                .frame(width: 12, height: 28)
                .offset(x: 52, y: 18)
                .rotationEffect(.degrees(18))

            Capsule()
                .fill(AppColors.primary)
                .frame(width: 12, height: 32)
                .offset(x: -58, y: -8)
                .rotationEffect(.degrees(-125))

            Capsule()
                .fill(AppColors.primary)
                .frame(width: 12, height: 32)
                .offset(x: 58, y: -8)
                .rotationEffect(.degrees(35))
        }
        .rotationEffect(.degrees(characterWiggle))
        .animation(
            reduceMotion ? .default : .spring(response: 0.55, dampingFraction: 0.68).delay(0.12),
            value: appeared
        )
    }

    private var characterWiggle: Double {
        if reduceMotion { return 0 }
        return appeared ? 0 : -4
    }
}

#Preview {
    NavigationStack {
        PracticeCompleteScreen(onReviewFeedback: {})
    }
}
