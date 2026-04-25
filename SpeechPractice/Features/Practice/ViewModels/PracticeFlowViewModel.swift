import SwiftUI

@Observable
final class PracticeFlowViewModel {
    var selectedScenario: Scenario?
    var selectedPersona: Persona?
    var initiator: ConversationInitiator = .user

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
        navigationPath.append(.session)
    }

    func reset() {
        navigationPath = []
        selectedScenario = nil
        selectedPersona = nil
        initiator = .user
    }
}

enum PracticeRoute: Hashable {
    case configure
    case primer
    case session
}
