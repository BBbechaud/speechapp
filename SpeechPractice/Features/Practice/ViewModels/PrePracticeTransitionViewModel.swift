import SwiftUI

/// Phases of the pre-practice transition shown after the primer and before the live session.
/// `breathe` runs once for `breatheDuration`, then `countdown` cycles 3 → 2 → 1 at one beat each.
enum PrePracticeTransitionPhase: Hashable {
    case breathe
    case countdown(Int)
}

/// Drives the pre-practice transition: a single async sequence advances phase state
/// (breathe → 3 → 2 → 1) and then signals completion. Cancellation on disappear
/// guarantees `onComplete` does not fire if the screen is torn down mid-sequence.
@MainActor
@Observable
final class PrePracticeTransitionViewModel {
    private(set) var phase: PrePracticeTransitionPhase = .breathe

    let breatheDuration: TimeInterval = 2.5
    let countdownStepDuration: TimeInterval = 1.0
    private let countdownSteps: [Int] = [3, 2, 1]

    private var sequenceTask: Task<Void, Never>?

    /// Begin the transition. Safe to call multiple times: subsequent calls are no-ops while the
    /// sequence is running.
    func start(onComplete: @escaping @MainActor () -> Void) {
        guard sequenceTask == nil else { return }

        sequenceTask = Task { [weak self] in
            guard let self else { return }
            await self.runSequence(onComplete: onComplete)
        }
    }

    /// Cancel the sequence. UI mutations after cancellation are skipped so the navigation
    /// completion never fires for a screen the user has already left.
    func cancel() {
        sequenceTask?.cancel()
        sequenceTask = nil
    }

    /// Small-caps caption shown beneath the countdown number for each step.
    func countdownCaption(for step: Int) -> String {
        switch step {
        case 3: return "Starting in…"
        case 2: return "Almost there…"
        default: return "Let’s go!"
        }
    }

    private func runSequence(onComplete: @escaping @MainActor () -> Void) async {
        phase = .breathe

        await sleep(seconds: breatheDuration)
        if Task.isCancelled { return }

        for step in countdownSteps {
            phase = .countdown(step)
            await sleep(seconds: countdownStepDuration)
            if Task.isCancelled { return }
        }

        onComplete()
        sequenceTask = nil
    }

    private func sleep(seconds: TimeInterval) async {
        let nanoseconds = UInt64(seconds * 1_000_000_000)
        try? await Task.sleep(nanoseconds: nanoseconds)
    }
}
