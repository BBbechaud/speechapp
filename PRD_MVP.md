# Product Requirements Document
## Voice-Based Speech Practice App — MVP

**Document Status:** Draft v1.0
**Scope:** MVP (iOS-first, mobile-focused, iPad considered)
**Last Updated:** April 25, 2026

---

## 1. Overview

### 1.1 Product Summary
A voice-based mobile app that helps users improve their conversational skills through AI-powered roleplay. Users select a scenario, practice a real-time voice conversation with an AI persona, and receive structured post-call feedback to track improvement over time.

### 1.2 Problem
Young adults (18–30) often struggle with confident, articulate verbal communication — particularly in high-stakes social and professional moments like dating, asking for a raise, setting boundaries, or making small talk. Most existing tools focus on public speaking or language learning, not real-world interpersonal conversation. There is no low-stakes, repeatable way to practice these moments before they happen.

### 1.3 Solution
A practice-first app where users rehearse realistic conversations with AI personas in a judgment-free environment, get scored feedback on what they said and how they said it, and watch their skills compound through visible progress tracking and gamified momentum.

### 1.4 Target Audience
- **Age:** 18–30
- **Primary use cases:** Building confidence speaking with peers and romantic interests; preparing for specific high-stakes conversations; reducing filler words and improving articulation
- **Tech comfort:** High — comfortable with voice interfaces, in-app subscriptions, and conversational AI

### 1.5 Success Criteria for MVP
- Users complete their baseline session and at least one additional practice within first 24 hours
- D7 retention benchmark to be established post-launch
- Free trial → paid conversion measurable and trending up across cohorts
- Average session quality (completion rate, length, repeat rate) supports product-market fit signal

---

## 2. Brand & Design Principles

### 2.1 Brand Voice
- **Playful and young, but restrained** — gamified feel without being childish
- **Confidence-building** — feedback is honest but never demoralizing; copy frames mistakes as practice reps
- **Respectful of effort** — the app celebrates trying, not just succeeding

### 2.2 Visual Design
- **Primary brand color:** Orange, with purple reserved for supporting accent moments
- **Other bright colors:** Used sparingly and intentionally (e.g., for category differentiation in scoring, badge tiers)
- **Typography:** Three fonts total across the app
- **Mascot:** Used between screens to convey emotion, celebrate wins, and add character. Placeholder assets used in MVP build until final mascot is designed.
- **Motion:** Subtle animations on transitions, state changes, and progress updates. No screen should feel static.

### 2.3 Design Considerations (Product-Wide)
- **Quick tangible progress:** Daily scenario at top of Practice tab gives users an immediate, repeatable starting point
- **Celebrate small wins:** Badges for first practice, first hard-difficulty completion, first 7-day streak, etc.
- **Movement implies progress:** Progress bars animate, streak counters tick up visibly, mascot reacts to milestones
- **Mascot expresses state:** Different poses/animations for idle, encouragement, celebration, and "let's go again"

---

## 3. User Flow & Feature Specification

The app has three primary tabs: **Practice**, **Review**, and **Progress**.

### 3.1 Practice Tab

#### 3.1.1 Practice Home
The Practice tab is the user's entry point.

**Top of screen:**
- **Daily Scenario:** A featured scenario the user can launch with one tap. Same scenario daily (or refreshes on a cadence TBD post-MVP). Counts toward streak.

**Below daily scenario:**
- Full list/grid of available scenarios
- Each scenario shows: title, short description, and visual treatment

#### 3.1.2 Setup Flow
After selecting a scenario, the user configures the roleplay:

1. **Scenario** (already selected)
2. **Persona** — choose from 4 personas, each available across all scenarios
3. **Difficulty** — Easy / Medium / Hard (affects persona behavior, not voice)
4. **Persona gender** — Male or Female (determines voice; one male voice and one female voice in MVP)
5. **Conversation initiator** — User speaks first, or AI speaks first

#### 3.1.3 Pre-Practice Prep Screen
Before the conversation starts, the user sees a "what to think about" screen with prompts tailored to the chosen scenario. Examples:
- For a date scenario: "What do you actually want to know about this person?"
- For a boundary-setting scenario: "What's the line you're holding, and why does it matter to you?"

This screen primes the user to engage thoughtfully rather than reactively. Includes a clear "Start" button.

#### 3.1.4 In-Practice (Live Conversation)
- Real-time back-and-forth voice conversation between user and AI persona
- Visual: persona avatar (with subtle body-language variations), conversation timer, end button always accessible
- User can end the conversation at any time
- **Soft cap behavior:** When the configured time limit is reached, the AI naturally signals the end of the conversation (e.g., "Hey, I gotta get going" or "Let's wrap this up"). 30 seconds after that signal, the conversation auto-ends.
- AI does not stretch conversations with unnecessary pleasantries; it ends when the user ends or when soft cap fires.

#### 3.1.5 Daily Usage Limit
- Each user has a daily practice time limit (initial target: 20–30 minutes, exact value TBD before launch).
- When the limit is approached, the user is warned. When reached, no new practices can be started until the next day's reset.

