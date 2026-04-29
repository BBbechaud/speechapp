import SwiftUI

struct ProfileScreen: View {
    @State private var selectedTab: ProfileTab = .skills
    @State private var appeared = false

    private let overview = ProfileOverview(
        streakDays: 12,
        level: "Gold",
        practicedMinutes: 1_110,
        totalXP: 4_120
    )

    private let skills: [ProfileSkill] = makeProfileSkills()

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xl) {
                header
                overviewSection
                profileTabs
                selectedTabContent
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, AppSpacing.xxxl)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)
            .animation(.spring(response: 0.45, dampingFraction: 0.82), value: appeared)
        }
        .background(AppColors.background)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            appeared = true
        }
    }

    private var header: some View {
        VStack(spacing: AppSpacing.lg) {
            ZStack {
                Text("Profile")
                    .font(AppFonts.title(20, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(maxWidth: .infinity)

                HStack {
                    Spacer()

                    Button {} label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(AppColors.textPrimary)
                            .frame(width: 46, height: 46)
                            .background(AppColors.surfaceRaised, in: Circle())
                            .overlay {
                                Circle()
                                    .strokeBorder(AppColors.separator, lineWidth: 1)
                            }
                    }
                    .buttonStyle(PressButtonStyle())
                    .accessibilityLabel("Settings")
                }
            }

            VStack(spacing: AppSpacing.md) {
                ProfileAvatar()

                VStack(spacing: AppSpacing.xs) {
                    Text("Brian Bechaud")
                        .font(AppFonts.display(28))
                        .foregroundStyle(AppColors.textPrimary)
                        .multilineTextAlignment(.center)

                    Text("Communication Enthusiast")
                        .font(AppFonts.body(16))
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            Text("Overview")
                .font(AppFonts.title(20, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)

            HStack(alignment: .top, spacing: AppSpacing.lg) {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    OverviewMetricRow(
                        systemImage: "flame.fill",
                        value: formattedStreakDays(overview.streakDays),
                        tint: AppColors.textTertiary
                    )

                    OverviewMetricRow(
                        systemImage: "rosette",
                        value: overview.level,
                        tint: AppColors.accent
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    OverviewMetricRow(
                        systemImage: "clock.fill",
                        value: formattedPracticeTime(minutes: overview.practicedMinutes),
                        tint: AppColors.textTertiary
                    )

                    OverviewMetricRow(
                        systemImage: "bolt.fill",
                        value: "\(formattedWholeNumber(overview.totalXP)) XP",
                        tint: AppColors.accent
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .contain)
    }

    private func formattedStreakDays(_ days: Int) -> String {
        if days == 1 {
            return "one day"
        }

        return "\(days) days"
    }

    private func formattedPracticeTime(minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) min"
        }

        let hours: Double = Double(minutes) / 60.0
        if minutes.isMultiple(of: 60) {
            return "\(Int(hours)) hours"
        }

        return String(format: "%.1f hours", hours)
    }

    private func formattedWholeNumber(_ value: Int) -> String {
        let digits = String(value)
        let reversedGroups: [String] = stride(from: digits.count, to: 0, by: -3).map { endIndex in
            let startIndex: Int = max(endIndex - 3, 0)
            let start = digits.index(digits.startIndex, offsetBy: startIndex)
            let end = digits.index(digits.startIndex, offsetBy: endIndex)
            return String(digits[start..<end])
        }

        return reversedGroups.reversed().joined(separator: ",")
    }

    private var profileTabs: some View {
        HStack(spacing: AppSpacing.xs) {
            ForEach(ProfileTab.allCases) { tab in
                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                        selectedTab = tab
                    }
                } label: {
                    Text(tab.title)
                        .font(AppFonts.title(17, weight: selectedTab == tab ? .bold : .semibold))
                        .foregroundStyle(selectedTab == tab ? AppColors.accent : AppColors.textTertiary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background {
                            if selectedTab == tab {
                                Capsule()
                                    .fill(AppColors.surface)
                                    .subtleShadow()
                                    .overlay {
                                        Capsule()
                                            .strokeBorder(AppColors.separator.opacity(0.68), lineWidth: 1)
                                    }
                            }
                        }
                        .contentShape(Capsule())
                    }
                .buttonStyle(PressButtonStyle())
                .accessibilityLabel(tab.title)
                .accessibilityAddTraits(selectedTab == tab ? .isSelected : [])
            }
        }
        .padding(AppSpacing.xs)
        .background {
            Capsule()
                .fill(AppColors.surfaceRaised)
        }
        .overlay {
            Capsule()
                .strokeBorder(AppColors.separator, lineWidth: 1)
        }
        .padding(.top, AppSpacing.xs)
    }

    @ViewBuilder
    private var selectedTabContent: some View {
        switch selectedTab {
        case .progress:
            ProfileEmptyTabView(
                systemImage: "chart.line.uptrend.xyaxis",
                title: "Progress snapshots are coming soon",
                detail: "Your strongest trends will live here after more practice sessions."
            )
        case .skills:
            VStack(spacing: AppSpacing.md) {
                ForEach(skills) { skill in
                    NavigationLink {
                        ProfileSkillDetailScreen(detail: skill.detail)
                    } label: {
                        ProfileSkillRow(skill: skill)
                    }
                    .buttonStyle(.plain)
                }
            }
        case .badges:
            ProfileEmptyTabView(
                systemImage: "medal.fill",
                title: "Badges are warming up",
                detail: "Milestones for streaks, hard scenarios, and first wins will appear here."
            )
        }
    }
}

private enum ProfileTab: String, CaseIterable, Identifiable {
    case progress
    case skills
    case badges

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .progress: return "Progress"
        case .skills: return "Skills"
        case .badges: return "Badges"
        }
    }
}

private func makeProfileSkills() -> [ProfileSkill] {
    CommunicationSkill.all.map { skill in
        ProfileSkill(skill: skill, detail: profileSkillDetail(for: skill))
    }
}

private func profileSkillDetail(for skill: CommunicationSkill) -> ProfileSkillDetail {
    switch skill.id {
    case .fillerWords:
        return ProfileSkillDetail(
            skill: skill,
            totalXP: 2_640,
            level: 7,
            currentLevelXP: 420,
            nextLevelXP: 700,
            description: skill.definition,
            improvementTip: "Pause for one beat when you need time to think, then restart with the next clear word.",
            strength: "You recover quickly after filler words and usually return to your point without losing the listener.",
            weakness: "Fillers still show up when the question is unexpected or when you are trying to soften a direct answer.",
            trendPoints: [54, 58, 62, 61, 66, 70]
        )
    case .flow:
        return ProfileSkillDetail(
            skill: skill,
            totalXP: 3_100,
            level: 8,
            currentLevelXP: 200,
            nextLevelXP: 800,
            description: "Flow is the rhythm and continuity of your speech. It is about how smoothly you move from one thought to the next without abrupt stops or disjointed phrasing.",
            improvementTip: "Use logical connectors like \"because,\" \"so,\" and \"what that means is\" to bridge ideas more naturally.",
            strength: "Excellent smooth transitions when explaining concepts within your comfort zone.",
            weakness: "Flow tends to break down and become staccato when introducing new or complex details.",
            trendPoints: [55, 60, 58, 66, 72, 78]
        )
    case .articulation:
        return ProfileSkillDetail(
            skill: skill,
            totalXP: 3_420,
            level: 8,
            currentLevelXP: 520,
            nextLevelXP: 800,
            description: skill.definition,
            improvementTip: "Lead with the simplest version of the idea first, then add one concrete example if the listener needs more.",
            strength: "Your main ideas are easy to follow, especially when you slow down before important points.",
            weakness: "Clarity dips when you stack multiple examples before naming the central point.",
            trendPoints: [63, 66, 71, 74, 79, 83]
        )
    case .conciseness:
        return ProfileSkillDetail(
            skill: skill,
            totalXP: 2_180,
            level: 6,
            currentLevelXP: 480,
            nextLevelXP: 700,
            description: skill.definition,
            improvementTip: "Answer first, then add only the strongest supporting detail before giving the other person room.",
            strength: "You can land direct answers when the goal of the conversation is clear.",
            weakness: "You sometimes keep explaining after the listener already has enough context.",
            trendPoints: [52, 55, 57, 61, 64, 68]
        )
    case .pitch:
        return ProfileSkillDetail(
            skill: skill,
            totalXP: 2_760,
            level: 7,
            currentLevelXP: 540,
            nextLevelXP: 700,
            description: skill.definition,
            improvementTip: "Let key statements finish with a calm downward tone so they sound settled instead of tentative.",
            strength: "Your tone reads warm and approachable in low-pressure moments.",
            weakness: "Your pitch can rise at the end of decisive statements, making strong points sound like questions.",
            trendPoints: [58, 63, 65, 64, 70, 76]
        )
    case .rapport:
        return ProfileSkillDetail(
            skill: skill,
            totalXP: 3_240,
            level: 8,
            currentLevelXP: 360,
            nextLevelXP: 800,
            description: skill.definition,
            improvementTip: "Reflect one specific thing the other person said before adding your own point.",
            strength: "You keep conversations respectful and collaborative, even when the other person pushes back.",
            weakness: "You can miss chances to name the other person’s emotion before moving into problem-solving.",
            trendPoints: [64, 68, 72, 76, 79, 81]
        )
    case .listening:
        return ProfileSkillDetail(
            skill: skill,
            totalXP: 2_900,
            level: 7,
            currentLevelXP: 620,
            nextLevelXP: 700,
            description: skill.definition,
            improvementTip: "Repeat the core concern in your own words before responding with advice or explanation.",
            strength: "You usually respond to the concern that was actually raised instead of changing the subject.",
            weakness: "Your responses sometimes skip the reflection step and move straight into your own reasoning.",
            trendPoints: [61, 65, 67, 72, 75, 79]
        )
    case .situationHandling:
        return ProfileSkillDetail(
            skill: skill,
            totalXP: 2_520,
            level: 7,
            currentLevelXP: 340,
            nextLevelXP: 700,
            description: skill.definition,
            improvementTip: "Before speaking, choose the one outcome the moment needs: clarify, reassure, ask, decide, or close.",
            strength: "You stay oriented to the scenario goal and avoid getting pulled too far off track.",
            weakness: "Closings can be more decisive when the conversation needs a clear next step.",
            trendPoints: [56, 59, 63, 67, 70, 73]
        )
    }
}

private struct ProfileOverview {
    let streakDays: Int
    let level: String
    let practicedMinutes: Int
    let totalXP: Int
}

private struct ProfileSkill: Identifiable {
    let id: CommunicationSkillID
    let title: String
    let systemImage: String
    let color: Color
    let detail: ProfileSkillDetail

    init(skill: CommunicationSkill, detail: ProfileSkillDetail) {
        self.id = skill.id
        self.title = skill.title
        self.systemImage = skill.systemImage
        self.color = Color(hex: skill.colorHex)
        self.detail = detail
    }
}

private struct ProfileSkillDetail: Identifiable {
    let id: CommunicationSkillID
    let title: String
    let systemImage: String
    let color: Color
    let totalXP: Int
    let level: Int
    let currentLevelXP: Int
    let nextLevelXP: Int
    let description: String
    let improvementTip: String
    let strength: String
    let weakness: String
    let trendPoints: [Int]

    init(
        skill: CommunicationSkill,
        totalXP: Int,
        level: Int,
        currentLevelXP: Int,
        nextLevelXP: Int,
        description: String,
        improvementTip: String,
        strength: String,
        weakness: String,
        trendPoints: [Int]
    ) {
        self.id = skill.id
        self.title = skill.title
        self.systemImage = skill.systemImage
        self.color = Color(hex: skill.colorHex)
        self.totalXP = totalXP
        self.level = level
        self.currentLevelXP = currentLevelXP
        self.nextLevelXP = nextLevelXP
        self.description = description
        self.improvementTip = improvementTip
        self.strength = strength
        self.weakness = weakness
        self.trendPoints = trendPoints
    }
}

private struct ProfileAvatar: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                Circle()
                    .fill(AppColors.accent.opacity(0.72))
                    .frame(width: 112, height: 112)

                Circle()
                    .fill(Color(hex: "#1263A4"))
                    .frame(width: 98, height: 98)

                Text("B")
                    .font(.system(size: 58, weight: .regular, design: .rounded))
                    .foregroundStyle(.white)
            }
            .overlay {
                Circle()
                    .strokeBorder(AppColors.surface, lineWidth: 5)
                    .frame(width: 102, height: 102)
            }

            Text("PRO")
                .font(AppFonts.label(12, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
                .background(AppColors.accent, in: Capsule())
                .shadow(color: AppColors.accent.opacity(0.28), radius: 8, x: 0, y: 4)
                .offset(y: AppSpacing.sm)
        }
        .padding(.bottom, AppSpacing.sm)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Brian Bechaud profile avatar, pro member")
    }
}

