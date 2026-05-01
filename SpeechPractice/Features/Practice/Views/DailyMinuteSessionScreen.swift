import SwiftUI

struct DailyMinuteSessionScreen: View {
    @Bindable var viewModel: PracticeFlowViewModel
    let prompt: DailyMinutePrompt

    @Environment(\.dismiss) private var dismiss
    @State private var remainingSeconds: Int = Self.durationSeconds
    @State private var hasCompleted = false

    private static let durationSeconds = 60
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var progress: CGFloat {
        CGFloat(remainingSeconds) / CGFloat(Self.durationSeconds)
    }

    private var formattedTime: String {
        "0:\(String(format: "%02d", remainingSeconds))"
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar

            Spacer(minLength: AppSpacing.lg)

            VStack(spacing: AppSpacing.xl) {
                timerRing

                promptCard

                focusRow
            }
            .padding(.horizontal, AppSpacing.xl)

            Spacer(minLength: AppSpacing.lg)

            endButton
                .padding(.horizontal, AppSpacing.base)
                .padding(.bottom, AppSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.surface)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            remainingSeconds = Self.durationSeconds
            hasCompleted = false
        }
        .onReceive(timer) { _ in
            tick()
        }
    }

    private var topBar: some View {
        HStack(spacing: AppSpacing.md) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(AppColors.surfaceRaised, in: Circle())
            }
            .buttonStyle(PressButtonStyle())
            .accessibilityLabel("Back")

            Spacer()

            HStack(spacing: AppSpacing.sm) {
                Circle()
                    .fill(AppColors.primary)
                    .frame(width: 6, height: 6)
                    .accessibilityHidden(true)

                Text("DAILY MINUTE")
                    .font(AppFonts.label(11, weight: .semibold))
                    .foregroundStyle(AppColors.primary)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(AppColors.primarySubtle, in: Capsule())

            Spacer()

            Color.clear
                .frame(width: 40, height: 40)
                .accessibilityHidden(true)
        }
        .padding(.horizontal, AppSpacing.base)
        .padding(.top, AppSpacing.sm)
    }

    private var timerRing: some View {
        ZStack {
            Circle()
                .stroke(AppColors.primarySubtle, lineWidth: 14)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AppColors.primary,
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.35, dampingFraction: 0.86), value: remainingSeconds)

            VStack(spacing: AppSpacing.xs) {
                Text(formattedTime)
                    .font(AppFonts.display(50, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .monospacedDigit()

                Text("Speak clearly")
                    .font(AppFonts.label(13, weight: .bold))
                    .foregroundStyle(AppColors.primary)
            }
        }
        .frame(width: 210, height: 210)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(remainingSeconds) seconds remaining")
        .accessibilityAddTraits(.updatesFrequently)
    }

    private var promptCard: some View {
        VStack(spacing: AppSpacing.md) {
            Label {
                Text(prompt.category)
                    .font(AppFonts.label(12, weight: .bold))
            } icon: {
                Image(systemName: prompt.sfSymbol)
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundStyle(AppColors.primary)

            Text(prompt.title)
                .font(AppFonts.display(28, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text(prompt.prompt)
                .font(AppFonts.body(17, weight: .medium))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .fill(AppColors.primarySubtle)
        }
    }

    private var focusRow: some View {
        HStack(spacing: AppSpacing.md) {
            FocusPill(symbolName: "pause.fill", title: "Pause")
            FocusPill(symbolName: "textformat", title: "No filler")
            FocusPill(symbolName: "target", title: "One point")
        }
        .frame(maxWidth: .infinity)
    }

    private var endButton: some View {
        Button {
            finishSession()
        } label: {
            HStack(spacing: AppSpacing.md) {
                MinuteStopGlyphView()
                    .accessibilityHidden(true)

                Text("End Minute")
                    .font(AppFonts.label(17, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(AppColors.textPrimary, in: RoundedRectangle(cornerRadius: AppRadius.xxl))
        }
        .buttonStyle(PressButtonStyle())
        .accessibilityLabel("End minute")
        .accessibilityHint("Completes the daily minute and opens practice complete")
    }

    private func tick() {
        guard !hasCompleted else { return }

        if remainingSeconds > 1 {
            remainingSeconds -= 1
        } else {
            remainingSeconds = 0
            finishSession()
        }
    }

    private func finishSession() {
        guard !hasCompleted else { return }

        hasCompleted = true
        viewModel.completeDailyMinute()
    }
}

private struct FocusPill: View {
    let symbolName: String
    let title: String

    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            Image(systemName: symbolName)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(AppColors.primary)
                .frame(width: 28, height: 28)
                .background(AppColors.primarySubtle, in: Circle())
                .accessibilityHidden(true)

            Text(title)
                .font(AppFonts.label(12, weight: .bold))
                .foregroundStyle(AppColors.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

private struct MinuteStopGlyphView: View {
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(AppColors.primary, lineWidth: 2)
                .frame(width: 24, height: 24)

            RoundedRectangle(cornerRadius: 2)
                .fill(AppColors.primary)
                .frame(width: 9, height: 9)
        }
    }
}

#Preview {
    NavigationStack {
        DailyMinuteSessionScreen(
            viewModel: PracticeFlowViewModel(),
            prompt: DailyMinutePrompt.all[0]
        )
    }
}
