import SwiftUI

struct ReviewSessionSummaryCard: View {
    let summary: ReviewSessionSummary

    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.lg) {
            scoreView

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(summary.scenarioTitle)
                    .font(AppFonts.title(21, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(reviewRelativeCompletionText(summary.completedAt))
                    .font(AppFonts.label(13, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(AppSpacing.md)
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
        .accessibilityLabel("\(summary.scenarioTitle), with \(summary.personaName), score \(summary.overallScore), \(reviewFormattedDuration(summary.durationSeconds)), completed \(reviewRelativeCompletionText(summary.completedAt))")
    }

    private var scoreView: some View {
        VStack(spacing: 1) {
            Text("\(summary.overallScore)")
                .font(AppFonts.display(26))
                .foregroundStyle(AppColors.primary)
                .monospacedDigit()
                .lineLimit(1)

            Text("overall")
                .font(AppFonts.label(10, weight: .bold))
                .foregroundStyle(AppColors.primary.opacity(0.9))
        }
        .frame(width: 54)
    }
}

struct ReviewHistoryFeedbackDestination: View {
    let feedback: ReviewFeedback

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ReviewFeedbackScreen(
            feedback: feedback,
            closeStyle: .back,
            onClose: {
                dismiss()
            }
        )
    }
}

func reviewFormattedDuration(_ durationSeconds: Int) -> String {
    let minutes: Int = durationSeconds / 60
    let seconds: Int = durationSeconds % 60

    return "\(minutes)m \(seconds)s"
}

func reviewRelativeCompletionText(_ completedAt: Date) -> String {
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
        return reviewUnitText(value: minutes, singular: "minute")
    }

    if elapsedSeconds < day {
        let hours: Int = max(1, Int(elapsedSeconds / hour))
        return reviewUnitText(value: hours, singular: "hour")
    }

    if elapsedSeconds < week {
        let days: Int = max(1, Int(elapsedSeconds / day))
        return reviewUnitText(value: days, singular: "day")
    }

    let weeks: Int = max(1, Int(elapsedSeconds / week))
    return reviewUnitText(value: weeks, singular: "week")
}

private func reviewUnitText(value: Int, singular: String) -> String {
    let unit: String = value == 1 ? singular : "\(singular)s"
    return "\(value) \(unit) ago"
}

#Preview {
    NavigationStack {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                ForEach(ReviewHistoryStore.previewRecords()) { record in
                    ReviewSessionSummaryCard(summary: record.summary)
                }
            }
            .padding(AppSpacing.base)
        }
        .background(AppColors.background)
    }
}
