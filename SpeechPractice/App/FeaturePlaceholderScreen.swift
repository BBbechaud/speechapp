import SwiftUI

struct FeaturePlaceholderScreen: View {
    let title: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(.orange)

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)

            Text("Scaffold ready")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .navigationTitle(title)
    }
}

#Preview {
    NavigationStack {
        FeaturePlaceholderScreen(title: "Practice", systemImage: "mic.circle")
    }
}