### 3.2 Review Tab

After every conversation, the user is taken directly to the Review screen for that session. All past sessions are accessible from the Review tab.

#### 3.2.1 Scored Feedback
Each session generates scores on the following categories. Scoring uses a 1–100 scale, calibrated relative to the user's personal baseline (see §3.3.4 for baseline definition). Each category includes a one-to-two-sentence note explaining the score.

| Category | What it measures |
|---|---|
| Clarity of ideas | How clearly the user communicated their thoughts |
| Filler words | Frequency of "um," "like," "you know," etc. |
| Pitch / tone | Vocal variety and emotional appropriateness (LLM-inferred from transcript context in MVP) |
| Speed of dictation | Pacing — too fast, too slow, or natural |
| How well the user addressed the situation | Whether the user stayed on-goal and handled what came up |
| How the other person likely felt | Inferred emotional reaction from the AI persona's perspective |
| **Overall score** | Composite signal across the above |

#### 3.2.2 Notes Section
Three sub-sections:
- **What you did well** — AI-generated highlights
- **What you can improve on** — AI-generated, actionable, framed constructively
- **Your reflections** — free-text input for the user's own notes

#### 3.2.3 Session Artifacts
- Full transcript of the conversation
- Scores and notes (above)
- **No audio playback in MVP** — audio is not stored

### 3.3 Progress Tab

#### 3.3.1 Trends Over Time
- Line/area chart showing overall score over time
- Toggleable views per category (e.g., view filler-word trend in isolation)

#### 3.3.2 Streak
- Daily streak counter
- A practice on a given calendar day extends the streak
- The Daily Scenario counts toward the streak
- Visible "freeze" or grace mechanic — TBD, default off for MVP

#### 3.3.3 Total Time Practiced
- Lifetime cumulative practice time
- Surfaced prominently as a long-term commitment signal

#### 3.3.4 Areas of Focus
- Progress bars per skill category (e.g., "Filler Words," "Clarity")
- Each user has 2–3 focus areas highlighted, derived from their lowest-scoring categories
- Bars animate on update to reinforce momentum

#### 3.3.5 Badges
- First practice completed
- First Hard-difficulty practice completed
- First 7-day streak
- Additional badges TBD; aim for ~10–15 at launch

---

## 4. Scenarios (MVP)

Six launch scenarios, one prompt per scenario (no sub-variations in MVP):

1. **Talking to a date** — practicing flow, curiosity, and presence on a date
2. **Getting someone's contact info** — moving from a brief interaction to "can I get your number"
3. **Job interview / asking your boss for a raise** — high-stakes professional self-advocacy
4. **Disagreeing without it becoming a fight** — productive disagreement at work, with family, or with a partner
5. **Setting a boundary with someone who pushes back** — holding your line when the other person doesn't accept the first "no"
6. **Making small talk that actually goes somewhere** — entry-level social fluency, framed as the foundation skill

Custom scenarios are deferred to v2.

---

## 5. AI Personas (MVP)

- **Four personas total**, each available for use in any scenario
- Each persona has a defined personality profile that remains consistent across scenarios
- Each persona supports three difficulty levels (Easy, Medium, Hard) — difficulty modifies the persona's behavior (e.g., more dismissive, less patient, more emotionally complex on Hard) without changing core personality
- Each persona has a visual avatar with body-language variations to reflect conversation state
- Voice is determined by selected gender (one male voice, one female voice in MVP) — voice is shared across personas of the same gender

The exact persona personality definitions and the precise behavioral deltas across difficulty levels will be defined in a separate persona spec document.

---

## 6. Onboarding & Baseline

### 6.1 Sign-Up
Users can create an account via:
- Email + password
- Sign in with Apple
- Sign in with Google

### 6.2 Baseline Session
The first scenario every user completes is a baseline conversation: **introducing themselves to another person.** This conversation establishes the user's relative scoring baseline. All future scores are calibrated relative to this baseline.

### 6.3 Onboarding Flow Detail
Full onboarding flow (welcome screens, permissions priming, mascot intro, etc.) to be specified in a follow-up document. MVP build assumes a minimal flow: sign-up → permissions → baseline session → Practice home.

---

## 7. Monetization

### 7.1 Free Trial
- **7 days OR 3 free practices, whichever comes first**
- During trial: full access to all MVP features
- At trial end: paywall blocks new practices until subscription is active

### 7.2 Subscription
- Subscription pricing, tiers (monthly/annual), and exact paywall design TBD before launch
- Billing handled via Apple's StoreKit 2 (App Store IAP)

### 7.3 Daily Usage Limit
- Subscribed users have a daily practice cap (20–30 min target, exact value TBD)
- This is a quality-of-experience and cost-control mechanism, not a monetization lever

---

## 8. Technical Architecture

