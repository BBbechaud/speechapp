import Foundation

struct ReviewFeedback: Equatable, Hashable, Sendable {
    let scenarioTitle: String
    let personaName: String
    let difficulty: PracticeDifficulty
    let overallScore: Int
    let durationSeconds: Int
    let userSpeakingPercent: Int
    let skillAnalyses: [SkillReviewAnalysis]
    let didWell: String
    let improve: String
}

extension ReviewFeedback: Codable {
    private enum CodingKeys: String, CodingKey {
        case scenarioTitle
        case personaName
        case difficulty
        case overallScore
        case durationSeconds
        case userSpeakingPercent
        case skillAnalyses
        case didWell
        case improve
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        scenarioTitle = try container.decode(String.self, forKey: .scenarioTitle)
        personaName = try container.decode(String.self, forKey: .personaName)
        difficulty = try container.decodeIfPresent(PracticeDifficulty.self, forKey: .difficulty) ?? .medium
        overallScore = try container.decodeIfPresent(Int.self, forKey: .overallScore) ?? 0
        durationSeconds = try container.decodeIfPresent(Int.self, forKey: .durationSeconds) ?? 0
        userSpeakingPercent = try container.decodeIfPresent(Int.self, forKey: .userSpeakingPercent) ?? 50

        if let analyses = try container.decodeIfPresent([SkillReviewAnalysis].self, forKey: .skillAnalyses) {
            skillAnalyses = analyses
        } else {
            skillAnalyses = []
        }

        didWell = try container.decodeIfPresent(String.self, forKey: .didWell) ?? ""
        improve = try container.decodeIfPresent(String.self, forKey: .improve) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(scenarioTitle, forKey: .scenarioTitle)
        try container.encode(personaName, forKey: .personaName)
        try container.encode(difficulty, forKey: .difficulty)
        try container.encode(overallScore, forKey: .overallScore)
        try container.encode(durationSeconds, forKey: .durationSeconds)
        try container.encode(userSpeakingPercent, forKey: .userSpeakingPercent)
        try container.encode(skillAnalyses, forKey: .skillAnalyses)
        try container.encode(didWell, forKey: .didWell)
        try container.encode(improve, forKey: .improve)
    }
}

struct SkillReviewAnalysis: Identifiable, Equatable, Hashable, Sendable {
    let id: CommunicationSkillID
    let skill: CommunicationSkill
    let score: Int
    let note: String
}

extension SkillReviewAnalysis: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case skill
        case score
        case note
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodedID = try container.decode(CommunicationSkillID.self, forKey: .id)

        let resolvedSkill: CommunicationSkill
        if let decodedSkill = try? container.decode(CommunicationSkill.self, forKey: .skill) {
            resolvedSkill = decodedSkill
        } else if let fallback = CommunicationSkill.all.first(where: { $0.id == decodedID }) {
            resolvedSkill = fallback
        } else if let first = CommunicationSkill.all.first {
            resolvedSkill = first
        } else {
            throw DecodingError.dataCorruptedError(forKey: .skill, in: container, debugDescription: "No CommunicationSkill catalog available.")
        }

        id = decodedID
        skill = resolvedSkill
        score = try container.decodeIfPresent(Int.self, forKey: .score) ?? 0
        note = try container.decodeIfPresent(String.self, forKey: .note) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(skill, forKey: .skill)
        try container.encode(score, forKey: .score)
        try container.encode(note, forKey: .note)
    }
}

struct ReviewSessionSummary: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: UUID
    let scenarioTitle: String
    let personaName: String
    let overallScore: Int
    let durationSeconds: Int
    let completedAt: Date
}

struct ReviewSessionRecord: Identifiable, Equatable, Hashable, Sendable {
    let summary: ReviewSessionSummary
    let feedback: ReviewFeedback

    var id: UUID {
        summary.id
    }
}

extension ReviewSessionRecord: Codable {}