private struct OverviewMetricRow: View {
    let systemImage: String
    let value: String
    let tint: Color

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(tint)
                .frame(width: 32, height: 32)
                .accessibilityHidden(true)

            Text(value)
                .font(AppFonts.title(24, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct SkillXPBarWithEndCap: View {
    let systemImage: String
    let tint: Color
    let progress: CGFloat

    private let barHeight: CGFloat = 10
    private let circleSize: CGFloat = 26
    private let overlap: CGFloat = 3

    private func leadingTrackShape(barHeight: CGFloat) -> UnevenRoundedRectangle {
        let radius = barHeight / 2
        return UnevenRoundedRectangle(
            topLeadingRadius: radius,
            bottomLeadingRadius: radius,
            bottomTrailingRadius: 0,
            topTrailingRadius: 0,
            style: .continuous
        )
    }

    var body: some View {
        GeometryReader { proxy in
            let totalWidth = proxy.size.width
            let barTrackWidth = max(barHeight, totalWidth - circleSize + overlap)
            let clampedProgress = min(1, max(0, progress))
            let fillWidth = barTrackWidth * clampedProgress

            HStack(alignment: .center, spacing: -overlap) {
                ZStack(alignment: .leading) {
                    leadingTrackShape(barHeight: barHeight)
                        .fill(AppColors.separator)

                    Rectangle()
                        .fill(tint.opacity(0.78))
                        .frame(width: fillWidth)
                }
                .frame(width: barTrackWidth, height: barHeight)
                .clipShape(leadingTrackShape(barHeight: barHeight))
                .overlay {
                    leadingTrackShape(barHeight: barHeight)
                        .strokeBorder(AppColors.xpMeterStroke, lineWidth: 1)
                }

                ZStack {
                    Circle()
                        .fill(AppColors.separator)

                    Image(systemName: systemImage)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(tint)
                }
                .frame(width: circleSize, height: circleSize)
                .overlay {
                    Circle()
                        .strokeBorder(AppColors.surface, lineWidth: 2)
                }
                .overlay {
                    Circle()
                        .strokeBorder(AppColors.xpMeterStroke, lineWidth: 1)
                }
                .accessibilityHidden(true)
            }
            .frame(width: totalWidth, height: circleSize)
        }
        .frame(height: circleSize)
    }
}

private struct ProfileSkillRow: View {
    let skill: ProfileSkill

    private var levelProgressToNext: CGFloat {
        guard skill.detail.nextLevelXP > 0 else {
            return 0
        }

        let progress = CGFloat(skill.detail.currentLevelXP) / CGFloat(skill.detail.nextLevelXP)
        return min(1, max(0, progress))
    }

    var body: some View {
        HStack(spacing: AppSpacing.base) {
            Image(systemName: skill.systemImage)
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(skill.color)
                .frame(width: 56, height: 56)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(skill.title)
                        .font(AppFonts.title(19, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)

                    HStack(alignment: .firstTextBaseline) {
                        Text("Level \(skill.detail.level)")
                            .font(AppFonts.label(14, weight: .bold))
                            .foregroundStyle(AppColors.xpMetricGold)
                            .textCase(.uppercase)

                        Spacer(minLength: AppSpacing.md)

                        Text("\(skill.detail.currentLevelXP) / \(skill.detail.nextLevelXP) XP")
                            .font(AppFonts.label(14, weight: .bold))
                            .foregroundStyle(AppColors.xpMetricGold)
                            .monospacedDigit()
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }

                SkillXPBarWithEndCap(
                    systemImage: skill.systemImage,
                    tint: skill.color,
                    progress: levelProgressToNext
                )
            }
        }
        .padding(AppSpacing.base)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(AppColors.surface)
                .subtleShadow()
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .strokeBorder(AppColors.separator, lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(skill.title), Level \(skill.detail.level), \(skill.detail.currentLevelXP) out of \(skill.detail.nextLevelXP) XP toward next level")
    }
}

private struct ProfileSkillDetailScreen: View {
    let detail: ProfileSkillDetail

    @Environment(\.dismiss) private var dismiss
    @State private var appeared: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                header
                masteryCard
                descriptionSection
                performanceSection
            }
            .padding(.horizontal, AppSpacing.base)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.xxxl)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)
            .animation(.spring(response: 0.45, dampingFraction: 0.84), value: appeared)
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
            Text("Skill Progress")
                .font(AppFonts.title(20, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(AppColors.textPrimary)
                        .frame(width: 56, height: 56)
                        .background(AppColors.surfaceRaised, in: Circle())
                        .overlay {
                            Circle()
                                .strokeBorder(AppColors.separator, lineWidth: 1)
                        }
                }
                .buttonStyle(PressButtonStyle())
                .accessibilityLabel("Close")

                Spacer(minLength: 0)
            }
        }
        .accessibilityAddTraits(.isHeader)
    }

    private var masteryCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xl) {
            HStack(spacing: AppSpacing.base) {
                Image(systemName: detail.systemImage)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppColors.accent)
                    .frame(width: 72, height: 72)
                    .background(AppColors.accentSubtle, in: Circle())
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(detail.title)
                        .font(AppFonts.title(22, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)

                    Text("Total XP: \(formattedWholeNumber(detail.totalXP))")
                        .font(AppFonts.body(17, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)
                        .monospacedDigit()
                }
            }

            VStack(spacing: AppSpacing.md) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Level \(detail.level)")
                        .font(AppFonts.label(14, weight: .bold))
                        .foregroundStyle(AppColors.accent)
                        .textCase(.uppercase)

                    Spacer(minLength: AppSpacing.md)

                    Text("\(detail.currentLevelXP) / \(detail.nextLevelXP) XP")
                        .font(AppFonts.label(14, weight: .bold))
                        .foregroundStyle(AppColors.textSecondary)
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                ProgressCapsule(progress: levelProgress, foregroundColor: AppColors.accent, backgroundColor: AppColors.accentSubtle)
                    .frame(height: 13)
            }
        }
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(detail.title). Total XP \(detail.totalXP). Level \(detail.level). \(detail.currentLevelXP) of \(detail.nextLevelXP) XP until next level.")
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("What is \(detail.title)?")
                .font(AppFonts.display(24))
                .foregroundStyle(AppColors.textPrimary)

            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                Text(detail.description)
                    .font(AppFonts.body(18))
                    .lineSpacing(7)
                    .foregroundStyle(AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                Rectangle()
                    .fill(AppColors.separator.opacity(0.72))
                    .frame(height: 1)

                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("How to improve")
                        .font(AppFonts.label(16, weight: .bold))
                        .foregroundStyle(AppColors.accent)
                        .textCase(.uppercase)

                    Text("\"\(detail.improvementTip)\"")
                        .font(AppFonts.body(16, weight: .medium))
                        .italic()
                        .lineSpacing(4)
                        .foregroundStyle(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(AppSpacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: AppRadius.xxl)
                    .fill(AppColors.surface)
                    .subtleShadow()
            }
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.xxl)
                    .strokeBorder(AppColors.separator.opacity(0.72), lineWidth: 1)
            }
        }
    }

    private var performanceSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Performance Insight")
                .font(AppFonts.display(24))
                .foregroundStyle(AppColors.textPrimary)

            PerformanceInsightCard(
                title: "Strength",
                detail: detail.strength,
                systemImage: "star.fill",
                tint: Color(hex: "#08A64B"),
                background: Color(hex: "#ECFFF4"),
                border: Color(hex: "#C9F6DA")
            )

            PerformanceInsightCard(
                title: "Weakness",
                detail: detail.weakness,
                systemImage: "exclamationmark.octagon.fill",
                tint: Color(hex: "#ED1C2F"),
                background: Color(hex: "#FFF1F1"),
                border: Color(hex: "#FFD4D6")
            )

            SkillTrendCard(points: detail.trendPoints, tint: AppColors.accent)
        }
    }

    private var levelProgress: CGFloat {
        guard detail.nextLevelXP > 0 else {
            return 0
        }

        let progress: CGFloat = CGFloat(detail.currentLevelXP) / CGFloat(detail.nextLevelXP)
        return min(1, max(0, progress))
    }

    private func formattedWholeNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        guard let formattedValue = formatter.string(from: NSNumber(value: value)) else {
            return "\(value)"
        }

        return formattedValue
    }
}

