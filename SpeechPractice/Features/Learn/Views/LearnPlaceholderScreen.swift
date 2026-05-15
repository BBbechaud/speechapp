import SwiftUI

struct LearnScreen: View {
    @State private var appeared: Bool = false

    private let lessons: [LockedLessonNode] = [
        LockedLessonNode(title: "Clear openings", detail: "Start with ease", iconName: "bubble.left.and.text.bubble.right.fill", alignment: .leading, tint: AppColors.primary),
        LockedLessonNode(title: "Speaking rhythm", detail: "Pacing and pauses", iconName: "waveform", alignment: .trailing, tint: AppColors.accent),
        LockedLessonNode(title: "Active listening", detail: "Follow-up questions", iconName: "ear", alignment: .leading, tint: AppColors.success),
        LockedLessonNode(title: "Hard moments", detail: "Conflict practice", iconName: "bolt.fill", alignment: .trailing, tint: AppColors.warning),
        LockedLessonNode(title: "Better closings", detail: "End conversations well", iconName: "checkmark.bubble.fill", alignment: .leading, tint: AppColors.primary)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                header
                lockedLessonPath
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.xxl)
            .padding(.bottom, AppSpacing.xxxl)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)
            .animation(.spring(response: 0.45, dampingFraction: 0.84), value: appeared)
        }
        .background(AppColors.background)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            appeared = true
        }
    }

    private var header: some View {
        Text("Learn")
            .font(AppFonts.display(34))
            .foregroundStyle(AppColors.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }

    private var lockedLessonPath: some View {
        ZStack {
            lessonPathPreview
                .allowsHitTesting(false)
                .accessibilityHidden(true)

            comingSoonOverlay
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 560)
        .accessibilityElement(children: .contain)
    }

    private var lessonPathPreview: some View {
        ZStack {
            LockedLessonConnector()
                .stroke(
                    AppColors.grey100,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round)
                )
                .frame(width: 210, height: 410)
                .offset(y: 26)

            VStack(spacing: AppSpacing.lg) {
                ForEach(lessons) { lesson in
                    LockedLessonNodeView(lesson: lesson)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.xl)
        }
        .frame(maxWidth: .infinity)
        .grayscale(0.82)
        .opacity(0.46)
        .blur(radius: 5)
    }

    private var comingSoonOverlay: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "lock.fill")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(AppColors.primary)
                .accessibilityHidden(true)

            Text("Lessons are coming soon")
                .font(AppFonts.title(22, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)

            Text("Guided mini-lessons for pacing, clarity, tone, and confidence will unlock here soon.")
                .font(AppFonts.body(15))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: 300)
        .padding(AppSpacing.xl)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .fill(AppColors.surface)
                .cardShadow()
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .strokeBorder(AppColors.separator.opacity(0.72), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct LockedLessonNode: Identifiable {
    let id: UUID
    let title: String
    let detail: String
    let iconName: String
    let alignment: LockedLessonAlignment
    let tint: Color

    init(title: String, detail: String, iconName: String, alignment: LockedLessonAlignment, tint: Color) {
        self.id = UUID()
        self.title = title
        self.detail = detail
        self.iconName = iconName
        self.alignment = alignment
        self.tint = tint
    }
}

private enum LockedLessonAlignment {
    case leading
    case trailing

    var frameAlignment: Alignment {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}

private struct LockedLessonNodeView: View {
    let lesson: LockedLessonNode

    var body: some View {
        HStack {
            lessonContent
                .frame(width: 214)
        }
        .frame(maxWidth: .infinity, alignment: lesson.alignment.frameAlignment)
    }

    private var lessonContent: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(lesson.tint.opacity(0.16))
                    .frame(width: 54, height: 54)

                Image(systemName: lesson.iconName)
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(lesson.tint.opacity(0.82))
            }

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(lesson.title)
                    .font(AppFonts.title(15, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(1)

                Text(lesson.detail)
                    .font(AppFonts.body(12, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(AppSpacing.md)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .fill(AppColors.surface)
                .subtleShadow()
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .strokeBorder(AppColors.separator.opacity(0.72), lineWidth: 1)
        }
    }
}

private struct LockedLessonConnector: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let leftX = rect.minX + 42
        let rightX = rect.maxX - 42
        let centerX = rect.midX
        let topY = rect.minY + 16
        let firstTurnY = rect.minY + 100
        let secondTurnY = rect.minY + 190
        let thirdTurnY = rect.minY + 282
        let bottomY = rect.maxY - 18

        path.move(to: CGPoint(x: leftX, y: topY))
        path.addCurve(
            to: CGPoint(x: rightX, y: firstTurnY),
            control1: CGPoint(x: leftX, y: topY + 62),
            control2: CGPoint(x: centerX, y: firstTurnY)
        )
        path.addLine(to: CGPoint(x: rightX, y: secondTurnY))
        path.addCurve(
            to: CGPoint(x: leftX, y: thirdTurnY),
            control1: CGPoint(x: rightX, y: secondTurnY + 54),
            control2: CGPoint(x: centerX, y: thirdTurnY)
        )
        path.addLine(to: CGPoint(x: leftX, y: bottomY))

        return path
    }
}

#Preview {
    NavigationStack {
        LearnScreen()
    }
}
