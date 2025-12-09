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
| `step-6-commands` | Native commands (play/pause/seek) |
| **`main`** | **Complete working example** |

## Running

```bash
npm install
cd ios && pod install && cd ..
npm run ios
npm run android
```

## Key Concepts

- **Fabric Native Components**: Modern React Native architecture for native views
- **Codegen & TypeScript specs**: Type-safe native interface generation
- **DirectEventHandler**: For events from native to JS
- **codegenNativeCommands**: For imperative API (play/pause/seek)
- **iOS**: RCTViewComponentView with Swift AVPlayer
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
