import SwiftUI

@main
struct SpeechPracticeApp: App {
    init() {
        AppFontRegistry.registerBundledFonts()
        AppNavigationAppearance.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}
