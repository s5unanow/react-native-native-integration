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
| **`step-5-events`** | **Progress & completion events** |
| `step-6-commands` | Native commands (play/pause/seek) |
| `main` | Complete working example |

## Running

```bash
npm install
cd ios && pod install && cd ..
npm run ios
npm run android
```

## Codegen Notes

- After changing files in `src/specs/**`, re-run `cd ios && pod install && cd ..` so iOS codegen artifacts are regenerated.
- Android codegen runs as part of the Gradle build; if you get stale types, try a clean rebuild (`cd android && ./gradlew clean`).

## This Step

Add native-to-JS events: video progress reporting and video end notification.

### What was changed

- **`src/specs/RTNVideoPlayerNativeComponent.ts`** — Added event types to the Codegen spec
  - `onVideoProgress`: `DirectEventHandler` with `currentTime`, `duration`, `progress` (all `Double`)
  - `onVideoEnd`: `DirectEventHandler` with empty payload
- **`src/components/VideoPlayer.tsx`** — Added `onProgress` and `onEnd` callback props
  - Maps `onVideoProgress` native event → `onProgress` with unwrapped `nativeEvent`
- **`RTNVideoPlayerViewSwift.swift`** (iOS) — Added progress timer and end observer
  - 500ms `Timer` emits progress data while playing
  - `NotificationCenter` observer for `AVPlayerItemDidPlayToEndTime`
  - Stops progress reporting when the video ends
  - Proper cleanup in `deinit` and when re-setting source
- **`RTNVideoPlayerView.kt`** (Android) — Added progress handler and end listener
  - `Handler`/`Runnable` pattern emits progress every 500ms
  - `Player.Listener.onPlaybackStateChanged` detects `STATE_ENDED`
  - Stops progress reporting when the video ends
  - Custom `Event` subclasses: `VideoProgressEvent`, `VideoEndEvent`
- **`RTNVideoPlayerManager.kt`** (Android) — Registered event type constants
- **`RTNVideoPlayerView.mm`** (iOS) — Wired Swift callbacks to Fabric `EventEmitter`
- **`App.tsx`** — Added progress bar and time display

### Key Concepts

- **`DirectEventHandler<T>`** in the Codegen spec generates event infrastructure on both platforms
- iOS: Events flow through the Fabric `EventEmitter` (C++ → JS)
- Android: Events use `Event` subclasses dispatched via `UIManagerHelper.getEventDispatcherForReactTag`
- Event names follow the convention: native `topVideoProgress` → JS `onVideoProgress`
- iOS `RTNVideoPlayer` registration happens via `thirdPartyFabricComponents` (see `ios/ReactNativeNativeIntegration/AppDelegate.swift`)
- The codegen helpers are imported from `react-native/Libraries/...` in `src/specs/**` (ESLint deep-import warnings are disabled for specs only)
