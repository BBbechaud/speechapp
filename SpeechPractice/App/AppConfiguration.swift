import Foundation

/// Full product configuration (Supabase, PostHog, etc.). Nothing in the app calls `load` yet; integrations are not wired.
/// `RuntimeSecretsInfo.plist` ships non-secret stubs so targets build without local secrets; replace with real values before shipping.
struct AppConfiguration: Equatable, Sendable {
    let supabaseURL: URL
    let supabaseAnonKey: String
    let postHogHost: URL
    let postHogProjectToken: String
    let postHogCaptureEnabled: Bool
    let postHogAutocaptureEnabled: Bool
    let postHogSessionReplayEnabled: Bool

    static func load(from bundle: Bundle) throws -> AppConfiguration {
        let supabaseURL: URL = try requiredHTTPSURL(forKey: "SUPABASE_URL", in: bundle)
        let supabaseAnonKey: String = try requiredString(forKey: "SUPABASE_ANON_KEY", in: bundle)
        let postHogHost: URL = try requiredHTTPSURL(forKey: "POSTHOG_HOST", in: bundle)
        let postHogProjectToken: String = try requiredString(forKey: "POSTHOG_PROJECT_TOKEN", in: bundle)
        let postHogCaptureEnabled: Bool = try requiredBool(forKey: "POSTHOG_CAPTURE_ENABLED", in: bundle)
        let postHogAutocaptureEnabled: Bool = try requiredBool(forKey: "POSTHOG_AUTOCAPTURE_ENABLED", in: bundle)
        let postHogSessionReplayEnabled: Bool = try requiredBool(forKey: "POSTHOG_SESSION_REPLAY_ENABLED", in: bundle)

        return AppConfiguration(
            supabaseURL: supabaseURL,
            supabaseAnonKey: supabaseAnonKey,
            postHogHost: postHogHost,
            postHogProjectToken: postHogProjectToken,
            postHogCaptureEnabled: postHogCaptureEnabled,
            postHogAutocaptureEnabled: postHogAutocaptureEnabled,
            postHogSessionReplayEnabled: postHogSessionReplayEnabled
        )
    }

    private static func requiredString(forKey key: String, in bundle: Bundle) throws -> String {
        guard let rawValue: String = bundle.object(forInfoDictionaryKey: key) as? String else {
            throw AppConfigurationError.missingValue(key: key)
        }

        let trimmedValue: String = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedValue.isEmpty else {
            throw AppConfigurationError.missingValue(key: key)
        }

        guard !trimmedValue.hasPrefix("__"), !trimmedValue.hasSuffix("__") else {
            throw AppConfigurationError.placeholderValue(key: key)
        }

        return trimmedValue
    }

    private static func requiredBool(forKey key: String, in bundle: Bundle) throws -> Bool {
        let rawValue: String = try requiredString(forKey: key, in: bundle).lowercased()

        switch rawValue {
        case "yes", "true", "1":
            return true
        case "no", "false", "0":
            return false
        default:
            throw AppConfigurationError.invalidBool(key: key)
        }
    }

    private static func requiredHTTPSURL(forKey key: String, in bundle: Bundle) throws -> URL {
        let rawValue: String = try requiredString(forKey: key, in: bundle)

        guard let url: URL = URL(string: rawValue), url.scheme == "https", url.host() != nil else {
            throw AppConfigurationError.invalidHTTPSURL(key: key)
        }

        return url
    }
}

enum AppConfigurationError: LocalizedError, Equatable {
    case missingValue(key: String)
    case placeholderValue(key: String)
    case invalidBool(key: String)
    case invalidHTTPSURL(key: String)

    var errorDescription: String? {
        switch self {
        case let .missingValue(key):
            return "Missing required app configuration value for \(key)."
        case let .placeholderValue(key):
            return "Replace the placeholder app configuration value for \(key) before using this service."
        case let .invalidBool(key):
            return "App configuration value for \(key) must be a valid boolean."
        case let .invalidHTTPSURL(key):
            return "App configuration value for \(key) must be a valid HTTPS URL."
        }
    }
}
