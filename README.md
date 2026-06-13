# GoalPilot

Smart goal-tracking MVP with AI-powered decomposition and coaching via the Gemini API.

## Architecture

Clean Architecture with three layers:

```
lib/
├── app.dart                 # MaterialApp root
├── main.dart                # Entry point + env bootstrap
├── core/                    # Shared infrastructure
│   ├── config/              # Env & app constants
│   ├── constants/           # API & storage keys
│   ├── di/                  # Riverpod core providers
│   ├── error/               # Failures & exceptions
│   ├── theme/               # Material 3 light/dark themes
│   └── utils/               # JSON helpers for Gemini output
└── features/
    ├── goals/
    │   ├── domain/          # Entities & repository contracts
    │   ├── data/            # Models, datasources (next)
    │   └── presentation/    # Screens & widgets
    └── coach/
        ├── domain/
        └── data/
```

**State management:** Riverpod  
**Local storage:** Hive (boxes configured in `StorageConstants`)  
**AI:** `google_generative_ai` + `GEMINI_API_KEY` from `.env`

## Setup

1. Copy `.env.example` to `.env` and set your key:
   ```
   GEMINI_API_KEY=your_key_here
   ```
2. Install dependencies:
   ```
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```
3. Run:
   ```
   flutter run
   ```

Alternatively, pass the key at build time:
```
flutter run --dart-define=GEMINI_API_KEY=your_key_here
```

## Code generation

After changing `@JsonSerializable` models, regenerate:

```
dart run build_runner build --delete-conflicting-outputs
```
