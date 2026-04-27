# Fabric Video Player Demo

A step-by-step tutorial repo for building a Fabric Native Component in React Native.

This branch adds the iOS native implementation for the `RTNVideoPlayer` Fabric component. Android playback is added in the next step.

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

Add the Android native implementation for the `RTNVideoPlayer` Fabric component.

### What was added

- `android/app/build.gradle` adds the AndroidX Media3 ExoPlayer dependencies used by the native view.
- `android/app/src/main/java/com/reactnativenativeintegration/videoplayer/RTNVideoPlayerView.kt` implements the native Android player view.
  - Hosts a Media3 `PlayerView`.
  - Creates an `ExoPlayer` for `sourceUrl`.
  - Applies `paused` by updating `playWhenReady`.
  - Releases the player when the React Native view is dropped or detached.
- `android/app/src/main/java/com/reactnativenativeintegration/videoplayer/RTNVideoPlayerManager.kt` exposes the Fabric component view manager.
  - Uses the generated `RTNVideoPlayerManagerDelegate`.
  - Applies the generated `sourceUrl` and `paused` props.
- `android/app/src/main/java/com/reactnativenativeintegration/videoplayer/RTNVideoPlayerPackage.kt` registers the view manager in a React package.
- `android/app/src/main/java/com/reactnativenativeintegration/MainApplication.kt` manually adds `RTNVideoPlayerPackage` to the app package list.

Later tutorial branches should add usage, events, and commands in the documented ladder order.

## Slides

- Lecture deck: `docs/slides/React Native View modules - Lection 3.pptx`
