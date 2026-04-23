# Fabric Video Player Demo

A step-by-step example of building a Fabric Native Component in React Native.

The currently checked-in tutorial branches in this repository target React Native `0.82.1`. The active migration goal is to rebuild the tutorial as a clean React Native `0.85.1` branch ladder under the `RNN` Linear project.

## Branches

This repo currently contains the historical lecture ladder:

| Branch | Description |
|--------|-------------|
| `step-0-scaffold` | Clean RN 0.82.x project |
| `step-1-js-spec` | TypeScript component spec + initial JS wrapper |
| `step-2-ios` | iOS native implementation + app-level Fabric registration |
| `step-3-android` | Android native implementation + manual package registration |
| `step-4-usage` | Basic `App.tsx` usage example |
| `step-5-events` | Progress & completion events |
| `step-6-commands` | Native commands (play/pause/seek) |
| **`main`** | **Complete working example** |

Planned migration ladder:

| Branch | Description |
|--------|-------------|
| `rn85-step-0-scaffold` | Clean RN 0.85.1 scaffold baseline |
| `rn85-step-1-js-spec` | JS spec and RN 0.85.1 tooling alignment |
| `rn85-step-2-ios` | iOS Fabric implementation rebuild |
| `rn85-step-3-android` | Android Fabric implementation rebuild |
| `rn85-step-4-usage` | App usage example rebuild |
| `rn85-step-5-events` | Progress and completion events rebuild |
| `rn85-step-6-commands` | Native commands rebuild |

The historical `step-*` branches remain as reference material. The RN `0.85.1` work is expected to land as a new clean ancestor chain rather than rewriting those existing lecture branches in place.

## Running

```bash
npm install
cd ios && pod install && cd ..
npm run ios
npm run android
```

These commands describe the current checked-in branch family. The final RN `0.85.1` rebuild may update some supporting template details as the new ladder is validated.

## Codegen Notes

- After changing files in `src/specs/**`, re-run `cd ios && pod install && cd ..` so iOS codegen artifacts are regenerated.
- Android codegen runs as part of the Gradle build; if you get stale types, try a clean rebuild (`cd android && ./gradlew clean`).
- The codegen helpers are imported from `react-native/Libraries/...` in `src/specs/**` (ESLint deep-import warnings are disabled for specs only).

## Key Concepts

- **Fabric Native Components**: Modern React Native architecture for native views
- **Codegen & TypeScript specs**: Type-safe native interface generation
- **DirectEventHandler**: For events from native to JS
- **codegenNativeCommands**: For imperative API (play/pause/seek)
- **iOS**: RCTViewComponentView with Swift AVPlayer
- **iOS registration**: the current checked-in implementation uses app-level `thirdPartyFabricComponents`; the RN `0.85.1` migration is expected to revalidate this path against current Codegen guidance
- **Android**: SimpleViewManager with Fabric delegate and ExoPlayer

## Project Structure

```
src/
├── specs/
│   ├── RTNVideoPlayerNativeComponent.ts  # Component spec with props & events
│   └── RTNVideoPlayerCommands.ts          # Native commands spec
└── components/
    └── VideoPlayer.tsx                    # React wrapper component

ios/RTNVideoPlayer/
├── RTNVideoPlayerManager.mm               # Legacy bridge (backward compat)
├── RTNVideoPlayerView.h                   # Fabric component header
├── RTNVideoPlayerView.mm                  # Fabric component implementation
└── RTNVideoPlayerViewSwift.swift          # Swift AVPlayer implementation

android/app/src/main/java/.../videoplayer/
├── RTNVideoPlayerManager.kt               # ViewManager with Fabric delegate
├── RTNVideoPlayerPackage.kt               # Package registration
└── RTNVideoPlayerView.kt                  # ExoPlayer implementation
```

## Features

- Video playback from URL
- Pause/resume support
- Progress events (currentTime, duration, progress)
- Video end event
- Native commands: play(), pause(), seekTo(time)
- Full TypeScript type safety

## Slides

- Lecture deck: `docs/slides/React Native View modules - Lection 3.pptx`
