import Foundation

protocol VoiceConversationProviding: Sendable {
    func makeSession(request: VoiceSessionRequest) async throws -> any VoiceConversationSession
}

protocol VoiceConversationSession: Sendable {
    var id: PracticeSessionID { get }
    var events: AsyncThrowingStream<VoiceSessionEvent, Error> { get }

    func start() async throws
    func sendAudio(_ chunk: VoiceAudioChunk) async throws
    func sendControl(_ control: VoiceSessionControl) async throws
    func end(reason: VoiceSessionEndReason) async throws -> VoiceSessionResult
}

struct VoiceSessionRequest: Equatable, Sendable {
    let sessionID: PracticeSessionID
    let scenarioID: ScenarioID
    let personaID: PersonaID
    let difficulty: PracticeDifficulty
    let voice: VoiceSelection
    let initiator: ConversationInitiator
    let systemPrompt: String
    let softCapDuration: Duration
}

/// In-flight microphone or assistant audio bytes; provider implementations must not persist this value.
struct VoiceAudioChunk: Equatable, Sendable {
    let data: Data
    let format: VoiceAudioFormat
    let capturedAt: Date
}

struct VoiceAudioFormat: Equatable, Sendable {
    let encoding: VoiceAudioEncoding
    let sampleRateHertz: Int
    let channelCount: Int
}

enum VoiceAudioEncoding: String, CaseIterable, Equatable, Sendable {
    case pcm16
    case opus
}

enum VoiceSessionEvent: Equatable, Sendable {
    case connectionStateChanged(VoiceConnectionState)
    case assistantAudio(VoiceAudioChunk)
    case transcriptSegment(VoiceTranscriptSegment)
    case assistantSoftCapSignal(String)
    case ended(VoiceSessionResult)
}

enum VoiceConnectionState: String, Equatable, Sendable {
    case disconnected
    case connecting
    case connected
    case reconnecting
    case ending
    case ended
}

struct VoiceTranscriptSegment: Identifiable, Equatable, Sendable {
    let id: UUID
    let speaker: VoiceTranscriptSpeaker
    let text: String
    let startOffset: Duration
    let endOffset: Duration
    let isFinal: Bool
}

enum VoiceTranscriptSpeaker: String, Equatable, Sendable {
    case user
    case assistant
}

enum VoiceSessionControl: Equatable, Sendable {
    case startListening
    case stopListening
    case interruptAssistant
}

enum VoiceSessionEndReason: String, Equatable, Sendable {
    case userEnded
    case softCapEnded
    case dailyLimitReached
    case providerDisconnected
}

struct VoiceSessionResult: Equatable, Sendable {
    let sessionID: PracticeSessionID
    let endedAt: Date
    let endReason: VoiceSessionEndReason
    let duration: Duration
    let transcript: [VoiceTranscriptSegment]
}
