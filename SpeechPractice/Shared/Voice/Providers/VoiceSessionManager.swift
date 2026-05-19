import Combine
import Foundation
import Hume

/// Owns Empathic Voice (EVI) via the Hume `VoiceProvider`; feature UI never touches Hume types directly beyond this class.
@MainActor
final class VoiceSessionManager: ObservableObject {

    @Published private(set) var isConnected = false
    @Published private(set) var isUserSpeaking = false
    @Published private(set) var isAISpeaking = false
    @Published private(set) var transcript: [TranscriptMessage] = []

    private var humeClient: HumeClient?
    private var voiceProvider: VoiceProvider?
    private var stateSubscription: AnyCancellable?

    func startSession(systemPrompt: String) async {
        let apiKey = Self.resolvedAPIKey()
        guard !apiKey.isEmpty else {
            print("VoiceSessionManager: missing HUME_API_KEY — inject it through the launch environment for local debugging.")
            return
        }

        let configId = Self.resolvedConfigID()
        guard !configId.isEmpty else {
            print("VoiceSessionManager: missing HUME_CONFIG_ID — define in Secrets.local.xcconfig and rebuild.")
            return
        }

        if MicrophonePermission.current == .undetermined {
            let granted = await MicrophonePermission.requestPermissions()
            guard granted else {
                print("VoiceSessionManager: microphone permission not granted.")
                return
            }
        } else if MicrophonePermission.current == .denied {
            print("VoiceSessionManager: microphone permission denied — enable in Settings.")
            return
        }

        let client = humeClient ?? HumeClient(options: .apiKey(key: apiKey))
        humeClient = client

        let provider = VoiceProviderFactory.shared.getVoiceProvider(client: client)
        voiceProvider = provider
        provider.delegate = self

        await provider.disconnect()

        subscribeToState(provider)

        let sessionSettings = SessionSettings(
            audio: nil,
            builtinTools: nil,
            context: nil,
            customSessionId: nil,
            languageModelApiKey: nil,
            systemPrompt: systemPrompt,
            tools: nil,
            variables: nil,
            voiceId: nil
        )

        do {
            try await provider.connect(
                configId: configId,
                configVersion: nil,
                resumedChatGroupId: nil,
                sessionSettings: sessionSettings
            )
        } catch {
            print("VoiceSessionManager: EVI connection error: \(error)")
            isConnected = false
        }
    }

    func endSession() {
        Task {
            await voiceProvider?.disconnect()
        }
    }

    private func subscribeToState(_ provider: VoiceProvider) {
        stateSubscription?.cancel()
        stateSubscription = provider.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .connected:
                    self.isConnected = true
                case .disconnected:
                    self.isConnected = false
                    self.isAISpeaking = false
                    self.isUserSpeaking = false
                case .connecting, .disconnecting:
                    break
                }
            }
    }

    private static func resolvedAPIKey() -> String {
        if let env = ProcessInfo.processInfo.environment["HUME_API_KEY"] {
            let trimmed = env.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty,
               !(trimmed.hasPrefix("__") && trimmed.hasSuffix("__")) {
                return trimmed
            }
        }
        return ""
    }

    private static func resolvedConfigID() -> String {
        if let plistValue = Bundle.main.object(forInfoDictionaryKey: "HUME_CONFIG_ID") as? String {
            let trimmed = plistValue.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty,
               !(trimmed.hasPrefix("__") && trimmed.hasSuffix("__")) {
                return trimmed
            }
        }
        if let env = ProcessInfo.processInfo.environment["HUME_CONFIG_ID"] {
            let trimmed = env.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty,
               !(trimmed.hasPrefix("__") && trimmed.hasSuffix("__")) {
                return trimmed
            }
        }
        return ""
    }
}

// MARK: - VoiceProviderDelegate

extension VoiceSessionManager: VoiceProviderDelegate {
    nonisolated func voiceProvider(_ voiceProvider: any VoiceProvidable, didProduceEvent event: SubscribeEvent) {
        Task { @MainActor in
            self.handleSubscribeEvent(event)
        }
    }

    private func handleSubscribeEvent(_ event: SubscribeEvent) {
        switch event {
        case .userMessage(let msg):
            guard !msg.interim else { return }
            isUserSpeaking = false
            transcript.append(
                TranscriptMessage(
                    role: .user,
                    text: msg.message.content ?? "",
                    prosody: msg.models.prosody
                ))

        case .assistantMessage(let msg):
            transcript.append(
                TranscriptMessage(
                    role: .assistant,
                    text: msg.message.content ?? ""
                ))

        case .audioOutput:
            isAISpeaking = true

        case .assistantEnd:
            isAISpeaking = false

        default:
            break
        }
    }
}

// MARK: - Transcript

struct TranscriptMessage {
    enum Role {
        case user
        case assistant
    }

    let role: Role
    let text: String
    var prosody: ProsodyInference?
}
