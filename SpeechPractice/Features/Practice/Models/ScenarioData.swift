import Foundation
import SwiftUI

// MARK: - Scenario Category

enum ScenarioCategory: String, CaseIterable, Identifiable, Hashable {
    case romantic  = "Romantic"
    case career    = "Career"
    case social    = "Social"
    case dailyLife = "Daily Life"

    var id: String { rawValue }

    var subtitle: String {
        switch self {
        case .romantic:  return "Dates, feelings & connection"
        case .career:    return "Interviews, pitches & negotiations"
        case .social:    return "Meeting people & small talk"
        case .dailyLife: return "Feedback, conflict & everyday asks"
        }
    }

    var sfSymbol: String {
        switch self {
        case .romantic:  return "heart.fill"
        case .career:    return "briefcase.fill"
        case .social:    return "person.2.fill"
        case .dailyLife: return "house.fill"
        }
    }

    var gradientColors: [Color] {
        switch self {
        case .romantic:  return [Color(hex: "#F48FB1"), Color(hex: "#E8632A")]
        case .career:    return [Color(hex: "#9C8BDF"), Color(hex: "#3D2F87")]
        case .social:    return [Color(hex: "#4ECBA0"), Color(hex: "#1A7A5A")]
        case .dailyLife: return [Color(hex: "#F4C76A"), Color(hex: "#D48A20")]
        }
    }
}

// MARK: - Scenario

struct Scenario: Identifiable, Hashable {
    let id: ScenarioID
    let title: String
    let description: String
    let sfSymbol: String
    let durationRange: String
    let tips: [PracticeTip]
    let category: ScenarioCategory
}

struct PracticeTip: Identifiable, Hashable {
    let id = UUID()
    let sfSymbol: String
    let title: String
    let description: String
}

struct DailyChallenge: Identifiable, Hashable {
    let id: String
    let category: String
    let title: String
    let description: String
    let sfSymbol: String
    let scenario: Scenario
}

struct DailyMinutePrompt: Identifiable, Hashable, Sendable {
    let id: DailyMinutePromptID
    let title: String
    let prompt: String
    let category: String
    let sfSymbol: String
}

// MARK: - Persona

struct Persona: Identifiable, Hashable {
    let id: PersonaID
    let name: String
    let difficulty: PracticeDifficulty
    let tagline: String
    let description: String
}

// MARK: - Static Data

extension Scenario {
    static let all: [Scenario] = romantic + career + social + dailyLife

    // MARK: Romantic

    static let romantic: [Scenario] = [
        Scenario(
            id: ScenarioID(rawValue: "first-date-convo"),
            title: "First Date Conversation",
            description: "Keep the conversation flowing naturally on a first date without awkward silences.",
            sfSymbol: "cup.and.saucer.fill",
            durationRange: "3-5 min",
            tips: [
                PracticeTip(sfSymbol: "lightbulb.fill", title: "Ask open questions", description: "Questions that invite a story are better than yes/no ones."),
                PracticeTip(sfSymbol: "waveform", title: "Share something real", description: "Vulnerability invites vulnerability. Don't just interview them."),
            ],
            category: .romantic
        ),
        Scenario(
            id: ScenarioID(rawValue: "asking-someone-out"),
            title: "Asking Someone Out",
            description: "Express romantic interest clearly and confidently without making things weird.",
            sfSymbol: "heart.circle.fill",
            durationRange: "2-3 min",
            tips: [
                PracticeTip(sfSymbol: "bolt.fill", title: "Be direct", description: "Clarity is attractive. Vague hints leave both people guessing."),
                PracticeTip(sfSymbol: "face.smiling.fill", title: "Stay light", description: "Treat it as low-stakes. If they say no, you handle it with grace."),
            ],
            category: .romantic
        ),
        Scenario(
            id: ScenarioID(rawValue: "expressing-feelings"),
            title: "Expressing Feelings",
            description: "Tell someone how you feel about them without it coming out as a speech.",
            sfSymbol: "heart.text.clipboard.fill",
            durationRange: "3-5 min",
            tips: [
                PracticeTip(sfSymbol: "eye.fill", title: "Use specific moments", description: "Ground feelings in real examples. \"I feel\" is stronger with context."),
                PracticeTip(sfSymbol: "ear.fill", title: "Leave room for them", description: "Say what you need to say, then pause and actually listen."),
            ],
            category: .romantic
        ),
    ]

