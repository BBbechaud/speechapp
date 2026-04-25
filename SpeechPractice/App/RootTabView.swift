import SwiftUI

private enum MainTab: Hashable {
    case practice
    case feedback
    case progress
}

struct RootTabView: View {
    @State private var selectedTab: MainTab = .practice

    var body: some View {
        TabView(selection: $selectedTab) {
            PracticeHomeScreen(onSwitchToFeedbackTab: { selectedTab = .feedback })
                .tabItem {
                    Label("Practice", systemImage: "mic.circle.fill")
                }
                .tag(MainTab.practice)

            NavigationStack {
                FeaturePlaceholderScreen(title: "Feedback", systemImage: "text.bubble.fill")
            }
            .tabItem {
                Label("Feedback", systemImage: "text.bubble.fill")
            }
            .tag(MainTab.feedback)

            NavigationStack {
                FeaturePlaceholderScreen(title: "Progress", systemImage: "chart.line.uptrend.xyaxis")
            }
            .tabItem {
                Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
            }
            .tag(MainTab.progress)
        }
        .tint(AppColors.accent)
    }
}

#Preview {
    RootTabView()
}
