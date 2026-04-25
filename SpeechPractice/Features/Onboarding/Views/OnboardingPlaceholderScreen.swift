import SwiftUI

struct OnboardingPlaceholderScreen: View {
    var body: some View {
        FeaturePlaceholderScreen(title: "Onboarding", systemImage: "person.crop.circle.badge.plus")
    }
}

#Preview {
    NavigationStack {
        OnboardingPlaceholderScreen()
    }
}