private struct ProgressCapsule: View {
    let progress: CGFloat
    let foregroundColor: Color
    let backgroundColor: Color

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(backgroundColor)

                Capsule()
                    .fill(foregroundColor)
                    .frame(width: max(0, proxy.size.width * progress))
            }
        }
    }
}

private struct PerformanceInsightCard: View {
    let title: String
    let detail: String
    let systemImage: String
    let tint: Color
    let background: Color
    let border: Color

    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.lg) {
            Image(systemName: systemImage)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(tint)
                .frame(width: 64, height: 64)
                .background(tint.opacity(0.12), in: Circle())
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(title)
                    .font(AppFonts.title(20, weight: .bold))
                    .foregroundStyle(tint)

                Text(detail)
                    .font(AppFonts.body(16))
                    .lineSpacing(4)
                    .foregroundStyle(tint.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .fill(background)
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .strokeBorder(border, lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title). \(detail)")
    }
}

private struct SkillTrendCard: View {
    let points: [Int]
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Skill Trend")
                        .font(AppFonts.title(20, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)

                    Text("Last 6 sessions")
                        .font(AppFonts.body(14, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)
                }

                Spacer(minLength: AppSpacing.md)

                Text(trendLabel)
                    .font(AppFonts.label(14, weight: .bold))
                    .foregroundStyle(tint)
                    .monospacedDigit()
            }

