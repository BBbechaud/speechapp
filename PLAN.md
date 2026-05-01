# SpeechApp — Build Plan

## Status as of 2026-04-25

---

## Phase 1: Foundation ✅
- Xcode project scaffolded (SpeechPractice target)
- App entry point + RootTabView with 3 tabs (Practice, Feedback, Progress)
- AppConfiguration for Supabase + PostHog env vars
- PracticeConfigurationModels (ScenarioID, PersonaID, VoiceID, difficulty enums)
- VoiceConversationContracts protocol
- Placeholder screens for all tabs and onboarding

---

## Phase 2: Design System + Practice Flow Screens ✅
Built in this session.

### Design System (`Shared/DesignSystem/AppTheme.swift`)
- AppColors — full palette (primary orange #E8632A, accent indigo #7B6BD1, backgrounds, semantic states, difficulty colors)
- AppFonts — DM Sans for display/title/body, rounded system labels
- AppSpacing + AppRadius — consistent spacing/radius tokens
- View modifiers: `cardShadow()`, `subtleShadow()`, `pressScale()`
- Color hex extension

### Shared Components
- `PrimaryButton` — orange pill CTA with spring press feedback
- `DifficultyBadge` / `TimeBadge` — colored pill badges
- `PersonaAvatarView` — initials-based avatar placeholder (swap for real images later)
- `PressButtonStyle` — 0.97 scale spring feedback for all tappable elements

### Practice Feature
- `ScenarioData.swift` — Scenario + Persona models + all 6 scenarios + 4 personas
- `PracticeFlowViewModel.swift` — @Observable navigation + selection state
- `PracticeHomeScreen` — scenario list with daily scenario card + stagger entrance animation
- `ScenarioConfigScreen` — persona 2x2 grid + who-starts toggle + continue button
- `PracticePrimerScreen` — persona hero + dynamic copy + tips cards + start button

### Navigation
- NavigationStack with typed PracticeRoute enum (configure → primer → session)
- Full practice flow wired end-to-end (session screen is placeholder)
- RootTabView updated: tabs renamed to Practice / Feedback / Progress, tint set to primary orange

---

## Phase 3: Next Up
- [ ] Add new files to Xcode project target (see README below)
- [ ] Live practice session screen (voice conversation UI, timer, persona avatar states)
- [ ] Post-session review / scoring screen
- [ ] Onboarding flow (sign-up, permissions, baseline session)
- [ ] Feedback tab (session history + scores)
- [ ] Progress tab (streak, trends chart, badges, areas of focus)
- [ ] Voice layer — implement VoiceConversationContracts with real provider (OpenAI Realtime vs pipeline TBD)
- [ ] Supabase integration (auth, session persistence)
- [ ] PostHog analytics events

---

## Xcode Setup Required
The new files live on disk but need to be added to the Xcode target:

1. Open `SpeechPractice.xcodeproj` in Xcode
2. In the Project Navigator, right-click each new folder and choose **"Add Files to SpeechPractice"** (or drag in):
   - `Shared/DesignSystem/AppTheme.swift`
   - `Shared/Components/PrimaryButton.swift`
   - `Shared/Components/DifficultyBadge.swift`
   - `Shared/Components/PersonaAvatarView.swift`
   - `Features/Practice/Models/ScenarioData.swift`
   - `Features/Practice/ViewModels/PracticeFlowViewModel.swift`
   - `Features/Practice/Views/PracticeHomeScreen.swift`
   - `Features/Practice/Views/ScenarioConfigScreen.swift`
   - `Features/Practice/Views/PracticePrimerScreen.swift`
3. Make sure **"Add to target: SpeechPractice"** is checked for each file
4. Build (⌘B) — should compile clean

---

## Open Technical Decisions
- Voice provider: OpenAI Realtime vs pipelined STT+LLM+TTS (leading candidate: OpenAI Realtime)
- Daily usage limit: 20 / 25 / 30 min TBD
- Conversation soft cap: 5 min per scenario TBD
- Streak grace mechanic: off by default for MVP
- Persona avatar assets: placeholder initials views currently, real illustrations needed
- Mascot: not yet designed
