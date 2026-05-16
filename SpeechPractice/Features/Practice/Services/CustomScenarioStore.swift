import Foundation
import Observation

/// Local persistence for user-authored `CustomScenario` values.
///
/// Backed by `UserDefaults` JSON encoding. Items are kept sorted by
/// `updatedAt` descending so the most recently touched scenario appears first.
@Observable
final class CustomScenarioStore {
    private let userDefaults: UserDefaults
    private let storageKey: String
    private let unreadableBackupKey: String

    private(set) var scenarios: [CustomScenario] = []

    init(
        userDefaults: UserDefaults = .standard,
        storageKey: String = "speechpractice.customScenarios.v1"
    ) {
        self.userDefaults = userDefaults
        self.storageKey = storageKey
        self.unreadableBackupKey = "\(storageKey).unreadableBackup"
        load()
    }

    func scenario(with id: UUID) -> CustomScenario? {
        scenarios.first(where: { $0.id == id })
    }

    /// Creates or updates a scenario, stamping `updatedAt` with the current date.
    @discardableResult
    func upsert(_ scenario: CustomScenario) -> CustomScenario {
        var updated = scenario
        updated.updatedAt = Date()

        if let index = scenarios.firstIndex(where: { $0.id == updated.id }) {
            scenarios[index] = updated
        } else {
            scenarios.append(updated)
        }

        sortAndPersist()
        return updated
    }

    func delete(id: UUID) {
        scenarios.removeAll(where: { $0.id == id })
        sortAndPersist()
    }

    private func sortAndPersist() {
        scenarios.sort(by: { $0.updatedAt > $1.updatedAt })
        persist()
    }

    private func load() {
        guard let data = userDefaults.data(forKey: storageKey) else {
            scenarios = []
            return
        }

        do {
            let decoded = try JSONDecoder().decode([CustomScenario].self, from: data)
            scenarios = decoded.sorted(by: { $0.updatedAt > $1.updatedAt })
        } catch {
            // Keep the original blob so future migrations can recover user-authored scenarios.
            assertionFailure("Failed to decode CustomScenario cache: \(error)")
            preserveUnreadableData(data)
            scenarios = []
            userDefaults.removeObject(forKey: storageKey)
        }
    }

    private func preserveUnreadableData(_ data: Data) {
        guard userDefaults.data(forKey: unreadableBackupKey) == nil else {
            return
        }

        userDefaults.set(data, forKey: unreadableBackupKey)
    }

    private func persist() {
        do {
            let encoded = try JSONEncoder().encode(scenarios)
            userDefaults.set(encoded, forKey: storageKey)
        } catch {
            assertionFailure("Failed to encode CustomScenario cache: \(error)")
        }
    }
}
