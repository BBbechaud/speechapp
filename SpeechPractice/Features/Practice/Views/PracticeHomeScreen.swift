import SwiftUI

struct PracticeHomeScreen: View {
    var viewModel: PracticeFlowViewModel
    let onReviewFeedbackClosed: (ReviewFeedback) -> Void

    @State private var appeared = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.base) {
                dailyChallengesSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 12)
                    .animation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.05), value: appeared)

                scenarioListSection
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.background)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(for: PracticeRoute.self) { route in
            switch route {
            case .dailyChallenges:
                DailyChallengesScreen(viewModel: viewModel)
            case .dailyMinuteWheel:
                DailyMinuteWheelScreen(viewModel: viewModel)
            case .dailyMinuteSession(let prompt):
                DailyMinuteSessionScreen(viewModel: viewModel, prompt: prompt)
            case .configure:
                ScenarioConfigScreen(viewModel: viewModel)
            case .primer:
                PracticePrimerScreen(viewModel: viewModel)
            case .prePracticeTransition:
                PrePracticeTransitionScreen(viewModel: viewModel)
            case .session:
                PracticeSessionScreen(viewModel: viewModel)
            case .complete:
                PracticeCompleteScreen(onReviewFeedback: {
                    viewModel.showReviewFeedback()
                })
            case .reviewFeedback:
                let feedback = viewModel.currentReviewFeedback()
                ReviewFeedbackScreen(
                    feedback: feedback,
                    onClose: {
                        onReviewFeedbackClosed(feedback)
                        viewModel.reset()
                    }
                )
            }
        }
        .onAppear {
            appeared = true
        }
    }

    // MARK: - Daily Challenges

    private var dailyChallengesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Daily Challenges")
                .font(AppFonts.label(18, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)

            Button {
                viewModel.showDailyChallenges()
            } label: {
                ZStack(alignment: .leading) {
                    // Decorative background geometry — right-anchored, no GeometryReader
                    HStack {
                        Spacer(minLength: 0)
                        ZStack(alignment: .topTrailing) {
                            Circle()
                                .fill(.white.opacity(0.09))
                                .frame(width: 130, height: 130)
                                .offset(x: 30, y: -24)
                            Circle()
                                .fill(.white.opacity(0.06))
                                .frame(width: 80, height: 80)
                                .offset(x: 18, y: 46)
                            Circle()
                                .fill(.white.opacity(0.06))
                                .frame(width: 50, height: 50)
                                .offset(x: -40, y: 60)
                        }
                        .frame(width: 120)
                        .clipped()
                    }

                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        HStack(alignment: .center) {
                            HStack(spacing: AppSpacing.md) {
                                // Count badge
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 44, height: 44)
                                    Text("\(DailyChallenge.all.count)")
                                        .font(AppFonts.display(22, weight: .bold))
                                        .foregroundStyle(AppColors.primary)
                                }

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Today's challenges")
                                        .font(AppFonts.label(11, weight: .semibold))
                                        .foregroundStyle(.white.opacity(0.7))
                                        .textCase(.uppercase)
                                        .tracking(0.4)

                                    Text("Sharpen your skills")
                                        .font(AppFonts.title(17, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            }

                            Spacer(minLength: 0)

                            // Arrow circle
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 34, height: 34)
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            .accessibilityHidden(true)
                        }

                        // Category pills
                        HStack(spacing: AppSpacing.sm) {
                            ForEach(DailyChallenge.all, id: \.id) { challenge in
                                Label {
                                    Text(challenge.category)
                                        .font(AppFonts.label(10, weight: .semibold))
                                } icon: {
                                    Image(systemName: challenge.sfSymbol)
                                        .font(.system(size: 9, weight: .bold))
                                }
                                .foregroundStyle(.white.opacity(0.88))
                                .padding(.horizontal, 9)
                                .padding(.vertical, 5)
                                .background(Capsule().fill(.white.opacity(0.18)))
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.vertical, AppSpacing.lg)
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 116)
                .background {
                    RoundedRectangle(cornerRadius: AppRadius.xxl)
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primary, Color(hex: "#C8501E")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cardShadow()
                }
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.xxl))
            }
            .buttonStyle(PressButtonStyle())
            .accessibilityLabel("Daily challenges, \(DailyChallenge.all.count) available")
        }
    }

    // MARK: - Scenario List

    private var scenarioListSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.base) {
            Text("Scenarios")
                .font(AppFonts.label(18, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)

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
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                ForEach(Array(DailyChallenge.all.enumerated()), id: \.element.id) { index, challenge in
                    Button {
                        if challenge.isDailyMinute {
                            viewModel.showDailyMinuteWheel()
                        } else {
                            viewModel.select(scenario: challenge.scenario)
                        }
                    } label: {
                        DailyChallengeCard(challenge: challenge)
                    }
                    .buttonStyle(PressButtonStyle())
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 14)
                    .animation(
                        .spring(response: 0.45, dampingFraction: 0.82)
                            .delay(0.08 + Double(index) * 0.07),
                        value: appeared
                    )
                }
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.background)
        .navigationTitle("Daily Challenges")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AppColors.background, for: .navigationBar)
        .onAppear {
            appeared = true
        }
    }
}

