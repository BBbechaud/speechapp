import Foundation

struct ReviewFeedback: Codable, Equatable, Hashable, Sendable {
    let scenarioTitle: String
    let personaName: String
    let overallScore: Int
    let durationSeconds: Int
    let userSpeakingPercent: Int
    let skillAnalyses: [SkillReviewAnalysis]
    let didWell: String
    let improve: String
}

struct SkillReviewAnalysis: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: CommunicationSkillID
    let skill: CommunicationSkill
    let score: Int
    let note: String
}

struct ReviewSessionSummary: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: UUID
    let scenarioTitle: String
    let personaName: String
    let overallScore: Int
    let durationSeconds: Int
    let completedAt: Date
}

struct ReviewSessionRecord: Identifiable, Codable, Equatable, Hashable, Sendable {
    let summary: ReviewSessionSummary
    let feedback: ReviewFeedback
    let notes: String

    init(summary: ReviewSessionSummary, feedback: ReviewFeedback, notes: String = "") {
        self.summary = summary
        self.feedback = feedback
        self.notes = notes
    }

    var id: UUID {
        summary.id
    }

    private enum CodingKeys: String, CodingKey {
        case summary
        case feedback
        case notes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        summary = try container.decode(ReviewSessionSummary.self, forKey: .summary)
        feedback = try container.decode(ReviewFeedback.self, forKey: .feedback)
        notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
    }
}