    // MARK: Career

    static let career: [Scenario] = [
        Scenario(
            id: ScenarioID(rawValue: "the-big-pitch"),
            title: "The Big Pitch",
            description: "Present your idea to a group of distracted stakeholders.",
            sfSymbol: "chart.line.uptrend.xyaxis",
            durationRange: "3-5 min",
            tips: [
                PracticeTip(sfSymbol: "bolt.fill", title: "Lead with the outcome", description: "State your goal in the first 30 seconds to set the right tone."),
                PracticeTip(sfSymbol: "mic.fill", title: "Natural voice", description: "Don't worry about being perfect. Speak as you would in real life."),
            ],
            category: .career
        ),
        Scenario(
            id: ScenarioID(rawValue: "salary-negotiation"),
            title: "Salary Negotiation",
            description: "Articulate your value and ask for a well-deserved raise.",
            sfSymbol: "banknote.fill",
            durationRange: "3-5 min",
            tips: [
                PracticeTip(sfSymbol: "list.bullet.clipboard.fill", title: "Know your number", description: "Anchor first — whoever names the number first sets the frame."),
                PracticeTip(sfSymbol: "arrow.counterclockwise", title: "Expect resistance", description: "A 'not now' isn't a no. Have your follow-up ready."),
            ],
            category: .career
        ),
        Scenario(
            id: ScenarioID(rawValue: "job-interview"),
            title: "Job Interview",
            description: "Answer tough interview questions confidently and make a strong impression.",
            sfSymbol: "person.badge.clock.fill",
            durationRange: "5-10 min",
            tips: [
                PracticeTip(sfSymbol: "target", title: "Use the STAR format", description: "Situation, Task, Action, Result — stories beat bullet points every time."),
                PracticeTip(sfSymbol: "pause.fill", title: "Pause before answering", description: "A two-second pause signals confidence, not uncertainty."),
            ],
            category: .career
        ),
    ]

    // MARK: Social

    static let social: [Scenario] = [
        Scenario(
            id: ScenarioID(rawValue: "break-the-ice"),
            title: "Break the Ice",
            description: "Start a natural conversation with someone new in any setting.",
            sfSymbol: "person.2.wave.2.fill",
            durationRange: "2-3 min",
            tips: [
                PracticeTip(sfSymbol: "lightbulb.fill", title: "Open with curiosity", description: "Ask something you genuinely want to know — it shows."),
                PracticeTip(sfSymbol: "waveform", title: "Match their energy", description: "Let the conversation breathe. Silence is fine."),
            ],
            category: .social
        ),
        Scenario(
            id: ScenarioID(rawValue: "get-contact-info"),
            title: "Get Contact Info",
            description: "Gracefully transition a chat into a follow-up or connection.",
            sfSymbol: "person.text.rectangle.fill",
            durationRange: "2-3 min",
            tips: [
                PracticeTip(sfSymbol: "target", title: "Name the reason", description: "Give them a clear reason to share — vague asks get polite declines."),
                PracticeTip(sfSymbol: "hand.raised.fill", title: "Make it low-stakes", description: "Frame it as casual, not a big deal — because it isn't."),
            ],
            category: .social
        ),
        Scenario(
            id: ScenarioID(rawValue: "small-talk-event"),
            title: "Small Talk at an Event",
            description: "Work a room and keep conversations going with people you've just met.",
            sfSymbol: "person.3.fill",
            durationRange: "2-3 min",
            tips: [
                PracticeTip(sfSymbol: "arrow.right.circle.fill", title: "Bridge topics naturally", description: "\"That reminds me of...\" is your best friend at a party."),
                PracticeTip(sfSymbol: "hand.thumbsup.fill", title: "Exit gracefully", description: "A clean exit — \"Great meeting you\" — makes the whole conversation feel good."),
            ],
            category: .social
        ),
    ]

    // MARK: Daily Life

