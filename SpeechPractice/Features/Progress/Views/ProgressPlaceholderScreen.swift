import SwiftUI

struct ProgressPlaceholderScreen: View {
    var body: some View {
        FeaturePlaceholderScreen(title: "Progress", systemImage: "chart.line.uptrend.xyaxis")
    }
}

#Preview {
    NavigationStack {
        ProgressPlaceholderScreen()
    }
}
