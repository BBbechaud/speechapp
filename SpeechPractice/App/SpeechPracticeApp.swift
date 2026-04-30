import SwiftUI

@main
struct SpeechPracticeApp: App {
    init() {
        AppFontRegistry.registerBundledFonts()
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}
