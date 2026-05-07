import SwiftUI

struct LearnScreen: View {
    @State private var appeared: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                header
                placeholderCard
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

    private var placeholderCard: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "book.fill")
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(AppColors.primary)
                .accessibilityHidden(true)

            Text("Lessons are on the way")
                .font(AppFonts.title(20, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)

            Text("Short, focused lessons on filler words, pacing, and tone will live here so you can study before you practice.")
                .font(AppFonts.body(15))
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
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

#Preview {
    NavigationStack {
        LearnScreen()
    }
}
