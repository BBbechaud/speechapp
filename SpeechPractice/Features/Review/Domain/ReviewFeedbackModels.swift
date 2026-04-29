import Foundation

struct ReviewFeedback: Codable, Equatable, Hashable, Sendable {
    let scenarioTitle: String
    let personaName: String
    let overallScore: Int
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

    var id: UUID {
        summary.id
    }
}
