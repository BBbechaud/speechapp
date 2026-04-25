import Foundation

struct ScenarioID: Hashable, Sendable {
    let rawValue: String
}

struct PersonaID: Hashable, Sendable {
    let rawValue: String
}

struct VoiceID: Hashable, Sendable {
    let rawValue: String
}

struct PracticeSessionID: Hashable, Sendable {
    let rawValue: UUID
}

enum PracticeDifficulty: String, CaseIterable, Hashable, Sendable {
    case easy
    case medium
    case hard
}

enum PersonaGender: String, CaseIterable, Hashable, Sendable {
    case male
    case female
}

enum ConversationInitiator: String, CaseIterable, Hashable, Sendable {
    case user
    case ai
}

struct VoiceSelection: Equatable, Hashable, Sendable {
    let id: VoiceID
    let gender: PersonaGender
}
