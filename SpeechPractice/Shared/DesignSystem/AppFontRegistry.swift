import CoreText
import Foundation

enum AppFontRegistry {
    static func registerBundledFonts() {
        registerFonts(inResourceFolder: "DM Sans")
    }

    private static func registerFonts(inResourceFolder folderName: String) {
        guard let folderURL = Bundle.main.url(forResource: folderName, withExtension: nil) else {
            return
        }

        let fontURLs = bundledFontURLs(in: folderURL)

        for fontURL in fontURLs {
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
    }

    private static func bundledFontURLs(in folderURL: URL) -> [URL] {
        guard let enumerator = FileManager.default.enumerator(
            at: folderURL,
            includingPropertiesForKeys: nil
        ) else {
            return []
        }

        return enumerator
            .compactMap { $0 as? URL }
            .filter { url in
                let fileExtension = url.pathExtension.lowercased()
                return fileExtension == "ttf" || fileExtension == "otf"
            }
    }
}
