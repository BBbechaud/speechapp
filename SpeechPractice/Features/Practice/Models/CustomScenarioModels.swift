import Foundation

/// A user-authored scenario stored locally.
///
/// `personaIDRawValue` is stored as a String so the entire model is `Codable`
/// without requiring `PersonaID` itself to be `Codable`.
struct CustomScenario: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var prompt: String
    var personaIDRawValue: String
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        prompt: String,
        personaIDRawValue: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.prompt = prompt
        self.personaIDRawValue = personaIDRawValue
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var personaID: PersonaID { PersonaID(rawValue: personaIDRawValue) }

    var persona: Persona? {
        Persona.all.first(where: { $0.id == personaID })
    }

    var scenarioID: ScenarioID {
        ScenarioID(rawValue: "custom-\(id.uuidString)")
    }

    var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedPrompt: String {
        prompt.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Bridges a custom scenario into the existing `Scenario` value used by
    /// downstream practice screens (configure, primer, session).
    func toScenario() -> Scenario {
        Scenario(
            id: scenarioID,
            title: trimmedName.isEmpty ? "Custom Scenario" : trimmedName,
            description: trimmedPrompt,
            sfSymbol: "sparkles",
            durationRange: "2-3 min",
            tips: [
                PracticeTip(
                    sfSymbol: "scope",
                    title: "Anchor your goal",
                    description: "Open with the outcome you want from this conversation."
                ),
                PracticeTip(
                    sfSymbol: "waveform",
                    title: "Listen and adapt",
                    description: "Adjust your pacing to match what the moment is asking for."
                ),
            ],
            category: .dailyLife
        )
    }
}

enum CustomScenarioLimits {
    static let nameLimit = 60
    static let promptLimit = 250
}
