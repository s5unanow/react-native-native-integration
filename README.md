# Fabric Video Player Demo

A step-by-step tutorial repo for building a Fabric Native Component in React Native.

This branch adds progress and completion events from the native video player back to React Native.

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

Send playback progress and completion events from native code to JavaScript.

### What was added

- `src/specs/RTNVideoPlayerNativeComponent.ts` declares `onVideoProgress` and `onVideoEnd` direct events.
- `src/components/VideoPlayer.tsx` exposes those native events as `onProgress` and `onEnd` wrapper props.
- `ios/RTNVideoPlayer/RTNVideoPlayerView.mm` forwards Swift callbacks through the generated Fabric event emitter.
- `ios/RTNVideoPlayer/RTNVideoPlayerViewSwift.swift` reports progress and video completion from `AVPlayer`.
- `android/app/src/main/java/com/reactnativenativeintegration/videoplayer/RTNVideoPlayerManager.kt` exports the direct event registration names.
- `android/app/src/main/java/com/reactnativenativeintegration/videoplayer/RTNVideoPlayerView.kt` dispatches progress and completion events from ExoPlayer.
- `App.tsx` renders progress, duration, and end state received from native events.

## Slides

- Lecture deck: `docs/slides/React Native View modules - Lection 3.pptx`