            TrendLineChart(points: points, tint: tint)
                .frame(height: 132)
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .fill(AppColors.surface)
                .subtleShadow()
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .strokeBorder(AppColors.separator.opacity(0.72), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Skill trend across the last 6 sessions. \(trendLabel).")
    }

    private var trendLabel: String {
        guard let firstPoint = points.first, let lastPoint = points.last else {
            return "No data"
        }

        let change: Int = lastPoint - firstPoint
        if change >= 0 {
            return "+\(change) pts"
        }

        return "\(change) pts"
    }
}

private struct TrendLineChart: View {
    let points: [Int]
    let tint: Color

    var body: some View {
        GeometryReader { proxy in
            let chartPoints: [CGPoint] = normalizedPoints(in: proxy.size)

            ZStack {
                VStack(spacing: 0) {
                    ForEach(0..<4, id: \.self) { _ in
                        Rectangle()
                            .fill(AppColors.separator.opacity(0.55))
                            .frame(height: 1)

                        Spacer(minLength: 0)
                    }
                }

                Path { path in
                    guard let firstPoint = chartPoints.first else {
                        return
                    }

                    path.move(to: firstPoint)

                    for point in chartPoints.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(tint, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))

                ForEach(Array(chartPoints.enumerated()), id: \.offset) { _, point in
                    Circle()
                        .fill(AppColors.surface)
                        .frame(width: 14, height: 14)
                        .overlay {
                            Circle()
                                .strokeBorder(tint, lineWidth: 4)
                        }
                        .position(point)
                }
            }
        }
    }

    private func normalizedPoints(in size: CGSize) -> [CGPoint] {
        guard points.isEmpty == false else {
            return []
        }

        let minimumPoint: Int = points.min() ?? 0
        let maximumPoint: Int = points.max() ?? 100
        let range: Int = max(1, maximumPoint - minimumPoint)
        let horizontalStep: CGFloat = points.count > 1 ? size.width / CGFloat(points.count - 1) : 0

        return points.enumerated().map { index, value in
            let xPosition: CGFloat = CGFloat(index) * horizontalStep
            let normalizedValue: CGFloat = CGFloat(value - minimumPoint) / CGFloat(range)
            let yPosition: CGFloat = size.height - (normalizedValue * size.height)
            return CGPoint(x: xPosition, y: yPosition)
        }
    }
}

private struct ProfileEmptyTabView: View {
    let systemImage: String
    let title: String
    let detail: String

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: systemImage)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(AppColors.accent)
                .accessibilityHidden(true)

            Text(title)
                .font(AppFonts.title(17, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)

            Text(detail)
                .font(AppFonts.body(14))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.xl)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(AppColors.surface)
                .subtleShadow()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileScreen()
    }
}
