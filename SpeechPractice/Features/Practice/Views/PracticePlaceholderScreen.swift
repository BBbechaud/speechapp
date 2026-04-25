import SwiftUI

struct PracticePlaceholderScreen: View {
    var body: some View {
        FeaturePlaceholderScreen(title: "Practice", systemImage: "mic.circle")
    }
}

#Preview {
    NavigationStack {
        PracticePlaceholderScreen()
    }
}
