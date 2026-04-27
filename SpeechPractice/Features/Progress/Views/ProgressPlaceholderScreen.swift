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

    private let skills: [ProfileSkill] = [
        ProfileSkill(title: "Breath Focus", level: "Level 1", progress: 0.50, systemImage: "wind"),
        ProfileSkill(title: "Body Scan", level: "Level 1", progress: 0.08, systemImage: "figure.mind.and.body"),
        ProfileSkill(title: "Labeling", level: "Level 1", progress: 0.12, systemImage: "tag.fill"),
        ProfileSkill(title: "Loving-Kindness", level: "Level 1", progress: 0.28, systemImage: "heart.fill"),
    ]

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
        HStack(spacing: 0) {
            ForEach(ProfileTab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: AppSpacing.sm) {
                        Text(tab.title)
                            .font(AppFonts.title(18, weight: selectedTab == tab ? .bold : .regular))
                            .foregroundStyle(selectedTab == tab ? AppColors.textPrimary : AppColors.textTertiary)
                            .frame(maxWidth: .infinity)

                        Capsule()
                            .fill(selectedTab == tab ? AppColors.textPrimary : Color.clear)
                            .frame(width: 64, height: 3)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.title)
            }
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
                    ProfileSkillRow(skill: skill)
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

private struct ProfileOverview {
    let streakDays: Int
    let level: String
    let practicedMinutes: Int
    let totalXP: Int
}

private struct ProfileSkill: Identifiable {
    let id: String
    let title: String
    let level: String
    let progress: CGFloat
    let systemImage: String

    init(title: String, level: String, progress: CGFloat, systemImage: String) {
        self.id = title
        self.title = title
        self.level = level
        self.progress = progress
        self.systemImage = systemImage
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

private struct ProfileSkillRow: View {
    let skill: ProfileSkill

    var body: some View {
        HStack(spacing: AppSpacing.base) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(AppColors.accentSubtle)
                    .frame(width: 72, height: 72)

                Image(systemName: skill.systemImage)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(AppColors.accent.opacity(0.82))
                    .accessibilityHidden(true)
            }

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(skill.title)
                    .font(AppFonts.title(22, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)

                Text(skill.level)
                    .font(AppFonts.body(17))
                    .foregroundStyle(AppColors.textTertiary)

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(AppColors.separator)

                        Capsule()
                            .fill(AppColors.accent.opacity(0.68))
                            .frame(width: proxy.size.width * skill.progress)
                    }
                }
                .frame(height: 10)
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
        .accessibilityLabel("\(skill.title), \(skill.level), \(Int(skill.progress * 100)) percent complete")
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
