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
    private var activeReviewFeedback: ReviewFeedback?

    /// Drives session UI (static vs animated waves, status copy). Voice layer updates this.
    var personaSessionPhase: PersonaSessionPhase = .listening

    var navigationPath: [PracticeRoute] = []

    func showDailyChallenges() {
        navigationPath.append(.dailyChallenges)
    }

    func showDailyMinuteWheel() {
        navigationPath.append(.dailyMinuteWheel)
    }

    func select(scenario: Scenario) {
        activeReviewFeedback = nil
        selectedScenario = scenario
        selectedPersona = defaultPersona()
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

    func startDailyMinute(prompt: DailyMinutePrompt) {
        activeReviewFeedback = nil
        selectedScenario = prompt.scenario
        selectedPersona = defaultPersona()
        initiator = .user
        personaSessionPhase = .listening
        navigationPath.append(.dailyMinuteSession(prompt))
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

    /// End Practice: show completion screen (path becomes only `.complete`).
    func endPracticeFromSession() {
        personaSessionPhase = .listening
        navigationPath = [.complete]
    }

    func completeDailyMinute() {
        personaSessionPhase = .listening
        navigationPath = [.complete]
    }

    func showReviewFeedback() {
        activeReviewFeedback = makeReviewFeedback()
        navigationPath.append(.reviewFeedback)
    }

    func currentReviewFeedback() -> ReviewFeedback {
        guard let activeReviewFeedback else {
            preconditionFailure("Cannot show review feedback without active review feedback.")
        }

        return activeReviewFeedback
    }

    private func makeReviewFeedback() -> ReviewFeedback {
        guard let selectedScenario, let selectedPersona else {
            preconditionFailure("Cannot create review feedback without selected scenario and selected persona.")
        }

        return ReviewFeedbackViewModel.seededFeedback(
            scenario: selectedScenario,
            persona: selectedPersona
        )
    }

    func reset() {
        navigationPath = []
        selectedScenario = nil
        selectedPersona = nil
        initiator = .user
        personaSessionPhase = .listening
    }

    private func defaultPersona() -> Persona {
        guard let persona = Persona.all.first else {
            preconditionFailure("Cannot start practice without at least one persona.")
        }

        return persona
    }
}

enum PracticeRoute: Hashable {
    case dailyChallenges
    case dailyMinuteWheel
    case dailyMinuteSession(DailyMinutePrompt)
    case configure
    case primer
    case session
    case complete
    case reviewFeedback
}
