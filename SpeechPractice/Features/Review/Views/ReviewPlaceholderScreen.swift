import SwiftUI

struct ReviewHistoryScreen: View {
    let records: [ReviewSessionRecord]

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
                        ForEach(Array(records.enumerated()), id: \.element.id) { index, record in
                            NavigationLink(value: record) {
                                ReviewSessionSummaryCard(summary: record.summary)
                            }
                            .buttonStyle(PlainButtonStyle())
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
        .navigationDestination(for: ReviewSessionRecord.self) { record in
            ReviewHistoryFeedbackDestination(recordID: record.id, feedback: record.feedback)
        }
    }

    private var header: some View {
        Text("Feedback")
            .font(AppFonts.display(34))
            .foregroundStyle(AppColors.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }
}

private struct ReviewHistoryFeedbackDestination: View {
    let recordID: UUID
    let feedback: ReviewFeedback

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ReviewFeedbackScreen(
            feedback: feedback,
            notesStorageKey: ReviewHistoryStore.notesStorageKey(for: recordID),
            onClose: {
                dismiss()
            }
        )
    }
}

private struct ReviewSessionSummaryCard: View {
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

                Text(relativeCompletionText(summary.completedAt))
                    .font(AppFonts.label(13, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(AppColors.textTertiary)
                .padding(.trailing, AppSpacing.xs)
                .accessibilityHidden(true)
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
        .accessibilityLabel("\(summary.scenarioTitle), with \(summary.personaName), score \(summary.overallScore), \(formattedDuration(summary.durationSeconds)), completed \(relativeCompletionText(summary.completedAt))")
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
        ReviewHistoryScreen(records: ReviewHistoryStore.loadRecords())
    }
}
