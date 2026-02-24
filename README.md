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
| **`step-4-usage`** | **Basic usage example** |
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

Wire the native component into the React app and play a video.

### What was changed

- **`App.tsx`** — Replaced boilerplate with `VideoPlayer` usage
  - Renders `<VideoPlayer sourceUrl={SAMPLE_VIDEO} />` with a sample MP4
  - Simple layout: header, player (16:9), info text
- **`ios/Info.plist`** — Relaxed App Transport Security to allow loading remote video URLs
- **`android/app/src/main/AndroidManifest.xml`** — Ensured `android.permission.INTERNET` is present for remote URLs

### What you should see

A working video player rendering Big Buck Bunny from a remote URL. The video plays automatically on both iOS and Android.

### Key Concepts

- The `VideoPlayer` wrapper component hides the native `RTNVideoPlayer` from app code
- Props flow: `sourceUrl` (JS) → Codegen → native view → AVPlayer / ExoPlayer
- This is the first end-to-end test: JS spec + iOS native + Android native all connected
- iOS `RTNVideoPlayer` registration happens via `thirdPartyFabricComponents` (see `ios/ReactNativeNativeIntegration/AppDelegate.swift`)
- The codegen helpers are imported from `react-native/Libraries/...` in `src/specs/**` (ESLint deep-import warnings are disabled for specs only)
