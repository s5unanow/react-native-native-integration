# Fabric Video Player Demo

A step-by-step example of building a Fabric Native Component in React Native 0.82.

## Branches

Checkout each branch to follow along:

| Branch | Description |
|--------|-------------|
| `step-0-scaffold` | Clean RN 0.82 project |
| `step-1-js-spec` | TypeScript component spec |
| `step-2-ios` | iOS native implementation |
| `step-3-android` | Android native implementation |
| `step-4-usage` | Basic usage example |
| `step-5-events` | Progress & completion events |
| **`step-6-commands`** | **Native commands (play/pause/seek)** |
| `main` | Complete working example |

## Running

```bash
npm install
cd ios && pod install && cd ..
npm run ios
npm run android
```

## This Step

Add imperative native commands: `play()`, `pause()`, and `seekTo(time)`.

### What was added

- **`src/specs/RTNVideoPlayerCommands.ts`** — Commands spec
  - Uses `codegenNativeCommands` to define `play`, `pause`, `seekTo`
  - `seekTo` takes a `Double` parameter (seconds)
- **`src/components/VideoPlayer.tsx`** — Exposed commands via ref
  - Converted to `forwardRef` with `useImperativeHandle`
  - Exports `VideoPlayerRef` interface: `play()`, `pause()`, `seekTo(time)`
  - Internally calls `Commands.play(nativeRef)` etc.
- **`RTNVideoPlayerViewSwift.swift`** (iOS) — Added `play()`, `pause()`, `seekTo(_:)` methods
- **`RTNVideoPlayerView.mm`** (iOS) — Implemented `handleCommand:args:` to dispatch commands
- **`RTNVideoPlayerView.kt`** (Android) — Added `play()`, `commandPause()`, `seekTo()` methods
- **`RTNVideoPlayerManager.kt`** (Android) — Overrode command methods from the generated interface
- **`App.tsx`** — Added play/pause button, seek controls (-10s / +10s), restart on end

### Key Concepts

- **`codegenNativeCommands`** generates type-safe command dispatchers for both platforms
- Commands are the JS → native imperative API (opposite direction from events)
- On JS side: `Commands.play(nativeRef)` sends the command to native
- Consumer uses `useRef<VideoPlayerRef>` + `ref.current.play()` for a clean API
- iOS receives commands via `handleCommand:args:` on the `RCTViewComponentView`
- Android receives commands via the `ManagerInterface` override methods
