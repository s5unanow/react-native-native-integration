# Fabric Video Player Demo

A step-by-step tutorial repo for building a Fabric Native Component in React Native.

This branch renders the `VideoPlayer` wrapper from the app so the native iOS and Android views are visible in a real screen.

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

Render the Fabric video player from React Native app code.

### What was added

- `App.tsx` imports the `VideoPlayer` React wrapper.
- A sample video URL is passed as `sourceUrl`.
- The screen includes simple header and footer copy for the demo.
- The same JSX component is backed by `AVPlayer` on iOS and ExoPlayer on Android.

## Slides

- Lecture deck: `docs/slides/React Native View modules - Lection 3.pptx`
