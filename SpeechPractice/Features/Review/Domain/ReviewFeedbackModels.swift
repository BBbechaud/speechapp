import Foundation

struct ReviewFeedback: Equatable, Sendable {
    let scenarioTitle: String
    let personaName: String
    let overallScore: Int
    let skillAnalyses: [SkillReviewAnalysis]
    let didWell: String
    let improve: String
}

struct SkillReviewAnalysis: Identifiable, Equatable, Sendable {
    let id: CommunicationSkillID
    let skill: CommunicationSkill
    let score: Int
    let note: String
}

struct ReviewSessionSummary: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let scenarioTitle: String
    let personaName: String
    let overallScore: Int
    let durationSeconds: Int
    let completedAt: Date
}
