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

    /// Persistent store for user-authored scenarios surfaced on the home screen.
    let customScenarioStore: CustomScenarioStore

    /// Identifies which custom scenario is currently being edited. `nil` means
    /// the editor screen is in create mode.
    var editingCustomScenarioID: UUID?

    /// Identifies the saved custom scenario that's powering the current prep /
    /// session screens. Drives the edit affordance on `PracticePrimerScreen`.
    /// `nil` for built-in scenarios and daily challenges.
    var activeCustomScenarioID: UUID?

    /// Convenience accessor for the active custom scenario, if any.
    var activeCustomScenario: CustomScenario? {
        guard let id = activeCustomScenarioID else { return nil }
        return customScenarioStore.scenario(with: id)
    }

    init(customScenarioStore: CustomScenarioStore = CustomScenarioStore()) {
        self.customScenarioStore = customScenarioStore
    }

    func showDailyChallenges() {
        navigationPath.append(.dailyChallenges)
    }

    func showDailyMinuteWheel() {
        navigationPath.append(.dailyMinuteWheel)
    }

    func showCategory(_ category: ScenarioCategory) {
        navigationPath.append(.categoryScenarios(category))
    }

    func showCustomScenariosHub() {
        navigationPath.append(.customScenariosHub)
    }

    func select(scenario: Scenario) {
        activeReviewFeedback = nil
        activeCustomScenarioID = nil
        selectedScenario = scenario
        selectedPersona = defaultPersona()
        initiator = .user
        navigationPath.append(.configure)
    }

    // MARK: - Custom Scenarios

    func presentCustomScenarioCreate() {
        editingCustomScenarioID = nil
        navigationPath.append(.customScenarioEditor)
    }

    func presentCustomScenarioEdit(_ scenario: CustomScenario) {
        editingCustomScenarioID = scenario.id
        navigationPath.append(.customScenarioEditor)
    }

    /// Launches an existing custom scenario directly into the prep screen.
    /// Persona and initiator are already encoded on the saved scenario, so the
    /// user skips the configure step.
    func selectCustomScenario(_ custom: CustomScenario) {
        activeReviewFeedback = nil
        activeCustomScenarioID = custom.id
        selectedScenario = custom.toScenario()
        selectedPersona = custom.persona ?? defaultPersona()
        initiator = .user
        navigationPath.append(.primer)
    }

    /// Persists a new custom scenario and routes straight into the prep screen,
    /// dropping the editor route from the back stack so users can return to home.
    func createCustomScenarioAndStart(name: String, prompt: String, personaID: PersonaID) {
        let now = Date()
        let scenario = CustomScenario(
            id: UUID(),
            name: name,
            prompt: prompt,
            personaIDRawValue: personaID.rawValue,
            createdAt: now,
            updatedAt: now
        )
        let saved = customScenarioStore.upsert(scenario)

        activeReviewFeedback = nil
        activeCustomScenarioID = saved.id
        selectedScenario = saved.toScenario()
        selectedPersona = saved.persona ?? defaultPersona()
        initiator = .user
        editingCustomScenarioID = nil

        replaceEditorRoute(with: .primer)
    }

    /// Persists changes to an existing custom scenario, refreshes the prep screen
    /// state if it's currently showing this scenario, and pops back to wherever
    /// the editor was opened from (prep or home).
    func updateCustomScenario(id: UUID, name: String, prompt: String, personaID: PersonaID) {
        guard let existing = customScenarioStore.scenario(with: id) else { return }

        let updated = CustomScenario(
            id: existing.id,
            name: name,
            prompt: prompt,
            personaIDRawValue: personaID.rawValue,
            createdAt: existing.createdAt,
            updatedAt: Date()
        )
        let saved = customScenarioStore.upsert(updated)

        if activeCustomScenarioID == id {
            selectedScenario = saved.toScenario()
            selectedPersona = saved.persona ?? defaultPersona()
        }

        editingCustomScenarioID = nil
        popEditorRoute()
    }

    func deleteCustomScenario(id: UUID) {
        customScenarioStore.delete(id: id)
        if activeCustomScenarioID == id {
            activeCustomScenarioID = nil
        }
        if editingCustomScenarioID == id {
            editingCustomScenarioID = nil
            popEditorRoute()
        }
    }

    private func replaceEditorRoute(with route: PracticeRoute) {
        if let index = navigationPath.lastIndex(of: .customScenarioEditor) {
            navigationPath.removeSubrange(index...)
        }
        navigationPath.append(route)
    }

    private func popEditorRoute() {
        if let index = navigationPath.lastIndex(of: .customScenarioEditor) {
            navigationPath.removeSubrange(index...)
        }
    }

    func confirmConfig() {
        guard selectedScenario != nil, selectedPersona != nil else { return }
        navigationPath.append(.primer)
    }

    func startPractice() {
        personaSessionPhase = .listening
        navigationPath.append(.prePracticeTransition)
    }

    /// Called by the pre-practice transition screen once breathe + countdown complete.
    /// Replaces the transition route with `.session` so back-swipe cannot return to it.
    func completePrePracticeTransition() {
        guard navigationPath.last == .prePracticeTransition else { return }
        navigationPath[navigationPath.count - 1] = .session
    }

    func startDailyMinute(prompt: DailyMinutePrompt) {
        activeReviewFeedback = nil
        activeCustomScenarioID = nil
        selectedScenario = prompt.scenario
        selectedPersona = defaultPersona()
        initiator = .user
        personaSessionPhase = .listening
        navigationPath.append(.dailyMinuteSession(prompt))
    }

    func setPersonaSessionPhase(_ phase: PersonaSessionPhase) {
        personaSessionPhase = phase
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
        editingCustomScenarioID = nil
        activeCustomScenarioID = nil
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
    case categoryScenarios(ScenarioCategory)
    case customScenariosHub
    case configure
    case customScenarioEditor
    case primer
    case prePracticeTransition
    case session
    case complete
    case reviewFeedback
}
