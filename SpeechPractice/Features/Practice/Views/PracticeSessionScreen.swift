import SwiftUI

/// Live scenario practice: persona image, listen/speak state, waveform, end control.
struct PracticeSessionScreen: View {
    @Bindable var viewModel: PracticeFlowViewModel

    private var persona: Persona { viewModel.selectedPersona ?? Persona.all[0] }

    var body: some View {
        VStack(spacing: 0) {
            topChrome

            Spacer(minLength: AppSpacing.lg)

            mainSection

            Spacer(minLength: AppSpacing.lg)

            endPracticeButton
                .padding(.horizontal, AppSpacing.base)
                .padding(.bottom, AppSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.surface)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Top

    private var topChrome: some View {
        HStack(spacing: AppSpacing.md) {
            Button {
                viewModel.leaveSession()
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

            sessionStatusPill

            Spacer()

            Color.clear
                .frame(width: 40, height: 40)
                .accessibilityHidden(true)
        }
        .padding(.horizontal, AppSpacing.base)
        .padding(.top, AppSpacing.sm)
    }

    private var sessionStatusPill: some View {
        let phase = viewModel.personaSessionPhase
        let title = phase == .listening ? "LISTENING" : "SPEAKING"

        return HStack(spacing: AppSpacing.sm) {
            Circle()
                .fill(AppColors.accent)
                .frame(width: 6, height: 6)
                .accessibilityHidden(true)

            Text(title)
                .font(AppFonts.label(11, weight: .semibold))
                .foregroundStyle(AppColors.accent)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.accentSubtle, in: Capsule())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title.lowercased().capitalized)
    }

    // MARK: - Main

    private var mainSection: some View {
        let phase = viewModel.personaSessionPhase
        let statusLine = "\(persona.name) is \(phase == .listening ? "listening" : "speaking")..."

        return VStack(spacing: AppSpacing.lg) {
            PersonaAvatarView(name: persona.name, size: 200)
                .accessibilityLabel("\(persona.name), practice partner")

            SessionAudioWaveBars(isAnimating: phase == .speaking)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(phase == .speaking ? "Voice activity" : "Waiting, waveform still")

            Text(statusLine)
                .font(AppFonts.title(20, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.updatesFrequently)
        }
        .padding(.horizontal, AppSpacing.xl)
    }

    // MARK: - End

    private var endPracticeButton: some View {
        Button {
            viewModel.endPracticeFromSession()
        } label: {
            HStack(spacing: AppSpacing.md) {
                StopGlyphView()
                    .accessibilityHidden(true)

                Text("End Practice")
                    .font(AppFonts.label(17, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(AppColors.textPrimary, in: RoundedRectangle(cornerRadius: AppRadius.xxl))
        }
        .buttonStyle(PressButtonStyle())
        .accessibilityLabel("End practice")
        .accessibilityHint("Returns to scenario list")
    }
}

// MARK: - Stop icon (circle + square)

private struct StopGlyphView: View {
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(AppColors.accent, lineWidth: 2)
                .frame(width: 24, height: 24)

            RoundedRectangle(cornerRadius: 2)
                .fill(AppColors.accent)
                .frame(width: 9, height: 9)
        }
    }
}

// MARK: - Wave bars

private struct SessionAudioWaveBars: View {
    let isAnimating: Bool

    private static let restRatios: [CGFloat] = [0.42, 0.62, 0.78, 0.55, 0.48]
    private static let phases: [CGFloat] = [0, 1.1, 0.4, 1.7, 0.85]

    var body: some View {
        let maxBarHeight: CGFloat = 28
        let barWidth: CGFloat = 4

        Group {
            if isAnimating {
                TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: false)) { context in
                    let t = context.date.timeIntervalSinceReferenceDate
                    HStack(alignment: .bottom, spacing: AppSpacing.sm) {
                        ForEach(0..<5, id: \.self) { index in
                            let base = Self.restRatios[index]
                            let wobble = 0.22 * sin(t * 5.5 + Self.phases[index])
                            let height = maxBarHeight * min(1, max(0.28, base + wobble))
                            barView(width: barWidth, height: height)
                        }
                    }
                }
            } else {
                HStack(alignment: .bottom, spacing: AppSpacing.sm) {
                    ForEach(0..<5, id: \.self) { index in
                        let height = maxBarHeight * Self.restRatios[index]
                        barView(width: barWidth, height: height)
                    }
                }
            }
        }
        .frame(height: maxBarHeight)
    }

    private func barView(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(AppColors.accent.opacity(0.85))
            .frame(width: width, height: height)
    }
}

#Preview("Listening") {
    NavigationStack {
        PracticeSessionScreen(
            viewModel: {
                let vm = PracticeFlowViewModel()
                vm.selectedScenario = Scenario.all[2]
                vm.selectedPersona = Persona.all[0]
                vm.personaSessionPhase = .listening
                return vm
            }()
        )
    }
}

#Preview("Speaking") {
    NavigationStack {
        PracticeSessionScreen(
            viewModel: {
                let vm = PracticeFlowViewModel()
                vm.selectedScenario = Scenario.all[2]
                vm.selectedPersona = Persona.all[0]
                vm.personaSessionPhase = .speaking
                return vm
            }()
        )
    }
}
