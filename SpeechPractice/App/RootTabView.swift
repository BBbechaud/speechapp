import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            PracticeHomeScreen()
                .tabItem {
                    Label("Practice", systemImage: "mic.circle.fill")
                }

            NavigationStack {
                FeaturePlaceholderScreen(title: "Feedback", systemImage: "text.bubble.fill")
            }
            .tabItem {
                Label("Feedback", systemImage: "text.bubble.fill")
            }

            NavigationStack {
                FeaturePlaceholderScreen(title: "Progress", systemImage: "chart.line.uptrend.xyaxis")
            }
            .tabItem {
                Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
            }
        }
        .tint(AppColors.accent)
    }
}

#Preview {
    RootTabView()
}
