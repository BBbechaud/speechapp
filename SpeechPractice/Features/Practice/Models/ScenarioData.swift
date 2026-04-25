import Foundation

// MARK: - Scenario

struct Scenario: Identifiable, Hashable {
    let id: ScenarioID
    let title: String
    let description: String
    let sfSymbol: String
    let durationRange: String
    let tips: [PracticeTip]
}

struct PracticeTip: Identifiable, Hashable {
    let id = UUID()
    let sfSymbol: String
    let title: String
    let description: String
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
    static let all: [Scenario] = [
        Scenario(
            id: ScenarioID(rawValue: "break-the-ice"),
            title: "Break the Ice",
            description: "Start a natural conversation with someone new in any setting.",
            sfSymbol: "person.2.wave.2.fill",
            durationRange: "2-3 min",
            tips: [
                PracticeTip(sfSymbol: "lightbulb.fill", title: "Open with curiosity", description: "Ask something you genuinely want to know — it shows."),
                PracticeTip(sfSymbol: "waveform", title: "Match their energy", description: "Let the conversation breathe. Silence is fine."),
            ]
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
            ]
        ),
        Scenario(
            id: ScenarioID(rawValue: "the-big-pitch"),
            title: "The Big Pitch",
            description: "Present your idea to a group of distracted stakeholders.",
            sfSymbol: "chart.line.uptrend.xyaxis",
            durationRange: "3-5 min",
            tips: [
                PracticeTip(sfSymbol: "bolt.fill", title: "The Prep Rule", description: "State your goal in the first 30 seconds to set the right tone."),
                PracticeTip(sfSymbol: "mic.fill", title: "Natural Voice", description: "Don't worry about being perfect. Speak as you would in real life."),
            ]
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
            ]
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
            ]
        ),
        Scenario(
            id: ScenarioID(rawValue: "conflict-resolution"),
            title: "Conflict Resolution",
            description: "Navigate a heated disagreement with a stubborn peer.",
            sfSymbol: "bolt.shield.fill",
            durationRange: "5-10 min",
            tips: [
                PracticeTip(sfSymbol: "pause.fill", title: "Slow down first", description: "Name the tension before trying to resolve it."),
                PracticeTip(sfSymbol: "figure.2.arms.open", title: "Find the real need", description: "Most arguments aren't about the stated issue. Go one level deeper."),
            ]
        ),
    ]
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
