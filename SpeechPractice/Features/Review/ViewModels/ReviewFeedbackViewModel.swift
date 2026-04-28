import Foundation

enum ReviewFeedbackViewModel {
    static func seededFeedback(scenario: Scenario, persona: Persona) -> ReviewFeedback {
        let analyses: [SkillReviewAnalysis] = CommunicationSkill.all.map { skill in
            let score: Int = seededScore(for: skill.id)
            let note: String = seededNote(for: skill.id, persona: persona)

            return SkillReviewAnalysis(
                id: skill.id,
                skill: skill,
                score: score,
                note: note
            )
        }

        return ReviewFeedback(
            scenarioTitle: scenario.title,
            personaName: persona.name,
            overallScore: overallScore(from: analyses),
            skillAnalyses: analyses,
            didWell: "You stayed grounded and kept the conversation moving. Your strongest moments came when you answered directly, acknowledged \(persona.name)'s perspective, and returned to the goal of \(scenario.title.lowercased()).",
            improve: "Trim the setup before your main point and use cleaner pauses when you need a moment to think. A little more structure would make your strongest ideas land faster."
        )
    }

    private static func seededScore(for skillID: CommunicationSkillID) -> Int {
        switch skillID {
        case .fillerWords:
            return 70
        case .flow:
            return 78
        case .articulation:
            return 83
        case .conciseness:
            return 68
        case .pitch:
            return 76
        case .rapport:
            return 81
        case .listening:
            return 79
        case .situationHandling:
            return 73
        }
    }

    private static func seededNote(for skillID: CommunicationSkillID, persona: Persona) -> String {
        switch skillID {
        case .fillerWords:
            return "A few filler words appeared while you were forming your next thought. Replace them with a short pause."
        case .flow:
            return "Your rhythm was mostly steady, with a few rushed transitions when \(persona.name) pushed back."
        case .articulation:
            return "Your core ideas were easy to follow. Keep using concrete language when the conversation gets tense."
        case .conciseness:
            return "You sometimes explained past the point. Lead with the answer, then add one supporting detail."
        case .pitch:
            return "Your tone sounded calm and credible. Add a little more downward certainty at the end of key statements."
        case .rapport:
            return "You created a respectful tone and kept the exchange collaborative, even when challenged."
        case .listening:
            return "You responded to the partner's concerns instead of ignoring them. Reflect the exact concern sooner next time."
        case .situationHandling:
            return "You handled the scenario goal, but your closing could be more decisive and action-oriented."
        }
    }

    private static func overallScore(from analyses: [SkillReviewAnalysis]) -> Int {
        let totalScore: Int = analyses.reduce(0) { partialResult, analysis in
            partialResult + analysis.score
        }

        guard analyses.isEmpty == false else {
            preconditionFailure("Cannot calculate review feedback overall score without skill analyses.")
        }

        return totalScore / analyses.count
    }
}

enum ReviewHistoryStore {
    private static let storageKey: String = "reviewSessionSummaries"

    static func loadSummaries() -> [ReviewSessionSummary] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return seededSummaries()
        }

        do {
            let summaries: [ReviewSessionSummary] = try JSONDecoder().decode([ReviewSessionSummary].self, from: data)
            return sortedByMostRecent(summaries)
        } catch {
            preconditionFailure("Could not decode review session summaries from UserDefaults key \(storageKey): \(error)")
        }
    }

    static func record(feedback: ReviewFeedback, in summaries: [ReviewSessionSummary]) -> [ReviewSessionSummary] {
        let summary = ReviewSessionSummary(
            id: UUID(),
            scenarioTitle: feedback.scenarioTitle,
            personaName: feedback.personaName,
            overallScore: feedback.overallScore,
            durationSeconds: seededDurationSeconds(for: feedback.scenarioTitle, personaName: feedback.personaName),
            completedAt: Date()
        )

        let updatedSummaries: [ReviewSessionSummary] = sortedByMostRecent([summary] + summaries)
        save(updatedSummaries)
        return updatedSummaries
    }

    private static func save(_ summaries: [ReviewSessionSummary]) {
        do {
            let data: Data = try JSONEncoder().encode(summaries)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            preconditionFailure("Could not encode review session summaries for UserDefaults key \(storageKey): \(error)")
        }
    }

    private static func sortedByMostRecent(_ summaries: [ReviewSessionSummary]) -> [ReviewSessionSummary] {
        summaries.sorted { lhs, rhs in
            lhs.completedAt > rhs.completedAt
        }
    }

    private static func seededSummaries() -> [ReviewSessionSummary] {
        let now = Date()

        return sortedByMostRecent([
            ReviewSessionSummary(
                id: UUID(uuidString: "8E929020-36E5-4C37-94E0-FE0EEDBC9121") ?? UUID(),
                scenarioTitle: "The Big Pitch",
                personaName: "Sarah",
                overallScore: 88,
                durationSeconds: 272,
                completedAt: now.addingTimeInterval(-2 * 24 * 60 * 60)
            ),
            ReviewSessionSummary(
                id: UUID(uuidString: "27391035-C42C-4E13-9C8C-1F3BE21E7582") ?? UUID(),
                scenarioTitle: "Casual Coffee",
                personaName: "Mike",
                overallScore: 82,
                durationSeconds: 375,
                completedAt: now.addingTimeInterval(-5 * 24 * 60 * 60)
            ),
            ReviewSessionSummary(
                id: UUID(uuidString: "7F7F0F9D-D9B3-4987-94E6-B52E22280BBA") ?? UUID(),
                scenarioTitle: "Handling Feedback",
                personaName: "Chloe",
                overallScore: 64,
                durationSeconds: 225,
                completedAt: now.addingTimeInterval(-7 * 24 * 60 * 60)
            ),
        ])
    }

    private static func seededDurationSeconds(for scenarioTitle: String, personaName: String) -> Int {
        let seed: Int = scenarioTitle.count + personaName.count
        return 210 + (seed % 170)
    }
}
