import SwiftUI

struct DifficultyBadge: View {
    let difficulty: PracticeDifficulty

    var body: some View {
        Text(difficulty.label)
            .font(AppFonts.label(11, weight: .semibold))
            .foregroundStyle(difficulty.foregroundColor)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, 3)
            .background(difficulty.backgroundColor, in: Capsule())
    }
}

struct TimeBadge: View {
    let duration: String

    var body: some View {
        Text(duration)
            .font(AppFonts.label(11, weight: .semibold))
            .foregroundStyle(AppColors.primary)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, 3)
            .background(AppColors.primarySubtle, in: Capsule())
    }
}

extension PracticeDifficulty {
    var label: String {
        switch self {
        case .easy:   return "Easy"
        case .medium: return "Medium"
        case .hard:   return "Hard"
        }
    }

    var foregroundColor: Color {
        switch self {
        case .easy:   return AppColors.easyFg
        case .medium: return AppColors.mediumFg
        case .hard:   return AppColors.hardFg
        }
    }

    var backgroundColor: Color {
        switch self {
        case .easy:   return AppColors.easyBg
        case .medium: return AppColors.mediumBg
        case .hard:   return AppColors.hardBg
        }
    }
}

#Preview {
    HStack(spacing: 8) {
        DifficultyBadge(difficulty: .easy)
        DifficultyBadge(difficulty: .medium)
        DifficultyBadge(difficulty: .hard)
        TimeBadge(duration: "2-3 min")
    }
    .padding()
}
