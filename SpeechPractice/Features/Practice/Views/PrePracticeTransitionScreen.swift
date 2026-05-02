import SwiftUI
import UIKit

/// Full-screen modal-feel bridge between the primer and the live practice session.
/// Plays a brief breathe phase, then a 3 → 2 → 1 countdown, then advances to `.session`.
struct PrePracticeTransitionScreen: View {
    @Bindable var viewModel: PracticeFlowViewModel
    @State private var transitionViewModel = PrePracticeTransitionViewModel()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            phaseContent
                .padding(.horizontal, AppSpacing.xl)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.easeInOut(duration: 0.3), value: transitionViewModel.phase)
        }
        .background(SwipeBackLocker())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            transitionViewModel.start { [viewModel] in
                viewModel.completePrePracticeTransition()
            }
        }
        .onDisappear {
            transitionViewModel.cancel()
        }
    }

    // MARK: - Phase routing

    @ViewBuilder
    private var phaseContent: some View {
        switch transitionViewModel.phase {
        case .breathe:
            BreathePhaseView(
                duration: transitionViewModel.breatheDuration,
                reduceMotion: reduceMotion
            )
            .transition(phaseTransition)
            .id("breathe")

        case .countdown(let step):
            CountdownPhaseView(
                step: step,
                caption: transitionViewModel.countdownCaption(for: step),
                reduceMotion: reduceMotion
            )
            .transition(phaseTransition)
            .id("countdown-\(step)")
        }
    }

    private var phaseTransition: AnyTransition {
        if reduceMotion {
            return .opacity
        }

        return .asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.92)),
            removal: .opacity
        )
    }
}

// MARK: - Breathe phase

private struct BreathePhaseView: View {
    let duration: TimeInterval
    let reduceMotion: Bool

    @State private var fillProgress: CGFloat = 0
    @State private var pulse: Bool = false

    var body: some View {
        VStack(spacing: AppSpacing.xxl) {
            Spacer(minLength: 0)

            TransitionMascotView(
                style: .calm,
                pulse: pulse && !reduceMotion
            )

            VStack(spacing: AppSpacing.sm) {
                Text("Take a breath.")
                    .font(AppFonts.display(32))
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)

                Text("Center yourself before we begin.")
                    .font(AppFonts.body(15))
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .padding(.horizontal, AppSpacing.lg)
            }

            BreatheProgressBar(progress: fillProgress)
                .frame(width: 96)

            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Take a breath. Center yourself before we begin.")
        .accessibilityValue("Practice starts in a moment")
        .onAppear {
            withAnimation(.linear(duration: duration)) {
                fillProgress = 1
            }
            if !reduceMotion {
                withAnimation(.easeInOut(duration: duration / 2).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
        }
    }
}

private struct BreatheProgressBar: View {
    let progress: CGFloat

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(AppColors.primarySubtle)

            Capsule()
                .fill(AppColors.primary)
                .scaleEffect(x: max(0.0001, progress), y: 1, anchor: .leading)
        }
        .frame(height: 4)
        .accessibilityHidden(true)
    }
}

// MARK: - Countdown phase

private struct CountdownPhaseView: View {
    let step: Int
    let caption: String
    let reduceMotion: Bool

    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer(minLength: 0)

            TransitionMascotView(style: .energetic, pulse: false)

            VStack(spacing: AppSpacing.md) {
                Text("\(step)")
                    .font(AppFonts.display(96, weight: .bold))
                    .foregroundStyle(AppColors.primary)
                    .monospacedDigit()
                    .accessibilityLabel("\(step)")

                Text(caption.uppercased())
                    .font(AppFonts.label(12, weight: .bold))
                    .tracking(1.4)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - Mascot placeholder

/// Placeholder mascot until real persona art ships. Two visual states match the
/// breathe/countdown phases without growing the asset catalog.
private struct TransitionMascotView: View {
    enum Style { case calm, energetic }

    let style: Style
    let pulse: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(AppColors.mascotBackdrop)
                .frame(width: 168, height: 168)
                .scaleEffect(pulse ? 1.04 : 1.0)
                .opacity(pulse ? 0.95 : 1.0)

            Circle()
                .fill(AppColors.primary)
                .frame(width: 96, height: 96)
                .subtleShadow()

            face
        }
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var face: some View {
        switch style {
        case .calm:
            calmFace
        case .energetic:
            energeticFace
        }
    }

    private var calmFace: some View {
        ZStack {
            HStack(spacing: 18) {
                ClosedEye()
                ClosedEye()
            }
            .offset(y: -6)

            Capsule()
                .fill(AppColors.textPrimary.opacity(0.85))
                .frame(width: 14, height: 3)
                .offset(y: 14)
        }
    }

    private var energeticFace: some View {
        ZStack {
            HStack(spacing: 18) {
                Circle()
                    .fill(AppColors.textPrimary.opacity(0.9))
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(AppColors.textPrimary.opacity(0.9))
                    .frame(width: 8, height: 8)
            }
            .offset(y: -8)

            Ellipse()
                .trim(from: 0.5, to: 1.0)
                .stroke(
                    AppColors.textPrimary.opacity(0.88),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .frame(width: 28, height: 14)
                .offset(y: 10)
        }
    }
}

private struct ClosedEye: View {
    var body: some View {
        Capsule()
            .stroke(
                AppColors.textPrimary.opacity(0.85),
                style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
            )
            .frame(width: 14, height: 4)
    }
}

// MARK: - Swipe-back locker

/// Disables the interactive pop gesture while the transition screen is on screen so the
/// countdown cannot be cancelled mid-flight by an accidental edge swipe.
private struct SwipeBackLocker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        SwipeBackLockerHost()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

private final class SwipeBackLockerHost: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

#Preview("Pre-practice transition") {
    NavigationStack {
        PrePracticeTransitionScreen(
            viewModel: {
                let vm = PracticeFlowViewModel()
                vm.selectedScenario = Scenario.all[2]
                vm.selectedPersona = Persona.all[0]
                return vm
            }()
        )
    }
}
