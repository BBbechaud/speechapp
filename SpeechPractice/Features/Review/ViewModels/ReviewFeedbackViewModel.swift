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
            durationSeconds: 272,
            userSpeakingPercent: 62,
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
    private static let recordsStorageKey: String = "reviewSessionRecords"
    private static let legacySummariesStorageKey: String = "reviewSessionSummaries"

    static func loadRecords() -> [ReviewSessionRecord] {
        if let recordsData = UserDefaults.standard.data(forKey: recordsStorageKey) {
            do {
                let records: [ReviewSessionRecord] = try JSONDecoder().decode([ReviewSessionRecord].self, from: recordsData)
                return sortedByMostRecent(records)
            } catch {
                // Stored data is unreadable (schema change or corruption) — clear it and fall through to seeded records.
                UserDefaults.standard.removeObject(forKey: recordsStorageKey)
            }
        }

        let records: [ReviewSessionRecord] = loadLegacyRecords()
        save(records)
        return records
    }

    static func loadSummaries() -> [ReviewSessionSummary] {
        loadRecords().map(\.summary)
    }

    static func record(feedback: ReviewFeedback, notes: String, in records: [ReviewSessionRecord]) -> [ReviewSessionRecord] {
        let summary = ReviewSessionSummary(
            id: UUID(),
            scenarioTitle: feedback.scenarioTitle,
            personaName: feedback.personaName,
            overallScore: feedback.overallScore,
            durationSeconds: seededDurationSeconds(for: feedback.scenarioTitle, personaName: feedback.personaName),
            completedAt: Date()
        )
        let record = ReviewSessionRecord(summary: summary, feedback: feedback, notes: notes)

        let updatedRecords: [ReviewSessionRecord] = sortedByMostRecent([record] + records)
        save(updatedRecords)
        return updatedRecords
    }

    static func updateNotes(for id: ReviewSessionRecord.ID, notes: String, in records: [ReviewSessionRecord]) -> [ReviewSessionRecord] {
        let updatedRecords = records.map { record in
            guard record.id == id else { return record }
            return ReviewSessionRecord(summary: record.summary, feedback: record.feedback, notes: notes)
        }

        save(updatedRecords)
        return sortedByMostRecent(updatedRecords)
    }

    private static func save(_ records: [ReviewSessionRecord]) {
        do {
            let data: Data = try JSONEncoder().encode(records)
            UserDefaults.standard.set(data, forKey: recordsStorageKey)
        } catch {
            preconditionFailure("Could not encode review session records for UserDefaults key \(recordsStorageKey): \(error)")
        }
    }

    private static func loadLegacyRecords() -> [ReviewSessionRecord] {
        guard let data = UserDefaults.standard.data(forKey: legacySummariesStorageKey) else {
            return seededRecords()
        }

        do {
            let summaries: [ReviewSessionSummary] = try JSONDecoder().decode([ReviewSessionSummary].self, from: data)
            let records: [ReviewSessionRecord] = summaries.map { summary in
                ReviewSessionRecord(summary: summary, feedback: feedback(for: summary))
            }
            return sortedByMostRecent(records)
        } catch {
            // Legacy data is unreadable — clear it and fall through to seeded records.
            UserDefaults.standard.removeObject(forKey: legacySummariesStorageKey)
            return seededRecords()
        }
    }

    private static func sortedByMostRecent(_ records: [ReviewSessionRecord]) -> [ReviewSessionRecord] {
        records.sorted { lhs, rhs in
            lhs.summary.completedAt > rhs.summary.completedAt
        }
    }

    private static func sortedByMostRecent(_ summaries: [ReviewSessionSummary]) -> [ReviewSessionSummary] {
        summaries.sorted { lhs, rhs in
            lhs.completedAt > rhs.completedAt
        }
    }

    private static func seededRecords() -> [ReviewSessionRecord] {
        seededSummaries().map { summary in
            ReviewSessionRecord(summary: summary, feedback: feedback(for: summary))
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

    private static func feedback(for summary: ReviewSessionSummary) -> ReviewFeedback {
        let seed: Int = summary.scenarioTitle.count + summary.personaName.count
        let userSpeakingPercent: Int = 50 + (seed % 21)

        return ReviewFeedback(
            scenarioTitle: summary.scenarioTitle,
            personaName: summary.personaName,
            overallScore: summary.overallScore,
            durationSeconds: summary.durationSeconds,
            userSpeakingPercent: userSpeakingPercent,
            skillAnalyses: skillAnalyses(for: summary),
            didWell: "You kept the practice focused and made the interaction feel intentional. Your strongest moments came when you responded directly to \(summary.personaName) and stayed anchored to the goal of \(summary.scenarioTitle.lowercased()).",
            improve: "Use a tighter opening and make your closing action more explicit. The session has a solid foundation, and a little more structure would make the next attempt land with more confidence."
        )
    }

    private static func skillAnalyses(for summary: ReviewSessionSummary) -> [SkillReviewAnalysis] {
        CommunicationSkill.all.enumerated().map { index, skill in
            let score: Int = skillScore(overallScore: summary.overallScore, index: index)
            return SkillReviewAnalysis(
                id: skill.id,
                skill: skill,
                score: score,
                note: skillNote(for: skill, score: score, summary: summary)
            )
        }
    }

    private static func skillScore(overallScore: Int, index: Int) -> Int {
        let offsets: [Int] = [4, -3, 6, -7, 1, 5, -1, -5]
        let offset: Int = offsets[index % offsets.count]
        return min(100, max(0, overallScore + offset))
    }

    private static func skillNote(for skill: CommunicationSkill, score: Int, summary: ReviewSessionSummary) -> String {
        if score >= 82 {
            return "\(skill.title) was a strength in this session. Keep using it to make the conversation with \(summary.personaName) feel clear and grounded."
        }

        if score >= 70 {
            return "\(skill.title) was mostly steady, with room to sharpen the moment-to-moment delivery in \(summary.scenarioTitle.lowercased())."
        }

        return "\(skill.title) needs more deliberate practice here. Slow down, choose one clear move, and let the next response do less work."
    }
}
