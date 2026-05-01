# AGENTS.md

Repository guidance for agents working on SpeechPractice.

## App Context

SpeechPractice is a native iOS app for voice-based conversational practice. Users choose a scenario, configure an AI practice partner, complete a low-stakes voice roleplay, and receive structured feedback that helps them improve confidence, clarity, pacing, and situation handling.

The MVP is iOS-first, SwiftUI-based, and aimed at young adults practicing real interpersonal conversations such as small talk, asking for contact info, salary negotiation, feedback, and conflict resolution.

## Project Shape

```text
SpeechPractice/
  App/                  App entry point, RootTabView, configuration loading
  Configuration/        xcconfig templates and local secret config
  Features/
    Onboarding/         Placeholder onboarding flow
    Practice/           Scenario selection, configuration, primer, session, completion
    Progress/           Currently contains ProfileScreen placeholder implementation
    Review/             Feedback domain models, seeded view model, feedback UI
  Resources/            Asset catalogs
  Shared/
    Components/         Reusable SwiftUI components
    DesignSystem/       AppTheme.swift design tokens and view modifiers
    Models/             Shared typed IDs, enums, and communication skill definitions
    Voice/Contracts/    Provider-agnostic voice conversation protocols
```

## Current Implementation State

- The app target is `SpeechPractice`, deployment target iOS 17.0.
- Root tabs in code are `Practice`, `Feedback`, and `Profile`. Older planning docs may still refer to `Progress`; treat code as current unless the user says otherwise.
- The Practice flow is implemented with a `PracticeFlowViewModel`, typed `PracticeRoute`, and feature-owned `NavigationStack`.
- Practice currently supports home, daily challenge route, scenario configuration, primer, a live session placeholder, completion screen, and seeded feedback navigation.
- Scenarios, daily challenges, personas, practice tips, and difficulty labels are static in `ScenarioData.swift`.
- Review feedback currently uses seeded data through `ReviewFeedbackViewModel`; no real transcript scoring pipeline exists yet.
- The voice layer is contract-only. `VoiceConversationContracts.swift` defines the provider boundary, but no OpenAI Realtime or STT/LLM/TTS implementation has been built.
- Supabase and PostHog values are configured through xcconfig and `AppConfiguration`, but product integrations are not wired yet.
- Onboarding is still placeholder-level.
- Persona avatars and the completion mascot are SwiftUI/SF Symbol placeholders; real visual assets can replace them later without changing most call sites.

## Durable Product Direction

Use `PRD_MVP.md` for product intent and feature requirements. The core product loop should remain:

1. Pick a scenario or daily challenge.
2. Choose persona, difficulty, voice/gender, and conversation initiator.
3. Read a short prep screen.
4. Complete a real-time voice conversation.
5. Review scores, notes, transcript, and personal reflection.
6. Track progress over time.

Feedback should be honest, specific, and confidence-building. The app should feel playful and young without becoming childish or visually noisy.

## Next Implementation Phases

Prioritize the next phases in this order unless the user redirects:

1. Stabilize the current local flow.
   - Keep Practice navigation clean from start through seeded review.
   - Ensure newly added files are included in the Xcode project target.
   - Resolve naming drift between `Progress`, `Profile`, `Review`, and `Feedback`.

2. Build the real live practice session shell.
   - Add timer, session state, transcript collection surface, and explicit end behavior.
   - Preserve the existing `VoiceConversationProviding` and `VoiceConversationSession` boundary.
   - Do not import provider-specific SDKs directly into SwiftUI screens.

3. Implement the voice provider.
   - Leading candidate is OpenAI Realtime, but the final choice is still open.
   - Keep provider code isolated behind `Shared/Voice/Contracts`.
   - Do not persist raw audio; store transcript text and session metadata only.

4. Replace seeded review with real session analysis.
   - Generate skill scores, constructive notes, transcript display, and user reflection persistence.
   - Keep scoring typed around `CommunicationSkill` and related domain models.

5. Add persistence and account foundations.
   - Supabase Auth and session storage.
   - Streaks, total time practiced, feedback history, and progress trend data.

6. Build onboarding and monetization basics.
   - Sign-up, permissions priming, baseline session, and paywall/trial behavior.
   - StoreKit 2 is the intended Apple subscription path.

7. Replace placeholder visuals.
   - Persona art, mascot states, and any motion assets should reinforce effort, progress, and confidence.

## Coding Conventions

- Match the existing SwiftUI style before introducing new patterns.
- Prefer small, typed structs, enums, and pure helper functions.
- Use `@Observable` view models, not `ObservableObject`.
- Keep root-level navigation out of `RootTabView` when a feature owns its own flow.
- Use typed IDs such as `ScenarioID`, `PersonaID`, `VoiceID`, and `PracticeSessionID` instead of raw strings at feature boundaries.
- Avoid catch-all error handling. Throw explicit, actionable errors with enough context to debug.
- Do not add fallback behavior unless the user asks for it.
- Keep imports at the top of each Swift file.
- Comments must be in English and should explain non-obvious intent only.

## Design System Rules

- `Shared/DesignSystem/AppTheme.swift` is the source of truth for colors, fonts, spacing, radii, shadows, and press feedback.
- Avoid hardcoded colors, font sizes, spacing, radii, and shadows inside feature screens.
- Use `AppColors`, `AppFonts`, `AppSpacing`, `AppRadius`, `.cardShadow()`, `.subtleShadow()`, and `PressButtonStyle`.
- Use `AppColors.primary*` for the orange Sunset brand scale and CTAs.
- Use `AppColors.accent*` for the purple Indigo support scale, such as streaks, info, and secondary brand moments.
- Maintain the app's rounded, warm, confidence-building feel without adding decorative clutter.
- Prefer real, functional states over purely ornamental UI.

## Configuration And Secrets

Before building locally, create a local secrets config:

```sh
cp SpeechPractice/Configuration/Secrets.example.xcconfig SpeechPractice/Configuration/Secrets.local.xcconfig
```

Fill in `BUNDLE_ID`, `DEVELOPMENT_TEAM`, Supabase values, and PostHog values. `Secrets.local.xcconfig` is gitignored and must not be committed.

Adding a new configuration value requires:

1. xcconfig entry.
2. Info.plist key.
3. `AppConfiguration` property.
4. Validation in `AppConfiguration.load(from:)`.

## Build And Validation

- Open `SpeechPractice.xcodeproj` in Xcode for normal development.
- Build target: `SpeechPractice`.
- Use `Cmd+B` to build and `Cmd+R` to run from Xcode.
- If validating from the terminal, prefer non-interactive `xcodebuild` commands.
- After adding Swift files on disk, ensure they are included in the Xcode project target. Missing target membership can produce compile errors even when files exist.

## Documentation Boundaries

- Keep `AGENTS.md` focused on durable repository guidance.
- Use `PRD_MVP.md` for product requirements.
- Use `PLAN.md` for phase planning, but update it when it drifts from the code.
- Do not turn this file into a session diary or changelog.
