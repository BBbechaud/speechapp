# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

This is a native iOS app. There is no CLI build command — open `SpeechPractice.xcodeproj` in Xcode and use `⌘R` to run and `⌘B` to build. Target: **SpeechPractice**, deployment target **iOS 17.0**.

### Local Secrets Setup

Before building, copy the secrets template and fill in real values:

```
cp SpeechPractice/Configuration/Secrets.example.xcconfig SpeechPractice/Configuration/Secrets.local.xcconfig
```

Edit `Secrets.local.xcconfig` with your `BUNDLE_ID`, `DEVELOPMENT_TEAM`, Supabase URL/key, and PostHog credentials. `Secrets.local.xcconfig` is gitignored — never commit it.

### Adding New Files to the Project

Files created on disk must be manually added to the Xcode target. Drag them into the Project Navigator and confirm **"Add to target: SpeechPractice"**. Forgetting this step causes "cannot find type" compile errors even though the file exists.

## Architecture

### Module Structure

```
SpeechPractice/
  App/                  Entry point, RootTabView, AppConfiguration
  Features/             One folder per product area
    Practice/           
      Models/           ScenarioData (Scenario, Persona, PracticeTip static data)
      ViewModels/       PracticeFlowViewModel (@Observable, owns NavigationPath)
      Views/            PracticeHomeScreen → ScenarioConfigScreen → PracticePrimerScreen
    Onboarding/
    Review/
    Progress/
  Shared/
    DesignSystem/       AppTheme.swift — all design tokens (colors, fonts, spacing, radii)
    Components/         Reusable views: PrimaryButton, DifficultyBadge, PersonaAvatarView
    Models/             PracticeConfigurationModels — typed ID structs, enums shared across features
    Voice/Contracts/    VoiceConversationContracts — the Swift protocol boundary for the voice layer
```

### Navigation

Each feature that owns a multi-screen flow uses a single `@Observable` ViewModel with a `NavigationPath` of a typed `Route` enum. The root `NavigationStack` lives in the feature's home screen, not in `RootTabView`. This keeps tab switching clean and lets each feature manage its own back stack.

Example: `PracticeFlowViewModel` owns `navigationPath: [PracticeRoute]` and the stack in `PracticeHomeScreen`. Calling `viewModel.select(scenario:)` pushes `.configure`; `viewModel.confirmConfig()` pushes `.primer`.

### Design System

`AppTheme.swift` is the single source of truth for all visual constants. Never use hardcoded colors, font sizes, or spacing values inline — always pull from `AppColors`, `AppFonts`, `AppSpacing`, or `AppRadius`.

Key patterns:
- `AppColors.accent` = `#E8632A` (primary orange — the only saturated color)
- `AppFonts.*` use SF Pro Rounded (`design: .rounded`) throughout
- `.cardShadow()` / `.subtleShadow()` — apply via View extension, never raw `.shadow()`
- `PressButtonStyle` / `.pressScale()` — spring 0.97 scale on all tappable elements; use consistently

### Voice Layer

`VoiceConversationContracts.swift` defines a protocol-only boundary (`VoiceConversationProviding` + `VoiceConversationSession`). No concrete provider is implemented yet. The decision between OpenAI Realtime (single WebSocket, lowest latency) and a pipelined STT→LLM→TTS approach is still open. Any future implementation must conform to these protocols — the rest of the app never imports a specific provider directly.

### Configuration

App secrets are injected via xcconfig → `Info.plist` → `AppConfiguration.load(from: .main)` at startup. `AppConfiguration` validates that no placeholder `__VALUE__` strings remain. Adding a new config value requires: xcconfig entry → `Info.plist` key → property in `AppConfiguration` → `requiredString/requiredBool/requiredHTTPSURL` call in `load(from:)`.

## Conventions

- **`@Observable`** for all ViewModels (not `ObservableObject`)
- Views are structs; state lives in ViewModels or local `@State`
- Persona avatar images are placeholder `PersonaAvatarView` (initials) — real assets replace them without API changes
- Entrance animations follow the stagger pattern in existing screens: `appeared` bool flipped in `.onAppear`, each element gets `.delay(0.05 * index)`
- Tab labels: **Practice**, **Feedback**, **Progress** (not "Review")
