import SwiftUI

enum PersonaSessionPhase: Hashable {
    /// Persona is waiting for or processing the user’s speech.
    case listening
    /// Persona is producing speech (TTS / model output).
    case speaking
}

@Observable
final class PracticeFlowViewModel {
    var selectedScenario: Scenario?
    var selectedPersona: Persona?
    var initiator: ConversationInitiator = .user

    /// Drives session UI (static vs animated waves, status copy). Voice layer updates this.
    var personaSessionPhase: PersonaSessionPhase = .listening

    var navigationPath: [PracticeRoute] = []

    func select(scenario: Scenario) {
        selectedScenario = scenario
        selectedPersona = Persona.all.first // default to Sarah
        initiator = .user
        navigationPath.append(.configure)
    }

    func confirmConfig() {
        guard selectedScenario != nil, selectedPersona != nil else { return }
        navigationPath.append(.primer)
    }

    func startPractice() {
        personaSessionPhase = .listening
        navigationPath.append(.session)
    }

    func setPersonaSessionPhase(_ phase: PersonaSessionPhase) {
        personaSessionPhase = phase
    }

    /// Toolbar back: leave session, return to primer.
    func leaveSession() {
        guard navigationPath.last == .session else { return }
        personaSessionPhase = .listening
        navigationPath.removeLast()
    }

    /// End Practice: return to scenario list.
    func endPracticeFromSession() {
        reset()
    }

    func reset() {
        navigationPath = []
        selectedScenario = nil
        selectedPersona = nil
        initiator = .user
        personaSessionPhase = .listening
    }
}

enum PracticeRoute: Hashable {
    case configure
    case primer
    case session
}