### 8.1 Stack Summary
| Layer | Technology |
|---|---|
| Frontend | Swift + SwiftUI (iOS first; Android possibly later) |
| Backend | Supabase (Postgres + Auth + Storage) |
| Analytics | PostHog |
| Voice Input (STT) | TBD — see §8.3 |
| AI Conversation (LLM) | TBD — see §8.3 |
| Voice Output (TTS) | TBD — see §8.3 |
| Payments | Apple StoreKit 2 |

### 8.2 Voice Layer Architecture (Critical Decision Pending)

The voice/AI provider stack is not finalized for MVP. Two architectural patterns are on the table:

**Option A: Realtime Voice-to-Voice API** (e.g., OpenAI Realtime, Gemini Live)
- Single WebSocket connection handles STT, LLM, and TTS
- Lowest latency, most natural turn-taking, native interruption handling
- Less granular control over individual pipeline stages
- Transcript is generated alongside but requires care to preserve cleanly for post-call scoring

**Option B: Pipelined Architecture** (separate STT → LLM → TTS providers)
- Full control over each stage; can swap providers independently
- Cleaner transcripts with timestamps (better for filler-word and pacing analysis)
- Higher cumulative latency; turn-taking and barge-in must be implemented manually
- More integration work upfront

**Recommendation:** Defer the final decision, but **build the voice layer behind a clean Swift protocol from day one** so the implementation can be swapped without touching the rest of the app. Realtime API is the leading candidate for the realism the practice experience requires.

### 8.3 Data Storage

#### 8.3.1 What is stored
- User account info (auth provider, email, profile data)
- Session metadata (scenario, persona, difficulty, gender, initiator, timestamps, duration)
- Conversation transcripts (text only)
- Scores and AI-generated notes
- User-written reflections
- Progress data (streaks, totals, category trends, badges earned)

#### 8.3.2 What is NOT stored
- **Raw audio of conversations** — audio is processed in-flight, transcribed, and discarded. This decision optimizes for privacy, cost, and trust. Re-evaluate post-MVP if user feedback indicates demand for replay.

#### 8.3.3 Implications
- Privacy story is clean: "We transcribe your conversations to give you feedback, then delete the audio."
- No biometric data retention concerns (Illinois BIPA, GDPR Article 9 considerations).
- "Hear yourself" replay is unavailable in MVP — call out as a v2 candidate.

### 8.4 Scoring Pipeline
- Post-call only (not real-time)
- Triggered when conversation ends (user-ended or soft-cap-ended)
- Pipeline: transcript → LLM scoring prompt → structured output (scores + notes per category) → persisted to Supabase → surfaced in Review screen
- Scoring is **LLM-inferred from transcript** in MVP. True acoustic analysis (pitch, tone) is a v2 candidate that would require revisiting the audio storage decision.
- Scoring is **relative to user baseline** (established by §6.2 baseline session)

### 8.5 Analytics (PostHog)
Key events to instrument:
- Sign-up (by provider)
- Baseline session started / completed
- Practice started (with scenario, persona, difficulty, gender, initiator)
- Practice ended (user-ended vs. soft-cap-ended, duration)
- Review viewed
- Reflection written
- Streak milestones hit
- Badge earned
- Daily usage limit hit
- Trial converted to paid
- Trial expired without conversion

---

## 9. Out of Scope for MVP

Explicitly **not** included in v1:
- Social features, friends, follow graph
- Leaderboards
- Sharing clips or sessions
- Multiplayer / live practice with other users
- Web app
- Custom scenarios (user-created)
- Audio playback / "hear yourself" replay
- True acoustic analysis (pitch, tone from audio)
- Sub-variations within a single scenario
- Android (possibly later)
- Real-time in-call feedback
- Coaching from human experts

---

## 10. Open Questions

These items require resolution before or during MVP build:

1. **Voice/AI provider selection** — realtime vs. pipelined; specific vendor (OpenAI Realtime, Gemini Live, ElevenLabs+LLM, etc.)
2. **Daily usage limit** — exact minute value (20, 25, 30?)
3. **Conversation soft cap** — default length per scenario (5 min? user-configurable?)
4. **Subscription pricing and tiers**
5. **Mascot design** — character, name, animation set
6. **Persona definitions** — names, personality profiles, behavioral deltas across difficulties
7. **Onboarding flow detail** — beyond sign-up and baseline
8. **Streak grace mechanic** — should users get a "freeze" for missed days?
9. **Badge inventory** — full list of badges available at launch
10. **Trends UI** — exact chart types, time-range selectors

---

## 11. Future Considerations (v2+)

Not promises, but candidates worth keeping in mind during MVP architecture so we don't paint ourselves into corners:

- Custom user-created scenarios
- Audio storage and replay (with explicit user opt-in)
- True acoustic analysis (pitch, tone, energy)
- Android app
- Social and sharing features
- Sub-variations within scenarios
- Personalized scenario recommendations based on user weak points
- Live coaching mode with real-time hints (different mode, not default practice)
- Group/friend practice modes
- Voice cloning so users hear themselves with improved delivery
