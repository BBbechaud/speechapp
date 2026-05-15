import SwiftUI

struct PracticeHomeScreen: View {
    var viewModel: PracticeFlowViewModel
    let onReviewFeedbackClosed: (ReviewFeedback) -> Void

    @State private var appeared = false

    /// Placeholder until streak and account level are loaded from persistence.
    private let streakDays = 10
    private let accountLevel = 7

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.base) {
                practiceStatusHeader
                    .padding(.bottom, AppSpacing.sm)

                dailyChallengesSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 12)
                    .animation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.05), value: appeared)

                scenarioListSection
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, AppSpacing.xxl)
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
            case .categoryScenarios(let category):
                CategoryScenariosScreen(viewModel: viewModel, category: category)
            case .customScenariosHub:
                CustomScenariosScreen(viewModel: viewModel)
            case .configure:
                ScenarioConfigScreen(viewModel: viewModel)
            case .customScenarioEditor:
                CustomScenarioEditorScreen(viewModel: viewModel)
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

    // MARK: - Header

    private var practiceStatusHeader: some View {
        HStack {
            Spacer(minLength: 0)

            HStack(spacing: AppSpacing.sm) {
                PracticeStreakBadge(days: streakDays)
                PracticeLevelBadge(level: accountLevel)
            }
        }
        .frame(maxWidth: .infinity)
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

    // MARK: - Scenario Section

    private var scenarioListSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.base) {
            // Section header
            Text("Practice Scenarios")
                .font(AppFonts.label(18, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)
                .animation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.1), value: appeared)

            // Custom scenarios hero card (full-width, first in the section)
            Button { viewModel.showCustomScenariosHub() } label: {
                CustomScenariosHeroCard(savedCount: viewModel.customScenarioStore.scenarios.count)
            }
            .buttonStyle(PressButtonStyle())
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 10)
            .animation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.15), value: appeared)

            // 2-column category grid
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: AppSpacing.md), GridItem(.flexible(), spacing: AppSpacing.md)],
                spacing: AppSpacing.md
            ) {
                ForEach(Array(ScenarioCategory.allCases.enumerated()), id: \.element.id) { index, category in
                    Button { viewModel.showCategory(category) } label: {
                        CategoryCard(category: category, count: Scenario.scenarios(for: category).count)
                    }
                    .buttonStyle(PressButtonStyle())
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 12)
                    .animation(
                        .spring(response: 0.45, dampingFraction: 0.8).delay(0.2 + Double(index) * 0.06),
                        value: appeared
                    )
                }
            }
        }
    }
}

// MARK: - Practice status badges

private struct PracticeStreakBadge: View {
    let days: Int

    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: "flame.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColors.primary)
                .accessibilityHidden(true)

            Text("\(days)")
                .font(AppFonts.label(15, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.surface, in: Capsule())
        .subtleShadow()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(days) day practice streak")
    }
}

private struct PracticeLevelBadge: View {
    let level: Int

    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            Text("LVL")
                .font(AppFonts.label(11, weight: .bold))
                .foregroundStyle(AppColors.accent)
                .tracking(0.4)

            Text("\(level)")
                .font(AppFonts.label(15, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.surface, in: Capsule())
        .subtleShadow()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Level \(level)")
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

// MARK: - Custom Scenarios Hero Card

private struct CustomScenariosHeroCard: View {
    let savedCount: Int

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 48, height: 48)
                Image(systemName: "sparkles")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: AppSpacing.sm) {
                    Text("Custom Scenarios")
                        .font(AppFonts.title(16, weight: .bold))
                        .foregroundStyle(.white)

                    if savedCount > 0 {
                        Text("\(savedCount) saved")
                            .font(AppFonts.label(11, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(.horizontal, AppSpacing.sm)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(.white.opacity(0.22)))
                    }
                }

                Text("Create your own or practice saved ones")
                    .font(AppFonts.body(13))
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .padding(.horizontal, AppSpacing.xl)
        .padding(.vertical, AppSpacing.lg)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#F4C76A"), Color(hex: "#D48A20")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cardShadow()
        }
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
    }
}

// MARK: - Category Card

private struct CategoryCard: View {
    let category: ScenarioCategory
    let count: Int

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Decorative arcs in background (bottom-trailing)
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.12))
                        .frame(width: geo.size.width * 0.8)
                        .offset(x: geo.size.width * 0.45, y: geo.size.height * 0.35)
                    Circle()
                        .fill(.white.opacity(0.08))
                        .frame(width: geo.size.width * 0.55)
                        .offset(x: geo.size.width * 0.6, y: geo.size.height * 0.6)
                }
            }
            .clipped()

            VStack(alignment: .leading, spacing: 0) {
                // Title + subtitle
                VStack(alignment: .leading, spacing: 5) {
                    Text(category.rawValue)
                        .font(AppFonts.title(17, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    Text(category.subtitle)
                        .font(AppFonts.body(12))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: AppSpacing.lg)

                // Count badge
                HStack {
                    Spacer(minLength: 0)
                    ZStack {
                        Circle()
                            .fill(AppColors.accent)
                            .frame(width: 34, height: 34)
                            .shadow(color: .white.opacity(0.20), radius: 1, x: 0, y: 0)
                        Text("\(count)")
                            .font(AppFonts.label(14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(AppSpacing.base)
        }
        .aspectRatio(0.95, contentMode: .fit)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .fill(
                    LinearGradient(
                        colors: category.gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cardShadow()
        }
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
    }
}

// MARK: - Scenario Row

struct ScenarioRow: View {
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

// MARK: - Custom Scenario Rows (shared)

struct CustomScenarioCreateRow: View {
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            ZStack {
                Circle()
                    .fill(AppColors.primarySubtle)
                    .frame(width: 44, height: 44)

                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(AppColors.primary)
            }
            .frame(width: 44, height: 48, alignment: .center)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("Create Custom Scenario")
                    .font(AppFonts.title(15))
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(1)

                Text("Tailor a practice scenario to a specific situation you have in mind.")
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
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .strokeBorder(
                    AppColors.primaryMedium,
                    style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                )
        }
    }
}

struct CustomScenarioSavedRow: View {
    let scenario: CustomScenario

    private var displayTitle: String {
        let trimmed = scenario.trimmedName
        return trimmed.isEmpty ? "Custom Scenario" : trimmed
    }

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "sparkles")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColors.accent)
                .frame(width: 44, height: 48, alignment: .center)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                HStack(alignment: .center, spacing: AppSpacing.sm) {
                    Text(displayTitle)
                        .font(AppFonts.title(15))
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)

                    Text("Custom")
                        .font(AppFonts.label(11, weight: .semibold))
                        .foregroundStyle(AppColors.accent)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, 3)
                        .background(AppColors.accentSubtle, in: Capsule())
                }

                Text(scenario.trimmedPrompt)
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
