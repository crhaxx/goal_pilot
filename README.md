# GoalPilot

Smart goal-tracking app with AI-powered decomposition, daily coaching, and progress reviews via the Gemini API.

**Version:** 0.1.1 · **Tagline:** Navigate your goals with AI

## Features

- **AI goal planning** — Describe a goal in natural language; Gemini breaks it into milestones and action tasks.
- **Daily check-ins** — Mood tracking, streaks, and Pilot-guided reflection on each goal.
- **AI coach (Pilot)** — Chat with Pilot about a goal, get motivation, or practice tough situations via roleplay scenarios.
- **Weekly reviews** — Summarize progress and reflect on the past week.
- **Adaptive support** — Crisis mode, pivot wizard, reality checks, and milestone extension when a goal is fully completed.
- **Gamification** — Win bricks, pilot status, and a “done wall” to visualize completed work.
- **Home dashboard** — Today’s focus, stats, and quick actions at a glance.
- **Notifications** — Configurable daily reminders (“Daily Fuel”).
- **Home screen widget** — Glanceable goal progress on supported platforms.
- **Localization** — English and Czech (`en`, `cs`).
- **Settings** — Theme (system / light / dark), language, notifications, and privacy info.

## Tech stack


| Area          | Choice                              |
| ------------- | ----------------------------------- |
| Framework     | Flutter (SDK ^3.9)                  |
| State         | Riverpod                            |
| Navigation    | go_router                           |
| Local storage | Hive                                |
| AI            | `google_generative_ai` (Gemini 3.x) |
| Config        | `.env` / `--dart-define`            |
| Notifications | flutter_local_notifications         |
| Sharing       | share_plus                          |
| Widget        | home_widget                         |


## Architecture

Clean Architecture with feature modules:

```
lib/
├── app.dart                 # MaterialApp root
├── main.dart                # Entry point, Hive & services bootstrap
├── l10n/                    # ARB files (en, cs)
├── core/
│   ├── config/              # App & env config
│   ├── constants/           # API, storage & widget keys
│   ├── di/                  # Riverpod core providers
│   ├── error/               # Failures & exceptions
│   ├── l10n/                # Localization helpers
│   ├── presentation/        # Shared widgets (shell, logo, …)
│   ├── router/              # go_router routes & redirects
│   ├── services/            # Notifications, sharing, home widget
│   ├── theme/               # Material 3 light/dark themes
│   └── utils/               # JSON, dates, failure messages
└── features/
    ├── goals/               # Goals, milestones, tasks, check-ins, AI decomposition
    ├── coach/               # Pilot chat & roleplay
    ├── home/                # Dashboard & motivation
    ├── review/              # Weekly progress reviews
    ├── gamification/        # Win bricks, pilot status, done wall
    ├── onboarding/          # First-run flow & language selection
    └── settings/            # Theme, locale, notifications
```

Each feature follows **domain** (entities, repository contracts) → **data** (models, datasources, implementations) → **presentation** (screens, widgets, providers).

## Setup

1. Copy `.env.example` to `.env` and set your Gemini API key:
  ```
   GEMINI_API_KEY=your_key_here
  ```
   Optionally pin a single model (default tries `gemini-3.1-flash-lite`, then `gemini-3.5-flash`):
2. Install dependencies and generate code:
  ```
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
  ```
3. Run the app:
  ```
   flutter run
  ```

Alternatively, pass the key at build time (no `.env` file needed):

```
flutter run --dart-define=GEMINI_API_KEY=your_key_here
```

## Code generation

After changing `@JsonSerializable` models, regenerate:

```
dart run build_runner build --delete-conflicting-outputs
```

After editing ARB localization files, Flutter regenerates l10n on the next build (`flutter gen-l10n` runs automatically via `generate: true` in `pubspec.yaml`).

## Privacy

Goal data is stored locally on device (Hive). AI requests are sent to Google’s Gemini API only when you create goals, chat with Pilot, run roleplay, or trigger AI-powered features. See in-app Settings → About for details.

## Google Play release

**Package name:** `app.goalpilot`  
**Output format:** Android App Bundle (`.aab`) — required by Google Play.

### 1. Upload keystore (one-time)

Generate an upload key and keep it safe (loss = you cannot publish updates under the same app):

```powershell
keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Copy `android/key.properties.example` → `android/key.properties` and fill in passwords and paths.  
Neither `key.properties` nor `*.jks` belong in git.

### 2. Build the release bundle

```powershell
$env:GEMINI_API_KEY = "your_production_key"
.\scripts\build_play_release.ps1
```

The signed bundle is written to `build/app/outputs/bundle/release/app-release.aab`.

For CI or manual builds without the script:

```powershell
flutter build appbundle --release --dart-define=GEMINI_API_KEY=your_production_key
```

Restrict the Gemini API key in [Google AI Studio](https://aistudio.google.com/) to your app’s package name (`app.goalpilot`) and Play App Signing SHA-1.

### 3. Google Play Console checklist

| Item | Notes |
| --- | --- |
| **App bundle** | Upload `app-release.aab` under Release → Production (or Testing). |
| **Play App Signing** | Enable Google-managed signing on first upload. |
| **Privacy policy URL** | Required — app sends goal context to Gemini. Host a policy page and paste the URL in Store settings. |
| **Data safety** | Declare: local storage (goals, settings); data sent to Google Gemini for AI features; no account system. |
| **Permissions** | `POST_NOTIFICATIONS` (Daily Fuel reminders), `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM` (scheduled notifications). Justify exact alarms in the declaration if prompted. |
| **Target audience & content** | Complete the content rating questionnaire. |
| **Store listing** | Title, short/full description, icon (512×512), feature graphic (1024×500), phone screenshots (min. 2). |

### 4. Version bumps

Update `version` in `pubspec.yaml` before each Play upload — e.g. `0.1.2+2` (name `0.1.2`, versionCode `2`). Google Play rejects uploads with a duplicate or lower `versionCode`.