import Foundation

enum CommunicationSkillID: String, CaseIterable, Identifiable, Hashable, Sendable {
    case fillerWords
    case flow
    case articulation
    case conciseness
    case pitch
    case rapport
    case listening
    case situationHandling

    var id: String {
        rawValue
    }
}

struct CommunicationSkill: Identifiable, Hashable, Sendable {
    let id: CommunicationSkillID
    let title: String
    let definition: String
    let systemImage: String
    let colorHex: String
}

extension CommunicationSkill {
    static let all: [CommunicationSkill] = [
        CommunicationSkill(
            id: .fillerWords,
            title: "Filler Words",
            definition: "How often you rely on \"um,\" \"uh,\" \"like,\" and other verbal crutches when you are thinking.",
            systemImage: "quote.bubble.fill",
            colorHex: "#1E3A8A"
        ),
        CommunicationSkill(
            id: .flow,
            title: "Flow",
            definition: "How naturally your pace and pauses work together: relaxed and controlled, or rushed and uneven.",
            systemImage: "waveform.path.ecg",
            colorHex: "#D43F3A"
        ),
        CommunicationSkill(
            id: .articulation,
            title: "Articulation",
            definition: "How clearly you express yourself under pressure, including whether your words and ideas are easy to follow.",
            systemImage: "text.bubble.fill",
            colorHex: "#1F7A4D"
        ),
        CommunicationSkill(
            id: .conciseness,
            title: "Conciseness",
            definition: "How efficiently you made your point without over-explaining.",
            systemImage: "arrow.down.forward.and.arrow.up.backward",
            colorHex: "#D4A017"
        ),
        CommunicationSkill(
            id: .pitch,
            title: "Pitch",
            definition: "How well your voice carries confidence, and whether your tone sounds sure or uncertain.",
            systemImage: "speaker.wave.2.fill",
            colorHex: "#7C3AED"
        ),
        CommunicationSkill(
            id: .rapport,
            title: "Rapport",
            definition: "Your ability to build genuine connection and leave your speaking partner feeling good about the conversation.",
            systemImage: "person.2.fill",
            colorHex: "#F4A261"
        ),
        CommunicationSkill(
            id: .listening,
            title: "Listening",
            definition: "How well you picked up on what your speaking partner said and responded to it meaningfully.",
            systemImage: "ear.fill",
            colorHex: "#4BA3C7"
        ),
        CommunicationSkill(
            id: .situationHandling,
            title: "Situation Handling",
            definition: "How effectively you navigated what the scenario called for and said what needed to be said.",
            systemImage: "scope",
            colorHex: "#78C850"
        ),
    ]
}
