# Fabric Video Player Demo

A step-by-step tutorial repo for building a Fabric Native Component in React Native.

This branch completes the tutorial ladder by adding native commands for play, pause, and seek behavior.

## Branches

| Branch | Description |
|--------|-------------|
| `step-0-scaffold` | Clean RN 0.85.1 scaffold baseline |
| `step-1-js-spec` | JS spec and React wrapper |
| `step-2-ios` | iOS Fabric implementation |
| `step-3-android` | Android Fabric implementation |
| `step-4-usage` | App usage example |
| `step-5-events` | Progress and completion events |
| `step-6-commands` | Native commands |

## Running

```bash
npm install
cd ios && bundle exec pod install && cd ..
npm run ios
npm run android
```

## Codegen Notes

- After changing files in `src/specs/**`, re-run `cd ios && bundle exec pod install && cd ..` so iOS Codegen artifacts are regenerated.
- Android Codegen runs as part of the Gradle build; if generated types become stale, run a clean rebuild from `android/`.
- RN `0.85.1` exposes `codegenNativeComponent` from the public `react-native` entry point, so this branch does not need a deep-import ESLint exception for the spec.

## This Step

Add native commands for the `RTNVideoPlayer` Fabric component.

### What was added

- `src/specs/RTNVideoPlayerNativeComponent.ts` declares the `play`, `pause`, and `seekTo` native commands.
- `src/components/VideoPlayer.tsx` exposes those commands through the React wrapper ref.
- `ios/RTNVideoPlayer/RTNVideoPlayerView.mm` forwards Fabric commands to the Swift player view.
- `ios/RTNVideoPlayer/RTNVideoPlayerViewSwift.swift` implements play, pause, and seek behavior.
- `android/app/src/main/java/com/reactnativenativeintegration/videoplayer/RTNVideoPlayerManager.kt` implements the generated command interface.
- `android/app/src/main/java/com/reactnativenativeintegration/videoplayer/RTNVideoPlayerView.kt` applies command behavior to the native Android player.
- `App.tsx` adds controls that exercise the commands from JS.

## Slides

- Lecture deck: `docs/slides/React Native View modules - Lection 3.pptx`
