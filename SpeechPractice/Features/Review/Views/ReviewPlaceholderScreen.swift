import SwiftUI

struct ReviewPlaceholderScreen: View {
    var body: some View {
        FeaturePlaceholderScreen(title: "Review", systemImage: "text.bubble")
    }
}

#Preview {
    NavigationStack {
        ReviewPlaceholderScreen()
    }
}
