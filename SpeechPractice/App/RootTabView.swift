import SwiftUI

private enum MainTab: Hashable, CaseIterable {
    case practice
    case feedback
    case profile

    var label: String {
        switch self {
        case .practice: return "Practice"
        case .feedback: return "Feedback"
        case .profile:  return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .practice: return "mic.circle.fill"
        case .feedback: return "text.bubble.fill"
        case .profile:  return "person.fill"
        }
    }
}

struct RootTabView: View {
    @State private var selectedTab: MainTab = .practice
    @State private var reviewRecords: [ReviewSessionRecord] = ReviewHistoryStore.loadRecords()
    @State private var practiceFlowViewModel = PracticeFlowViewModel()

    var body: some View {
        ZStack {
            // Practice tab
            NavigationStack(path: $practiceFlowViewModel.navigationPath) {
                PracticeHomeScreen(
                    viewModel: practiceFlowViewModel,
                    onReviewFeedbackClosed: { record in
                        reviewRecords = ReviewHistoryStore.record(record, in: reviewRecords)
                        selectedTab = .feedback
                    }
                )
            }
            .opacity(selectedTab == .practice ? 1 : 0)
            .allowsHitTesting(selectedTab == .practice)

            // Feedback tab
            NavigationStack {
                ReviewHistoryScreen(records: reviewRecords)
            }
            .opacity(selectedTab == .feedback ? 1 : 0)
            .allowsHitTesting(selectedTab == .feedback)

            // Profile tab
            NavigationStack {
                ProfileScreen()
            }
            .opacity(selectedTab == .profile ? 1 : 0)
            .allowsHitTesting(selectedTab == .profile)
        }
        .animation(.easeInOut(duration: 0.18), value: selectedTab)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            AppTabBar(selectedTab: $selectedTab)
        }
        .tint(AppColors.primary)
    }
}

// MARK: - Custom Tab Bar

private struct AppTabBar: View {
    @Binding var selectedTab: MainTab

    var body: some View {
        VStack(spacing: 0) {
            // Top separator line
            Rectangle()
                .fill(AppColors.separator)
                .frame(height: 0.5)

            HStack(spacing: 0) {
                ForEach(MainTab.allCases, id: \.self) { tab in
                    TabBarItem(tab: tab, isSelected: selectedTab == tab) {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                            selectedTab = tab
                        }
                    }
                }
            }
            .padding(.top, 10)
        }
        .background(
            AppColors.surface
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

private struct TabBarItem: View {
    let tab: MainTab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? AppColors.primary : AppColors.tabInactive)
                    .animation(.easeInOut(duration: 0.16), value: isSelected)

                Text(tab.label)
                    .font(AppFonts.label(10, weight: isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? AppColors.primary : AppColors.tabInactive)
                    .animation(.easeInOut(duration: 0.16), value: isSelected)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressButtonStyle())
        .accessibilityLabel(tab.label)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    RootTabView()
}
