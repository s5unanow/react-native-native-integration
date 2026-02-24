# Fabric Video Player Demo

A step-by-step example of building a Fabric Native Component in React Native 0.82.

## Branches

Checkout each branch to follow along:

| Branch | Description |
|--------|-------------|
| `step-0-scaffold` | Clean RN 0.82 project |
| `step-1-js-spec` | TypeScript component spec |
| **`step-2-ios`** | **iOS native implementation** |
| `step-3-android` | Android native implementation |
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

## This Step

Implement the iOS native side of the `RTNVideoPlayer` Fabric component using Objective-C++ and Swift.

### What was added

- **`ios/RTNVideoPlayer/RTNVideoPlayerView.h`** — Fabric component view header
- **`ios/RTNVideoPlayer/RTNVideoPlayerView.mm`** — Fabric component view (Objective-C++)
  - Extends `RCTViewComponentView` (Fabric base class)
  - Implements `componentDescriptorProvider` for Fabric registration
  - `updateProps:oldProps:` handles prop synchronization from JS to native
  - Bridges to Swift via `RTNVideoPlayerViewSwift`
- **`ios/RTNVideoPlayer/RTNVideoPlayerViewSwift.swift`** — Video player (Swift)
  - Uses `AVPlayer` + `AVPlayerLayer` for video playback
  - `sourceUrl` and `paused` properties with `didSet` observers
  - Proper layout handling in `layoutSubviews`
- **`ios/RTNVideoPlayer/RTNVideoPlayerManager.mm`** — View manager for backward compatibility
- **Bridging header** configured for Swift/Objective-C interop

### Key Concepts

- **`RCTViewComponentView`** is the Fabric base class for native views (replaces the old `RCTView`)
- Props flow: JS → Codegen C++ structs → `updateProps:oldProps:` → Swift view
- `RTNVideoPlayerCls()` exposes the Fabric `ComponentView` class; the app registers `"RTNVideoPlayer"` via `thirdPartyFabricComponents` (see `ios/ReactNativeNativeIntegration/AppDelegate.swift`)
