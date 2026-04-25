import SwiftUI

struct PracticeHomeScreen: View {
    @State private var viewModel = PracticeFlowViewModel()
    @State private var appeared = false

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    dailyScenarioCard
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 12)
                        .animation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.05), value: appeared)

                    scenarioListSection
                }
                .padding(.horizontal, AppSpacing.base)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, AppSpacing.xxxl)
            }
            .background(AppColors.background)
            .navigationTitle("Select Scenario")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(AppColors.background, for: .navigationBar)
            .navigationDestination(for: PracticeRoute.self) { route in
                switch route {
                case .configure:
                    ScenarioConfigScreen(viewModel: viewModel)
                case .primer:
                    PracticePrimerScreen(viewModel: viewModel)
                case .session:
                    // Placeholder until session screen is built
                    FeaturePlaceholderScreen(title: "Live Practice", systemImage: "mic.fill")
                }
            }
            .onAppear {
                appeared = true
            }
        }
    }

    // MARK: - Daily Scenario

    private var dailyScenarioCard: some View {
        let scenario = Scenario.all[2] // "The Big Pitch" as daily

        return Button {
            viewModel.select(scenario: scenario)
        } label: {
            HStack(spacing: AppSpacing.base) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .fill(AppColors.accentSubtle)
                        .frame(width: 52, height: 52)

                    Image(systemName: scenario.sfSymbol)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(AppColors.accent)
                }

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    HStack(spacing: AppSpacing.xs) {
                        Text("Daily Scenario")
                            .font(AppFonts.label(11, weight: .semibold))
                            .foregroundStyle(AppColors.accent)
                            .padding(.horizontal, AppSpacing.sm)
                            .padding(.vertical, 3)
                            .background(AppColors.accentSubtle, in: Capsule())

                        Spacer()

                        TimeBadge(duration: scenario.durationRange)
                    }

                    Text(scenario.title)
                        .font(AppFonts.title(17))
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)

                    Text(scenario.description)
                        .font(AppFonts.body(13))
                        .foregroundStyle(AppColors.textSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.accent)
            }
            .padding(AppSpacing.base)
            .background {
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .fill(AppColors.surface)
                    .cardShadow()
            }
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .strokeBorder(AppColors.accentMedium, lineWidth: 1.5)
            }
        }
        .buttonStyle(PressButtonStyle())
    }

    // MARK: - Scenario List

    private var scenarioListSection: some View {
        VStack(spacing: AppSpacing.sm) {
            ForEach(Array(Scenario.all.enumerated()), id: \.element.id) { index, scenario in
                Button { viewModel.select(scenario: scenario) } label: {
                    ScenarioRow(scenario: scenario)
                }
                .buttonStyle(PressButtonStyle())
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)
                .animation(
                    .spring(response: 0.45, dampingFraction: 0.8)
                        .delay(0.1 + Double(index) * 0.05),
                    value: appeared
                )
            }
        }
    }
}

// MARK: - Scenario Row

private struct ScenarioRow: View {
    let scenario: Scenario

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .fill(AppColors.accentSubtle)
                    .frame(width: 48, height: 48)

                Image(systemName: scenario.sfSymbol)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(AppColors.accent)
            }

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                HStack(alignment: .center, spacing: AppSpacing.sm) {
                    Text(scenario.title)
                        .font(AppFonts.title(15))
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)

                    TimeBadge(duration: scenario.durationRange)
                }

                Text(scenario.description)
                    .font(AppFonts.body(13))
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(2)
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
    PracticeHomeScreen()
}
