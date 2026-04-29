import SwiftUI

struct ReviewFeedbackScreen: View {
    let feedback: ReviewFeedback
    let onClose: () -> Void

    @AppStorage("latestPracticeReviewNotes") private var practiceNotes: String = ""
    @State private var appeared: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xl) {
                header

                scenarioPill
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                    .animation(.spring(response: 0.42, dampingFraction: 0.82).delay(0.04), value: appeared)

                OverallScoreRing(score: feedback.overallScore)
                    .padding(.vertical, AppSpacing.sm)
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.92)
                    .animation(.spring(response: 0.52, dampingFraction: 0.78).delay(0.08), value: appeared)

                skillAnalysisSection
                overallFeedbackSection
                PracticeNotesSection(notes: $practiceNotes)
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(AppColors.background)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            appeared = true
        }
    }

    private var header: some View {
        ZStack {
            Text("Session Feedback")
                .font(AppFonts.title(18, weight: .bold))
                .foregroundStyle(AppColors.textTertiary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
                .accessibilityAddTraits(.isHeader)

            HStack {
                Button {
                    onClose()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                        .frame(width: 46, height: 46)
                        .background(AppColors.surfaceRaised, in: Circle())
                        .overlay {
                            Circle()
                                .strokeBorder(AppColors.separator, lineWidth: 1)
                        }
                }
                .buttonStyle(PressButtonStyle())
                .accessibilityLabel("Close feedback")

                Spacer(minLength: 0)
            }
        }
        .padding(.top, AppSpacing.sm)
    }

    private var scenarioPill: some View {
        VStack(spacing: AppSpacing.sm) {
            Text(feedback.scenarioTitle)
                .font(AppFonts.display(24))
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.82)

            Text("With \(feedback.personaName)")
                .font(AppFonts.label(13, weight: .bold))
                .foregroundStyle(AppColors.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
        .padding(.horizontal, AppSpacing.xl)
        .padding(.vertical, AppSpacing.lg)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .fill(AppColors.accentSubtle.opacity(0.42))
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .strokeBorder(AppColors.accentMedium.opacity(0.72), lineWidth: 1)
        }
    }

    private var skillAnalysisSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Skill analysis")
                .font(AppFonts.display(24))
                .foregroundStyle(AppColors.textPrimary)

            VStack(spacing: AppSpacing.md) {
                ForEach(Array(feedback.skillAnalyses.enumerated()), id: \.element.id) { index, analysis in
                    SkillAnalysisCard(analysis: analysis)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 12)
                        .animation(
                            .spring(response: 0.42, dampingFraction: 0.84)
                                .delay(0.14 + Double(index) * 0.035),
                            value: appeared
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var overallFeedbackSection: some View {
        VStack(spacing: AppSpacing.md) {
            FeedbackTextCard(
                title: "What you did well overall",
                text: feedback.didWell,
                systemImage: "checkmark.seal.fill"
            )

            FeedbackTextCard(
                title: "What you could improve on overall",
                text: feedback.improve,
                systemImage: "arrow.up.forward.circle.fill"
            )
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .animation(.spring(response: 0.42, dampingFraction: 0.84).delay(0.46), value: appeared)
    }

}

private struct OverallScoreRing: View {
    let score: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.accentSubtle, lineWidth: 17)
                .frame(width: 190, height: 190)

            Circle()
                .trim(from: 0, to: scoreProgress)
                .stroke(
                    AppColors.accent,
                    style: StrokeStyle(lineWidth: 17, lineCap: .round)
                )
                .frame(width: 190, height: 190)
                .rotationEffect(.degrees(-104))

            VStack(spacing: AppSpacing.xs) {
                Text("\(score)")
                    .font(AppFonts.display(56))
                    .foregroundStyle(AppColors.textPrimary)
                    .monospacedDigit()

                Text("Overall")
                    .font(AppFonts.label(12, weight: .bold))
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .frame(width: 220, height: 220)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Overall score \(score) out of 100")
    }

    private var scoreProgress: CGFloat {
        CGFloat(score) / 100.0
    }
}

private struct SkillAnalysisCard: View {
    let analysis: SkillReviewAnalysis

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(alignment: .firstTextBaseline, spacing: AppSpacing.md) {
                Text(analysis.skill.title)
                    .font(AppFonts.title(17, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: AppSpacing.sm)

                Text("\(analysis.score)/100")
                    .font(AppFonts.title(20, weight: .bold))
                    .foregroundStyle(skillColor)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(skillColor.opacity(0.14))

                    Capsule()
                        .fill(skillColor)
                        .frame(width: proxy.size.width * progress)
                }
            }
            .frame(height: 12)

            Text(analysis.note)
                .font(AppFonts.body(15))
                .lineSpacing(4)
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
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
                .strokeBorder(AppColors.separator.opacity(0.72), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(analysis.skill.title), \(analysis.score) out of 100. \(analysis.note)")
    }

    private var progress: CGFloat {
        CGFloat(analysis.score) / 100.0
    }

    private var skillColor: Color {
        Color(hex: analysis.skill.colorHex)
    }
}

private struct FeedbackTextCard: View {
    let title: String
    let text: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: systemImage)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppColors.accent)
                    .accessibilityHidden(true)

                Text(title)
                    .font(AppFonts.title(18, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(text)
                .font(AppFonts.body(15))
                .lineSpacing(5)
                .foregroundStyle(AppColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .fill(AppColors.surface)
                .subtleShadow()
        }
    }
}

private struct PracticeNotesSection: View {
    @Binding var notes: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Practice notes")
                .font(AppFonts.display(22))
                .foregroundStyle(AppColors.textPrimary)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $notes)
                    .font(AppFonts.body(16))
                    .foregroundStyle(AppColors.textPrimary)
                    .lineSpacing(5)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 150)
                    .padding(AppSpacing.md)

                if notes.isEmpty {
                    Text("Write notes about this practice...")
                        .font(AppFonts.body(16))
                        .foregroundStyle(AppColors.textTertiary)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.lg)
                        .allowsHitTesting(false)
                }
            }
            .background(AppColors.surfaceRaised, in: RoundedRectangle(cornerRadius: AppRadius.lg))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .strokeBorder(AppColors.separator, lineWidth: 1)
            }
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .fill(AppColors.surface)
                .subtleShadow()
        }
    }
}

#Preview {
    NavigationStack {
        ReviewFeedbackScreen(
            feedback: ReviewFeedbackViewModel.seededFeedback(
                scenario: Scenario.all[3],
                persona: Persona.all[1]
            ),
            onClose: {}
        )
    }
}
