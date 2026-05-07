import SwiftUI

private enum MainTab: Hashable, CaseIterable {
    case learn
    case practice
    case progress

    var label: String {
        switch self {
        case .learn:    return "Learn"
        case .practice: return "Practice"
        case .progress: return "Progress"
        }
    }

    var icon: String {
        switch self {
        case .learn:    return "book.fill"
        case .practice: return "mic.circle.fill"
        case .progress: return "chart.line.uptrend.xyaxis"
        }
    }
}

struct RootTabView: View {
    @State private var selectedTab: MainTab = .practice
    @State private var progressInnerTab: ProgressInnerTab = .skills
    @State private var reviewRecords: [ReviewSessionRecord] = []
    @State private var didLoadReviewRecords: Bool = false
    @State private var practiceFlowViewModel = PracticeFlowViewModel()

    /// Hide chrome during the pre-practice transition, the live session, and completion gate
    /// so tabs cannot steal focus from the countdown, End Practice, or analysis CTA.
    private var suppressTabBarForPracticeFlow: Bool {
        switch practiceFlowViewModel.navigationPath.last {
        case .prePracticeTransition, .session, .complete:
            return true
        default:
            return false
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                NavigationStack {
                    LearnScreen()
                }
                .opacity(selectedTab == .learn ? 1 : 0)
                .allowsHitTesting(selectedTab == .learn)

                NavigationStack(path: $practiceFlowViewModel.navigationPath) {
                    PracticeHomeScreen(
                        viewModel: practiceFlowViewModel,
                        onReviewFeedbackClosed: { feedback in
                            reviewRecords = ReviewHistoryStore.record(feedback: feedback, in: reviewRecords)
                            progressInnerTab = .history
                            selectedTab = .progress
                        }
                    )
                }
                .opacity(selectedTab == .practice ? 1 : 0)
                .allowsHitTesting(selectedTab == .practice)

                NavigationStack {
                    ProgressScreen(records: reviewRecords, innerTab: $progressInnerTab)
                }
                .opacity(selectedTab == .progress ? 1 : 0)
                .allowsHitTesting(selectedTab == .progress)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if suppressTabBarForPracticeFlow == false {
                AppTabBar(selectedTab: $selectedTab)
            }
        }
        .animation(.easeInOut(duration: 0.18), value: selectedTab)
        .animation(.easeInOut(duration: 0.22), value: suppressTabBarForPracticeFlow)
        .tint(AppColors.primary)
        .onAppear {
            guard didLoadReviewRecords == false else {
                return
            }
            didLoadReviewRecords = true
            reviewRecords = ReviewHistoryStore.loadRecords()
        }
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
        .safeAreaPadding(.bottom, 6)
        .background(
            AppColors.background
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
                    .font(.system(size: 24, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? AppColors.primary : AppColors.tabInactive)
                    .animation(.easeInOut(duration: 0.16), value: isSelected)

                Text(tab.label)
                    .font(AppFonts.label(11, weight: isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? AppColors.primary : AppColors.tabInactive)
                    .animation(.easeInOut(duration: 0.16), value: isSelected)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 0)
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
