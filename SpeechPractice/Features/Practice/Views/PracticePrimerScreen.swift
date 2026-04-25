import SwiftUI

struct PracticePrimerScreen: View {
    @Bindable var viewModel: PracticeFlowViewModel
    @State private var appeared = false

    private var persona: Persona { viewModel.selectedPersona ?? Persona.all[0] }
    private var scenario: Scenario { viewModel.selectedScenario ?? Scenario.all[0] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                personaHero
                    .opacity(appeared ? 1 : 0)
                    .animation(.spring(response: 0.45, dampingFraction: 0.85).delay(0.05), value: appeared)

                headlineSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.1), value: appeared)

                tipsSection
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, 120)
        }
        .background(AppColors.background)
        .navigationTitle("Practice Primer")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            startButton
        }
        .onAppear {
            appeared = true
        }
    }

    // MARK: - Persona Hero

    private var personaHero: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .fill(AppColors.surfaceRaised)
                .frame(maxWidth: .infinity)
                .frame(height: 220)

            VStack(spacing: AppSpacing.md) {
                PersonaAvatarView(name: persona.name, size: 96)
                    .overlay {
                        Circle()
                            .strokeBorder(AppColors.accentMedium, lineWidth: 2)
                    }
                    .scaleEffect(appeared ? 1 : 0.85)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.08), value: appeared)

                DifficultyBadge(difficulty: persona.difficulty)
            }
        }
    }

    // MARK: - Headline

    private var headlineSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Ready to practice with \(persona.name)?")
                .font(AppFonts.display(26))
                .foregroundStyle(AppColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            personaDescription
        }
    }

    private var personaDescription: some View {
        let parts = primerDescription(for: persona, scenario: scenario)

        return Group {
            Text(parts.prefix)
                .font(AppFonts.body(15))
                .foregroundStyle(AppColors.textSecondary)
            + Text(parts.highlight)
                .font(AppFonts.body(15, weight: .semibold))
                .foregroundStyle(AppColors.accent)
            + Text(parts.suffix)
                .font(AppFonts.body(15))
                .foregroundStyle(AppColors.textSecondary)
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Tips

    private var tipsSection: some View {
        VStack(spacing: AppSpacing.sm) {
            ForEach(Array(scenario.tips.enumerated()), id: \.element.id) { index, tip in
                TipCard(tip: tip)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(
                        .spring(response: 0.4, dampingFraction: 0.8)
                            .delay(0.18 + Double(index) * 0.07),
                        value: appeared
                    )
            }
        }
    }

    // MARK: - Start Button

    private var startButton: some View {
        VStack(spacing: 0) {
            Divider()
                .background(AppColors.separator)

            PrimaryButton(title: "Start Practice") {
                viewModel.startPractice()
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.lg)
        }
        .background(.ultraThinMaterial)
    }

    // MARK: - Dynamic Copy

    private func primerDescription(for persona: Persona, scenario: Scenario) -> (prefix: String, highlight: String, suffix: String) {
        switch persona.id.rawValue {
        case "sarah":
            return (
                "\(persona.name) is supportive, but she needs clear details to stay engaged. Focus on your ",
                "core message",
                "."
            )
        case "david":
            return (
                "\(persona.name) will push back on logic gaps. Come prepared with ",
                "evidence and reasoning",
                "."
            )
        case "chloe":
            return (
                "\(persona.name) drifts easily. Keep it ",
                "concise and engaging",
                " — she's worth winning over."
            )
        case "victor":
            return (
                "\(persona.name) is intense. Stay calm and ",
                "hold your ground",
                " without escalating."
            )
        default:
            return (
                "Focus on your ",
                "key message",
                " and stay grounded."
            )
        }
    }
}

// MARK: - Tip Card

private struct TipCard: View {
    let tip: PracticeTip

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(AppColors.background)
                    .frame(width: 40, height: 40)

                Image(systemName: tip.sfSymbol)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
            }

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(tip.title)
                    .font(AppFonts.label(14))
                    .foregroundStyle(AppColors.textPrimary)

                Text(tip.description)
                    .font(AppFonts.body(13))
                    .foregroundStyle(AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(AppSpacing.base)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(AppColors.surface)
                .subtleShadow()
        }
    }
}

#Preview {
    NavigationStack {
        PracticePrimerScreen(
            viewModel: {
                let vm = PracticeFlowViewModel()
                vm.selectedScenario = Scenario.all[2]
                vm.selectedPersona = Persona.all[0]
                return vm
            }()
        )
    }
}
