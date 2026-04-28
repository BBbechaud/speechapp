import SwiftUI

struct ReviewHistoryScreen: View {
    let summaries: [ReviewSessionSummary]

    @State private var appeared: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                header

                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text("All sessions")
                        .font(AppFonts.label(14, weight: .bold))
                        .foregroundStyle(AppColors.textSecondary)

                    VStack(spacing: AppSpacing.md) {
                        ForEach(Array(summaries.enumerated()), id: \.element.id) { index, summary in
                            ReviewSessionSummaryCard(summary: summary)
                                .opacity(appeared ? 1 : 0)
                                .offset(y: appeared ? 0 : 12)
                                .animation(
                                    .spring(response: 0.42, dampingFraction: 0.84)
                                        .delay(Double(index) * 0.04),
                                    value: appeared
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.xxl)
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.background)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            appeared = true
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Feedback")
                .font(AppFonts.display(34))
                .foregroundStyle(AppColors.textPrimary)
                .accessibilityAddTraits(.isHeader)

            Text("Review your past communication performances")
                .font(AppFonts.body(16))
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct ReviewSessionSummaryCard: View {
    let summary: ReviewSessionSummary

    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.lg) {
            scoreView

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack(alignment: .center, spacing: AppSpacing.md) {
                    Text(summary.scenarioTitle)
                        .font(AppFonts.title(21, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: AppSpacing.sm)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(AppColors.textTertiary)
                        .accessibilityHidden(true)
                }

                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.sm) {
                    Text("with \(summary.personaName)")
                        .font(AppFonts.body(14, weight: .medium))
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)

                    Spacer(minLength: AppSpacing.sm)

                    Text(formattedDuration(summary.durationSeconds))
                        .font(AppFonts.label(13, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)
                        .lineLimit(1)
                        .monospacedDigit()

                    Text("•")
                        .font(AppFonts.label(13, weight: .bold))
                        .foregroundStyle(AppColors.textTertiary)
                        .accessibilityHidden(true)

                    Text(relativeCompletionText(summary.completedAt))
                        .font(AppFonts.label(13, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .fill(AppColors.surface)
                .cardShadow()
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .strokeBorder(AppColors.separator.opacity(0.55), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(summary.scenarioTitle), with \(summary.personaName), score \(summary.overallScore), \(formattedDuration(summary.durationSeconds)), completed \(relativeCompletionText(summary.completedAt))")
    }

    private var scoreView: some View {
        VStack(spacing: AppSpacing.xs) {
            Text("\(summary.overallScore)")
                .font(AppFonts.display(26))
                .foregroundStyle(AppColors.accent)
                .monospacedDigit()
                .lineLimit(1)

            Text("score")
                .font(AppFonts.label(10, weight: .bold))
                .foregroundStyle(AppColors.accent.opacity(0.9))
        }
        .frame(width: 54)
    }
}

private func formattedDuration(_ durationSeconds: Int) -> String {
    let minutes: Int = durationSeconds / 60
    let seconds: Int = durationSeconds % 60

    return "\(minutes)m \(seconds)s"
}

private func relativeCompletionText(_ completedAt: Date) -> String {
    let elapsedSeconds: TimeInterval = Date().timeIntervalSince(completedAt)
    let minute: TimeInterval = 60
    let hour: TimeInterval = 60 * minute
    let day: TimeInterval = 24 * hour
    let week: TimeInterval = 7 * day

    if elapsedSeconds < minute {
        return "just now"
    }

    if elapsedSeconds < hour {
        let minutes: Int = max(1, Int(elapsedSeconds / minute))
        return unitText(value: minutes, singular: "minute")
    }

    if elapsedSeconds < day {
        let hours: Int = max(1, Int(elapsedSeconds / hour))
        return unitText(value: hours, singular: "hour")
    }

    if elapsedSeconds < week {
        let days: Int = max(1, Int(elapsedSeconds / day))
        return unitText(value: days, singular: "day")
    }

    let weeks: Int = max(1, Int(elapsedSeconds / week))
    return unitText(value: weeks, singular: "week")
}

private func unitText(value: Int, singular: String) -> String {
    let unit: String = value == 1 ? singular : "\(singular)s"
    return "\(value) \(unit) ago"
}

#Preview {
    NavigationStack {
        ReviewHistoryScreen(summaries: ReviewHistoryStore.loadSummaries())
    }
}
