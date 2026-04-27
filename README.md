# Fabric Video Player Demo

A step-by-step tutorial repo for building a Fabric Native Component in React Native.

This branch adds the JavaScript-facing `RTNVideoPlayer` Fabric component spec and a small React wrapper. It intentionally stops before adding native iOS or Android video playback.

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

Add the iOS native implementation for the `RTNVideoPlayer` Fabric component.

### What was added

- `ios/RTNVideoPlayer/RTNVideoPlayerView.h` declares the Fabric component view.
- `ios/RTNVideoPlayer/RTNVideoPlayerView.mm` bridges the generated Codegen props into the UIKit-backed view.
  - Registers the `RTNVideoPlayer` component descriptor.
  - Applies `sourceUrl` and `paused` prop updates.
  - Resets native playback state when Fabric recycles the view.
- `ios/RTNVideoPlayer/RTNVideoPlayerViewSwift.swift` implements the native player with `AVPlayer` and `AVPlayerLayer`.
  - Creates playback from `sourceUrl`.
  - Plays or pauses from the `paused` prop.
  - Keeps the video layer sized to the React Native view bounds.
- `package.json` adds `codegenConfig.ios.componentProvider` so Codegen can provide `RTNVideoPlayerView` for the Fabric component.
- `ios/ReactNativeNativeIntegration.xcodeproj/project.pbxproj` includes the new native iOS source files in the app target.

Later tutorial branches should add Android implementation, usage, events, and commands in the documented ladder order.

## Slides

- Lecture deck: `docs/slides/React Native View modules - Lection 3.pptx`