// MARK: - Daily Challenge Card

private struct DailyChallengeCard: View {
    let challenge: DailyChallenge

    private var accentColor: Color {
        switch challenge.category {
        case "Daily Minute": return AppColors.wheelOrange
        case "Speed Drill":  return Color(hex: "#5B6AF0")
        default:             return AppColors.primary
        }
    }

    private var accentSubtle: Color {
        switch challenge.category {
        case "Daily Minute": return Color(hex: "#FFF4E0")
        case "Speed Drill":  return Color(hex: "#EEEEFF")
        default:             return AppColors.primarySubtle
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // ── Header row ──────────────────────────────────
            HStack(alignment: .center, spacing: AppSpacing.md) {
                // Icon in tinted rounded square
                ZStack {
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .fill(accentSubtle)
                        .frame(width: 50, height: 50)
                    Image(systemName: challenge.sfSymbol)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(accentColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(challenge.category.uppercased())
                        .font(AppFonts.label(10, weight: .bold))
                        .foregroundStyle(accentColor)
                        .tracking(0.6)

                    Text(challenge.title)
                        .font(AppFonts.title(17, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.top, AppSpacing.xl)
            .padding(.bottom, AppSpacing.md)

            // Thin divider
            Rectangle()
                .fill(AppColors.separator)
                .frame(height: 1)
                .padding(.horizontal, AppSpacing.xl)

            // ── Description ─────────────────────────────────
            Text(challenge.description)
                .font(AppFonts.body(14))
                .foregroundStyle(AppColors.textSecondary)
                .lineSpacing(3)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, AppSpacing.xl)
                .padding(.top, AppSpacing.md)

            // ── Footer ──────────────────────────────────────
            HStack(alignment: .center) {
                Label {
                    Text(challenge.scenario.durationRange)
                        .font(AppFonts.label(12, weight: .medium))
                } icon: {
                    Image(systemName: "clock")
                        .font(.system(size: 11, weight: .medium))
                }
                .foregroundStyle(AppColors.textTertiary)

                Spacer()

                HStack(spacing: 5) {
                    Text("Start")
                        .font(AppFonts.label(13, weight: .bold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 11, weight: .bold))
                }
                .foregroundStyle(accentColor)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(Capsule().fill(accentColor.opacity(0.1)))
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.top, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xl)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .fill(AppColors.surface)
                .cardShadow()
        }
    }
}

// MARK: - Scenario Row

private struct ScenarioRow: View {
    let scenario: Scenario

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: scenario.sfSymbol)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColors.primary)
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
    @Previewable @State var viewModel = PracticeFlowViewModel()
    NavigationStack(path: $viewModel.navigationPath) {
        PracticeHomeScreen(viewModel: viewModel, onReviewFeedbackClosed: { _ in })
    }
}