    static let dailyLife: [Scenario] = [
        Scenario(
            id: ScenarioID(rawValue: "conflict-resolution"),
            title: "Conflict Resolution",
            description: "Navigate a heated disagreement with a stubborn peer.",
            sfSymbol: "bolt.shield.fill",
            durationRange: "5-10 min",
            tips: [
                PracticeTip(sfSymbol: "pause.fill", title: "Slow down first", description: "Name the tension before trying to resolve it."),
                PracticeTip(sfSymbol: "figure.2.arms.open", title: "Find the real need", description: "Most arguments aren't about the stated issue. Go one level deeper."),
            ],
            category: .dailyLife
        ),
        Scenario(
            id: ScenarioID(rawValue: "giving-feedback"),
            title: "Giving Feedback",
            description: "Deliver tough news to a teammate while maintaining trust.",
            sfSymbol: "bubble.left.and.text.bubble.right.fill",
            durationRange: "5-10 min",
            tips: [
                PracticeTip(sfSymbol: "eye.fill", title: "Lead with observation", description: "Describe what you saw, not what you felt about it — yet."),
                PracticeTip(sfSymbol: "heart.fill", title: "Assume good intent", description: "The other person wants to do well. Start from there."),
            ],
            category: .dailyLife
        ),
        Scenario(
            id: ScenarioID(rawValue: "asking-for-help"),
            title: "Asking for Help",
            description: "Make a clear, direct ask without over-explaining or apologizing.",
            sfSymbol: "hand.raised.fill",
            durationRange: "2-3 min",
            tips: [
                PracticeTip(sfSymbol: "target", title: "Be specific", description: "Vague asks get vague responses. State exactly what you need."),
                PracticeTip(sfSymbol: "clock.fill", title: "Give context, not excuses", description: "One sentence of why is enough. Anything more sounds defensive."),
            ],
            category: .dailyLife
        ),
    ]

    static func scenarios(for category: ScenarioCategory) -> [Scenario] {
        all.filter { $0.category == category }
    }
}

extension DailyChallenge {
    static let dailyMinuteChallengeID = "sixty-second-scenario"

    static let all: [DailyChallenge] = [
        DailyChallenge(
            id: "pause-master",
            category: "Speaking Drill",
            title: "The Pause Master",
            description: "Master silence by eliminating filler words like \"um\" and \"ah\".",
            sfSymbol: "speaker.wave.2.fill",
            scenario: Scenario(
                id: ScenarioID(rawValue: "daily-pause-master"),
                title: "The Pause Master",
                description: "Master silence by eliminating filler words like \"um\" and \"ah\".",
                sfSymbol: "speaker.wave.2.fill",
                durationRange: "2-3 min",
                tips: [
                    PracticeTip(sfSymbol: "pause.fill", title: "Use the pause", description: "Let silence replace filler words before your next idea."),
                    PracticeTip(sfSymbol: "waveform", title: "Reset your pace", description: "Slow the next sentence when you notice a filler word forming."),
                ],
                category: .dailyLife
            )
        ),
        DailyChallenge(
            id: "sixty-second-scenario",
            category: "Daily Minute",
            title: "The 60-Second Scenario",
            description: "A high-stakes situation that rotates every 24 hours. Think fast.",
            sfSymbol: "timer",
            scenario: Scenario(
                id: ScenarioID(rawValue: "daily-sixty-second-scenario"),
                title: "The 60-Second Scenario",
                description: "A high-stakes situation that rotates every 24 hours. Think fast.",
                sfSymbol: "timer",
                durationRange: "1 min",
                tips: [
                    PracticeTip(sfSymbol: "bolt.fill", title: "Start immediately", description: "Open with the point before adding context."),
                    PracticeTip(sfSymbol: "target", title: "Choose one goal", description: "Keep the response anchored to a single outcome."),
                ],
                category: .dailyLife
            )
        ),
        DailyChallenge(
            id: "skill-sprint",
            category: "Speed Drill",
            title: "Skill Sprint",
            description: "A specialized high-intensity drill to boost your active listening skills.",
            sfSymbol: "wand.and.stars",
            scenario: Scenario(
                id: ScenarioID(rawValue: "daily-skill-sprint"),
                title: "Skill Sprint",
                description: "A specialized high-intensity drill to boost your active listening skills.",
                sfSymbol: "wand.and.stars",
                durationRange: "3-5 min",
                tips: [
                    PracticeTip(sfSymbol: "ear.fill", title: "Reflect first", description: "Repeat the core idea before adding your own response."),
                    PracticeTip(sfSymbol: "questionmark.circle.fill", title: "Ask one sharper question", description: "Use a focused follow-up to prove you understood."),
                ],
                category: .dailyLife
            )
        ),
    ]

    var isDailyMinute: Bool {
        id == Self.dailyMinuteChallengeID
    }
}

