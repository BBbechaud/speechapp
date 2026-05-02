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

                personaDescription
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.1), value: appeared)

                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    focusOnHeading
                    tipsSection
                }
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(scenario.title)
                    .font(AppFonts.display(24))
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .multilineTextAlignment(.center)
            }
        }
        .safeAreaInset(edge: .bottom) {
            startButton
                .padding(.horizontal, AppSpacing.base)
                .padding(.vertical, AppSpacing.md)
                .background(AppColors.background)
                .opacity(appeared ? 1 : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.3), value: appeared)
        }
        .onAppear {
            appeared = true
        }
    }

    // MARK: - Persona Hero

    private var personaHero: some View {
        VStack(spacing: AppSpacing.sm) {
            PersonaAvatarView(name: persona.name, size: 88)
                .overlay {
                    Circle()
                        .strokeBorder(AppColors.primaryMedium, lineWidth: 2)
                }
                .scaleEffect(appeared ? 1 : 0.85)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.08), value: appeared)

            DifficultyBadge(difficulty: persona.difficulty)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Focus on (tips)

    private var focusOnHeading: some View {
        Text("Focus on")
            .font(AppFonts.title(20))
            .foregroundStyle(AppColors.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var personaDescription: some View {
        let parts = primerDescription(for: persona, scenario: scenario)

        return Group {
            Text(parts.prefix)
                .font(AppFonts.body(15))
                .foregroundStyle(AppColors.textSecondary)
            + Text(parts.highlight)
                .font(AppFonts.body(15, weight: .semibold))
                .foregroundStyle(AppColors.primary)
            + Text(parts.suffix)
                .font(AppFonts.body(15))
                .foregroundStyle(AppColors.textSecondary)
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Tips (goal + scenario tips)

    private var tipsSection: some View {
        VStack(spacing: AppSpacing.sm) {
            scenarioGoalCard
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)
                .animation(
                    .spring(response: 0.4, dampingFraction: 0.8).delay(0.18),
                    value: appeared
                )

            ForEach(Array(scenario.tips.enumerated()), id: \.element.id) { index, tip in
                TipCard(tip: tip)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(
                        .spring(response: 0.4, dampingFraction: 0.8)
                            .delay(0.25 + Double(index) * 0.07),
                        value: appeared
                    )
            }
        }
    }

    private var scenarioGoalCard: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(AppColors.background)
                    .frame(width: 40, height: 40)

                Image(systemName: "scope")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
            }

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("Your goal")
                    .font(AppFonts.label(14))
                    .foregroundStyle(AppColors.textPrimary)

                Text(scenario.description)
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

    // MARK: - Start Button

    private var startButton: some View {
        PrimaryButton(title: "Start Practice") {
            viewModel.startPractice()
        }
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
