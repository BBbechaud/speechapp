import SwiftUI

private enum MainTab: Hashable {
    case practice
    case feedback
    case profile
}

struct RootTabView: View {
    @State private var selectedTab: MainTab = .practice
    @State private var reviewRecords: [ReviewSessionRecord] = ReviewHistoryStore.loadRecords()
    @State private var practiceFlowViewModel = PracticeFlowViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $practiceFlowViewModel.navigationPath) {
                PracticeHomeScreen(
                    viewModel: practiceFlowViewModel,
                    onReviewFeedbackClosed: { feedback in
                        reviewRecords = ReviewHistoryStore.record(feedback: feedback, in: reviewRecords)
                        selectedTab = .feedback
                    }
                )
            }
            .tabItem {
                Label("Practice", systemImage: "mic.circle.fill")
            }
            .tag(MainTab.practice)

            NavigationStack {
                ReviewHistoryScreen(records: reviewRecords)
            }
            .tabItem {
                Label("Feedback", systemImage: "text.bubble.fill")
            }
            .tag(MainTab.feedback)

            NavigationStack {
                ProfileScreen()
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            .tag(MainTab.profile)
        }
        .tint(AppColors.accent)
    }
}

#Preview {
    RootTabView()
}
