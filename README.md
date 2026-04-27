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

Define the TypeScript Codegen spec for the `RTNVideoPlayer` Fabric component and add a teaching-friendly React wrapper.

### What was added

- `src/specs/RTNVideoPlayerNativeComponent.ts` defines the native component interface for Codegen.
  - Component name: `RTNVideoPlayer`
  - Props: `sourceUrl` and optional `paused`
  - Codegen library name: `RTNVideoPlayerSpec`
- `src/components/VideoPlayer.tsx` wraps the native component behind a simple React API.
  - Preserves `sourceUrl`, `paused`, and `style` props for later tutorial steps.
  - Applies default 16:9 player styling.
- `package.json` includes `codegenConfig` for the component package.
  - `type`: `components`
  - `jsSrcsDir`: `src/specs`
  - Android package: `com.reactnativenativeintegration.videoplayer`

## Slides

- Lecture deck: `docs/slides/React Native View modules - Lection 3.pptx`
