import SwiftUI

struct PracticeHomeScreen: View {
    var onSwitchToFeedbackTab: () -> Void = {}

    @State private var viewModel = PracticeFlowViewModel()
    @State private var appeared = false

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    dailyChallengesSection
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 12)
                        .animation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.05), value: appeared)

                    scenarioListSection
                }
                .padding(.horizontal, AppSpacing.base)
                .padding(.top, AppSpacing.xs)
                .padding(.bottom, AppSpacing.xxxl)
            }
            .background(AppColors.background)
            .navigationTitle("Select Scenario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(AppColors.background, for: .navigationBar)
            .navigationDestination(for: PracticeRoute.self) { route in
                switch route {
                case .dailyChallenges:
                    DailyChallengesScreen(viewModel: viewModel)
                case .configure:
                    ScenarioConfigScreen(viewModel: viewModel)
                case .primer:
                    PracticePrimerScreen(viewModel: viewModel)
                case .session:
                    PracticeSessionScreen(viewModel: viewModel)
                case .complete:
                    PracticeCompleteScreen(onSeeConversationAnalysis: {
                        viewModel.reset()
                        onSwitchToFeedbackTab()
                    })
                }
            }
            .onAppear {
                appeared = true
            }
        }
    }

    // MARK: - Daily Challenges

    private var dailyChallengesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                viewModel.showDailyChallenges()
            } label: {
                HStack(spacing: AppSpacing.md) {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppRadius.lg)
                            .fill(.white.opacity(0.22))

                        Circle()
                            .fill(.white)
                            .frame(width: 34, height: 34)
                    }
                    .frame(width: 64, height: 64)

                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("Daily Challenges")
                            .font(AppFonts.title(20, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)

                        Text("Quick practice sessions to help refine your skills")
                            .font(AppFonts.label(13, weight: .semibold))
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer(minLength: 0)

                    Image(systemName: "sparkles")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white.opacity(0.22))
                        .accessibilityHidden(true)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white.opacity(0.95))
                        .accessibilityHidden(true)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
                .frame(maxWidth: .infinity, minHeight: 100)
                .background {
                    RoundedRectangle(cornerRadius: AppRadius.xxl)
                        .fill(AppColors.accent)
                        .cardShadow()
                }
            }
            .buttonStyle(PressButtonStyle())
        }
    }

    // MARK: - Scenario List

    private var scenarioListSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Scenarios")
                .font(AppFonts.label(13, weight: .bold))
                .foregroundStyle(AppColors.textSecondary)

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

// MARK: - Daily Challenges Screen

private struct DailyChallengesScreen: View {
    let viewModel: PracticeFlowViewModel

    @State private var appeared = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                ForEach(Array(DailyChallenge.all.enumerated()), id: \.element.id) { index, challenge in
                    Button {
                        viewModel.select(scenario: challenge.scenario)
                    } label: {
                        DailyChallengeCard(challenge: challenge)
                    }
                    .buttonStyle(PressButtonStyle())
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 14)
                    .animation(
                        .spring(response: 0.45, dampingFraction: 0.82)
                            .delay(Double(index) * 0.06),
                        value: appeared
                    )
                }
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.background)
        .navigationTitle("Daily Challenges")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(AppColors.background, for: .navigationBar)
        .onAppear {
            appeared = true
        }
    }
}

// MARK: - Daily Challenge Card

private struct DailyChallengeCard: View {
    let challenge: DailyChallenge

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                Label {
                    Text(challenge.category)
                        .font(AppFonts.label(12, weight: .bold))
                } icon: {
                    Image(systemName: challenge.sfSymbol)
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundStyle(AppColors.accent)

                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text(challenge.title)
                        .font(AppFonts.display(28, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(challenge.description)
                        .font(AppFonts.body(18, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)
                        .lineSpacing(4)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: 0)

            ChallengeArtwork(symbolName: challenge.sfSymbol)
                .frame(width: 106, height: 128)
                .accessibilityHidden(true)
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 190)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .fill(AppColors.surface)
                .cardShadow()
        }
    }
}

// MARK: - Challenge Artwork

private struct ChallengeArtwork: View {
    let symbolName: String

    var body: some View {
        ZStack {
            Image(systemName: symbolName)
                .font(.system(size: 86, weight: .bold))
                .foregroundStyle(AppColors.accentSubtle)
                .offset(x: 14, y: 8)

            VStack(spacing: 8) {
                ForEach([28.0, 48.0, 82.0, 52.0, 34.0], id: \.self) { height in
                    Capsule()
                        .fill(AppColors.accentSubtle)
                        .frame(width: 10, height: height)
                }
            }
            .rotationEffect(.degrees(90))
            .opacity(0.75)
            .offset(x: 12, y: 10)
        }
        .clipped()
    }
}

// MARK: - Scenario Row

private struct ScenarioRow: View {
    let scenario: Scenario

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: scenario.sfSymbol)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColors.accent)
                .frame(width: 44, height: 48, alignment: .center)
                .accessibilityHidden(true)

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