extension DailyMinutePrompt {
    static let all: [DailyMinutePrompt] = [
        DailyMinutePrompt(
            id: DailyMinutePromptID(rawValue: "missed-deadline"),
            title: "Own a Missed Deadline",
            prompt: "You missed a deadline that affects your team. Explain what happened, name the impact, and propose the next step without sounding defensive.",
            category: "Accountability",
            sfSymbol: "calendar.badge.exclamationmark"
        ),
        DailyMinutePrompt(
            id: DailyMinutePromptID(rawValue: "unexpected-introduction"),
            title: "Introduce Yourself Fast",
            prompt: "You just met someone impressive at an event. Introduce yourself, make the moment feel natural, and give them one reason to keep talking.",
            category: "Small Talk",
            sfSymbol: "person.2.wave.2.fill"
        ),
        DailyMinutePrompt(
            id: DailyMinutePromptID(rawValue: "push-back"),
            title: "Push Back Clearly",
            prompt: "A teammate suggests a plan you think is risky. Disagree respectfully, explain the risk, and offer a better path forward.",
            category: "Conflict",
            sfSymbol: "exclamationmark.bubble.fill"
        ),
        DailyMinutePrompt(
            id: DailyMinutePromptID(rawValue: "pitch-your-idea"),
            title: "Pitch One Idea",
            prompt: "You have one minute to pitch a useful idea to a busy decision-maker. Start with the outcome, then explain why it matters now.",
            category: "Pitch",
            sfSymbol: "chart.line.uptrend.xyaxis"
        ),
        DailyMinutePrompt(
            id: DailyMinutePromptID(rawValue: "give-recognition"),
            title: "Give Specific Praise",
            prompt: "Recognize someone for good work in a way that feels genuine. Be specific about what they did and why it mattered.",
            category: "Feedback",
            sfSymbol: "hand.thumbsup.fill"
        ),
        DailyMinutePrompt(
            id: DailyMinutePromptID(rawValue: "recover-from-fumble"),
            title: "Recover Mid-Sentence",
            prompt: "You lost your train of thought while speaking. Pause, reset cleanly, and continue without apologizing too much or using filler words.",
            category: "Clarity",
            sfSymbol: "arrow.counterclockwise"
        ),
        DailyMinutePrompt(
            id: DailyMinutePromptID(rawValue: "tell-the-story"),
            title: "Tell a Short Story",
            prompt: "Describe a recent moment when you solved a problem. Give it a beginning, a turn, and a clear takeaway.",
            category: "Story",
            sfSymbol: "book.closed.fill"
        ),
        DailyMinutePrompt(
            id: DailyMinutePromptID(rawValue: "calm-the-room"),
            title: "Calm the Room",
            prompt: "A conversation is getting tense. Acknowledge the pressure, slow the pace, and guide everyone toward one practical next step.",
            category: "Leadership",
            sfSymbol: "figure.2.arms.open"
        ),
    ]

    var scenario: Scenario {
        Scenario(
            id: ScenarioID(rawValue: "daily-minute-\(id.rawValue)"),
            title: title,
            description: prompt,
            sfSymbol: sfSymbol,
            durationRange: "1 min",
            tips: [
                PracticeTip(sfSymbol: "pause.fill", title: "Use clean pauses", description: "Let silence replace filler words while you find the next thought."),
                PracticeTip(sfSymbol: "target", title: "Land one point", description: "Keep the minute anchored to a single outcome."),
            ],
            category: .dailyLife
        )
    }
}

extension Persona {
    static let all: [Persona] = [
        Persona(
            id: PersonaID(rawValue: "sarah"),
            name: "Sarah",
            difficulty: .easy,
            tagline: "Friendly and supportive.",
            description: "Great for finding your footing."
        ),
        Persona(
            id: PersonaID(rawValue: "david"),
            name: "David",
            difficulty: .medium,
            tagline: "Skeptical and logical.",
            description: "He'll challenge your reasoning."
        ),
        Persona(
            id: PersonaID(rawValue: "chloe"),
            name: "Chloe",
            difficulty: .medium,
            tagline: "Easily distracted.",
            description: "You'll need to keep her on track."
        ),
        Persona(
            id: PersonaID(rawValue: "victor"),
            name: "Victor",
            difficulty: .hard,
            tagline: "Reactive and intense.",
            description: "Be ready for a tough session."
        ),
    ]
}
