# Fabric Video Player Demo

A step-by-step example of building a Fabric Native Component in React Native 0.82.

## Branches

Checkout each branch to follow along:

| Branch | Description |
|--------|-------------|
| `step-0-scaffold` | Clean RN 0.82 project |
| `step-1-js-spec` | TypeScript component spec |
| `step-2-ios` | iOS native implementation |
| **`step-3-android`** | **Android native implementation** |
| `step-4-usage` | Basic usage example |
| `step-5-events` | Progress & completion events |
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

Implement the Android native side of the `RTNVideoPlayer` Fabric component using Kotlin.

### What was added

- **`RTNVideoPlayerManager.kt`** — ViewManager with Fabric delegate
  - Extends `SimpleViewManager<RTNVideoPlayerView>`
  - Implements `RTNVideoPlayerManagerInterface` (Codegen-generated)
  - Uses `RTNVideoPlayerManagerDelegate` for Fabric prop handling
  - `@ReactProp` annotations for `sourceUrl` and `paused`
- **`RTNVideoPlayerView.kt`** — ExoPlayer-based video view
  - Extends `FrameLayout`, embeds `PlayerView` from Media3
  - `setSourceUrl()` / `setPaused()` control playback
  - Proper resource cleanup in `onDetachedFromWindow()`
- **`RTNVideoPlayerPackage.kt`** — Package registration
  - Implements `ReactPackage`, returns the ViewManager
- **`MainApplication.kt`** — Registers `RTNVideoPlayerPackage`
- **`build.gradle`** — Added Media3/ExoPlayer dependencies

### Key Concepts

- Android Fabric components use `SimpleViewManager` + a Codegen-generated `ManagerDelegate`
- The `ManagerInterface` is auto-generated from the TypeScript spec — your ViewManager implements it
- ExoPlayer (Media3) is the standard Android video playback library
- iOS `RTNVideoPlayer` registration happens via `thirdPartyFabricComponents` (see `ios/ReactNativeNativeIntegration/AppDelegate.swift`)
- The codegen helpers are imported from `react-native/Libraries/...` in `src/specs/**` (ESLint deep-import warnings are disabled for specs only)
