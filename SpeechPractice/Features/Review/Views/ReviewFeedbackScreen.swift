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

                heroCard
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 14)
                    .animation(.spring(response: 0.48, dampingFraction: 0.82).delay(0.04), value: appeared)

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

    // MARK: - Header

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

    // MARK: - Hero Card

    private var heroCard: some View {
        VStack(spacing: AppSpacing.xl) {
            VStack(spacing: AppSpacing.xs) {
                Text(feedback.scenarioTitle)
                    .font(AppFonts.display(30))
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.82)
                    .frame(maxWidth: .infinity)

                Text("\(feedback.personaName) · \(feedback.difficulty.rawValue.capitalized)")
                    .font(AppFonts.body(16, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            OverallScoreRing(score: feedback.overallScore)
                .scaleEffect(appeared ? 1 : 0.88)
                .animation(.spring(response: 0.56, dampingFraction: 0.76).delay(0.10), value: appeared)

            HStack(spacing: AppSpacing.sm) {
                SessionStatPill(systemImage: "clock", label: formattedDuration(feedback.durationSeconds))
                SessionStatPill(systemImage: "person.fill", label: "You \(feedback.userSpeakingPercent)%")
                SessionStatPill(systemImage: "waveform", label: "\(feedback.personaName) \(100 - feedback.userSpeakingPercent)%")
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, AppSpacing.xl)
        .padding(.horizontal, AppSpacing.lg)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .fill(AppColors.surface)
                .cardShadow()
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .strokeBorder(AppColors.separator.opacity(0.55), lineWidth: 1)
        }
    }

    private func formattedDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remaining = seconds % 60
        return "\(minutes)m \(remaining)s"
    }

    // MARK: - Skill Analysis

    private var skillAnalysisSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionLabel(title: "Skill Analysis")

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

    // MARK: - Overall Feedback

    private var overallFeedbackSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionLabel(title: "Overall Feedback")

            VStack(spacing: AppSpacing.md) {
                FeedbackTextCard(
                    title: "What you did well",
                    text: feedback.didWell,
                    systemImage: "checkmark.circle.fill",
                    tint: AppColors.success,
                    background: AppColors.successBg,
                    border: Color(hex: "#C9F6DA")
                )

                FeedbackTextCard(
                    title: "What to improve",
                    text: feedback.improve,
                    systemImage: "arrow.up.forward.circle.fill",
                    tint: AppColors.primary,
                    background: AppColors.primarySubtle,
                    border: AppColors.primaryMedium.opacity(0.5)
                )
            }
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .animation(.spring(response: 0.42, dampingFraction: 0.84).delay(0.46), value: appeared)
    }
}

// MARK: - Section Label

private struct SectionLabel: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(AppFonts.label(12, weight: .bold))
            .foregroundStyle(AppColors.textTertiary)
            .kerning(0.6)
    }
}

// MARK: - Overall Score Ring

private struct OverallScoreRing: View {
    let score: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.primarySubtle, lineWidth: 17)
                .frame(width: 190, height: 190)

            Circle()
                .trim(from: 0, to: scoreProgress)
                .stroke(
                    AppColors.primary,
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

// MARK: - Skill Analysis Card

private struct SkillAnalysisCard: View {
    let analysis: SkillReviewAnalysis

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(alignment: .center, spacing: AppSpacing.md) {
                Image(systemName: analysis.skill.systemImage)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(skillColor)
                    .frame(width: 32)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    HStack(alignment: .firstTextBaseline, spacing: AppSpacing.xs) {
                        Text(analysis.skill.title)
                            .font(AppFonts.title(17, weight: .bold))
                            .foregroundStyle(AppColors.textPrimary)
                            .lineLimit(1)

                        Text("+\(xpEarned) XP")
                            .font(AppFonts.label(13, weight: .bold))
                            .foregroundStyle(AppColors.xpMetricGold)
                            .lineLimit(1)

                        Spacer(minLength: AppSpacing.xs)

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
                }
            }

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

    private var progress: CGFloat { CGFloat(analysis.score) / 100.0 }
    private var skillColor: Color { Color(hex: analysis.skill.colorHex) }
    private var xpEarned: Int { analysis.score / 2 }
}

// MARK: - Feedback Text Card

private struct FeedbackTextCard: View {
    let title: String
    let text: String
    let systemImage: String
    let tint: Color
    let background: Color
    let border: Color

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(tint)
                    .accessibilityHidden(true)

                Text(title)
                    .font(AppFonts.title(17, weight: .bold))
                    .foregroundStyle(tint)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(text)
                .font(AppFonts.body(15))
                .lineSpacing(5)
                .foregroundStyle(AppColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .strokeBorder(border, lineWidth: 1)
        }
    }
}

// MARK: - Practice Notes

private struct PracticeNotesSection: View {
    @Binding var notes: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Practice notes")
                .font(AppFonts.title(18, weight: .bold))
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

// MARK: - Session Stat Pill

private struct SessionStatPill: View {
    let systemImage: String
    let label: String

    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: systemImage)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(AppColors.textSecondary)
                .accessibilityHidden(true)

            Text(label)
                .font(AppFonts.label(13, weight: .semibold))
                .foregroundStyle(AppColors.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.background, in: Capsule())
        .overlay {
            Capsule()
                .strokeBorder(AppColors.separator, lineWidth: 1)
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
