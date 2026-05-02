import SwiftUI

struct ScenarioConfigScreen: View {
    @Bindable var viewModel: PracticeFlowViewModel
    @State private var appeared = false

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.md),
        GridItem(.flexible(), spacing: AppSpacing.md),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                if let scenario = viewModel.selectedScenario {
                    selectedScenarioBanner(scenario: scenario)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.05), value: appeared)
                }

                personaSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.1), value: appeared)

                initiatorSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.15), value: appeared)

                continueButton
                    .opacity(appeared ? 1 : 0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.2), value: appeared)
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.base)
            .padding(.bottom, 100)
        }
        .background(AppColors.background)
        .navigationTitle("Configure Scenario")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            appeared = true
        }
    }

    // MARK: - Selected Scenario Banner

    private func selectedScenarioBanner(scenario: Scenario) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: scenario.sfSymbol)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(AppColors.primary)
                .frame(width: 52, height: 56, alignment: .center)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(scenario.title)
                    .font(AppFonts.title(16))
                    .foregroundStyle(AppColors.textPrimary)

                Text(scenario.description)
                    .font(AppFonts.body(13))
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)
        }
        .padding(AppSpacing.base)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .fill(AppColors.primarySubtle)
        }
    }

    // MARK: - Persona Section

    private var personaSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Who are you talking to?")
                .font(AppFonts.title(18))
                .foregroundStyle(AppColors.textPrimary)

            LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                ForEach(Persona.all) { persona in
                    PersonaCard(
                        persona: persona,
                        isSelected: viewModel.selectedPersona?.id == persona.id
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.selectedPersona = persona
                        }
                    }
                }
            }
        }
    }

    // MARK: - Initiator Section

    private var initiatorSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Who starts?")
                    .font(AppFonts.title(18))
                    .foregroundStyle(AppColors.textPrimary)

                Spacer()

                initiatorPicker
            }
        }
        .padding(AppSpacing.base)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(AppColors.surface)
                .subtleShadow()
        }
    }

    private var initiatorPicker: some View {
        HStack(spacing: 0) {
            initiatorOption(label: "Me", value: .user)
            initiatorOption(
                label: viewModel.selectedPersona?.name ?? "AI",
                value: .ai
            )
        }
        .padding(3)
        .background(AppColors.background, in: Capsule())
    }

    private func initiatorOption(label: String, value: ConversationInitiator) -> some View {
        let isSelected = viewModel.initiator == value

        return Text(label)
            .font(AppFonts.label(14, weight: isSelected ? .semibold : .regular))
            .foregroundStyle(isSelected ? AppColors.textPrimary : AppColors.textTertiary)
            .padding(.horizontal, AppSpacing.base)
            .padding(.vertical, AppSpacing.sm)
            .background {
                if isSelected {
                    Capsule()
                        .fill(AppColors.surface)
                        .cardShadow()
                }
            }
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: viewModel.initiator)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                    viewModel.initiator = value
                }
            }
    }

    // MARK: - Continue Button

    private var continueButton: some View {
        PrimaryButton(title: "Continue to Prep") {
            viewModel.confirmConfig()
        }
    }
}

// MARK: - Persona Card

private struct PersonaCard: View {
    let persona: Persona
    let isSelected: Bool

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            PersonaAvatarView(name: persona.name, size: 72)
                .overlay {
                    if isSelected {
                        Circle()
                            .strokeBorder(AppColors.primary, lineWidth: 2.5)
                    }
                }
                .scaleEffect(isSelected ? 1.04 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)

            Text(persona.name)
                .font(AppFonts.title(15))
                .foregroundStyle(AppColors.textPrimary)

            DifficultyBadge(difficulty: persona.difficulty)

            Text(persona.description)
                .font(AppFonts.body(12))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2, reservesSpace: true)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, AppSpacing.base)
        .padding(.horizontal, AppSpacing.sm)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(AppColors.surface)
                .subtleShadow()
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .strokeBorder(
                    isSelected ? AppColors.primary : Color.clear,
                    lineWidth: 2
                )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    NavigationStack {
        ScenarioConfigScreen(
            viewModel: {
                let vm = PracticeFlowViewModel()
                vm.selectedScenario = Scenario.all[2]
                vm.selectedPersona = Persona.all[0]
                return vm
            }()
        )
    }
}
