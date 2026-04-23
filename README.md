# Fabric Video Player Demo

A step-by-step example of building a Fabric Native Component in React Native.

The currently checked-in tutorial branches in this repository target React Native `0.82.1`. The active migration goal is to rebuild the tutorial as a clean React Native `0.85.1` branch ladder under the `RNN` Linear project.

## Branches

This repo currently contains the historical lecture ladder:

| Branch | Description |
|--------|-------------|
| `step-0-scaffold` | Clean RN 0.82.x project |
| `step-1-js-spec` | TypeScript component spec + initial JS wrapper |
| `step-2-ios` | iOS native implementation + app-level Fabric registration |
| `step-3-android` | Android native implementation + manual package registration |
| `step-4-usage` | Basic `App.tsx` usage example |
| `step-5-events` | Progress & completion events |
| `step-6-commands` | Native commands (play/pause/seek) |
| **`main`** | **Complete working example** |

Planned migration ladder:

| Branch | Description |
|--------|-------------|
| `rn85-step-0-scaffold` | Clean RN 0.85.1 scaffold baseline |
| `rn85-step-1-js-spec` | JS spec and RN 0.85.1 tooling alignment |
| `rn85-step-2-ios` | iOS Fabric implementation rebuild |
| `rn85-step-3-android` | Android Fabric implementation rebuild |
| `rn85-step-4-usage` | App usage example rebuild |
| `rn85-step-5-events` | Progress and completion events rebuild |
| `rn85-step-6-commands` | Native commands rebuild |

The historical `step-*` branches remain as reference material. The RN `0.85.1` work is expected to land as a new clean ancestor chain rather than rewriting those existing lecture branches in place.

## RN 0.85.1 Upgrade Plan

Target React Native version: `0.85.1`.

Start the rebuilt ladder from a fresh React Native `0.85.1` scaffold, then replay the tutorial changes in order on `rn85-step-*` branches. Do not rewrite, rename, or repurpose the historical `step-*` branches. The required target ancestry is linear:

```text
rn85-step-0-scaffold
  -> rn85-step-1-js-spec
  -> rn85-step-2-ios
  -> rn85-step-3-android
  -> rn85-step-4-usage
  -> rn85-step-5-events
  -> rn85-step-6-commands
```

Package and template targets verified from the published React Native `0.85.1` packages:

| Area | Target |
|------|--------|
| Runtime packages | `react-native@0.85.1`, `react@19.2.3`, `react-test-renderer@19.2.3` |
| React Native packages | `@react-native/new-app-screen@0.85.1`, `@react-native/babel-preset@0.85.1`, `@react-native/eslint-config@0.85.1`, `@react-native/jest-preset@0.85.1`, `@react-native/metro-config@0.85.1`, `@react-native/typescript-config@0.85.1` |
| CLI packages | `@react-native-community/cli@20.1.0`, `@react-native-community/cli-platform-android@20.1.0`, `@react-native-community/cli-platform-ios@20.1.0` |
| Testing and TypeScript | `jest@^29.6.3`, `@types/jest@^29.5.13`, `@types/react@^19.2.0`, `@types/react-test-renderer@^19.1.0`, `typescript@^5.8.3`; Jest preset must move from `react-native` to `@react-native/jest-preset` |
| Android template | Gradle wrapper `9.3.1`, Android Gradle Plugin `8.12.0` via `@react-native/gradle-plugin@0.85.1`, Kotlin `2.1.20`, Android SDK `36`, min SDK `24`, NDK `27.1.12297006` |
| iOS template | `platform :ios, min_ios_version_supported`; RN `0.85.1` resolves that helper to iOS `15.1`; RN pod helpers require Xcode `16.1` or newer |
| Ruby and CocoaPods | Template Gemfile keeps Ruby `>= 2.6.10`, CocoaPods `>= 1.13` excluding `1.15.0` and `1.15.1`, plus the template `xcodeproj`, `activesupport`, and Ruby 3.4 compatibility gem constraints |
| Node | Use Node `22.13.x` for the rebuild unless a later validation issue intentionally selects another supported RN engine range. The template declares `>= 22.11.0`, while `react-native@0.85.1` package metadata accepts `^20.19.4 || ^22.13.0 || ^24.3.0 || >= 25.0.0`; `22.13.x` satisfies both the template intent and the package engine range. |

Existing history should be reused selectively:

| Use | Commits |
|-----|---------|
| Replace, not cherry-pick | `58d8b82 chore: initial RN 0.82 scaffold`; create `rn85-step-0-scaffold` from a fresh RN `0.85.1` template instead. |
| Replay manually on the new scaffold | `eec141d feat: add VideoPlayer component spec for Codegen`, `426e4df feat: add iOS native implementation for RTNVideoPlayer`, `33ff249 feat: add Android native implementation for RTNVideoPlayer`, `4de9c93 feat: add basic VideoPlayer usage example`, `ef7d761 feat: add video progress and end events`, `cb3bc30 feat: add native commands for play, pause, seekTo`. These contain reusable tutorial source, but also RN `0.82.1` package, native project, and README context that should not be copied wholesale. |
| Cherry-pick candidates after each step exists | `4627447 chore(eslint): allow codegen deep imports in specs`, `f36edc8 fix(events): stop progress reporting on end`, `9587234 fix(ios): make bridging header import explicit`, `4b5d9dc chore(android): remove unused import`. Apply only if the RN `0.85.1` files still need the same focused fix. |
| Validate before reuse | `5512a81 fix(ios): register RTNVideoPlayer with Fabric`; RN `0.85.1` should first be checked against `codegenConfig.ios.componentProvider` before carrying forward the current app-level `thirdPartyFabricComponents()` registration path. |

Success criteria for the rebuilt ladder:

- Each `rn85-step-*` branch has exactly the previous target branch as its ancestor and no wholesale merge from `main` or historical `step-*` branches.
- Each step stays teachable: scaffold, JS spec, iOS, Android, usage, events, and commands are introduced in that order with no future-step code leaking backward.
- Dependency and template churn is isolated to the scaffold/tooling step unless a later platform step has a specific RN `0.85.1` reason to change it.
- iOS validates `pod install`, Codegen output, Fabric registration, build/run, playback, events, and commands on the branch where each feature is introduced.
- Android validates Gradle sync/build, Codegen output, package registration, playback, events, and commands on the branch where each feature is introduced.

Known risks for later validation:

- RN `0.85.1` iOS Codegen may make `codegenConfig.ios.componentProvider` preferable to the current manual Fabric registration.
- Android Gradle `9.3.1` plus AGP `8.12.0` may require local Java/Android Studio alignment beyond the current RN `0.82.1` project.
- The Jest config must move to `@react-native/jest-preset`; keeping `preset: 'react-native'` is not the RN `0.85.1` template shape.
- Event and command behavior must be re-tested on rebuilt iOS and Android branches instead of assumed from the RN `0.82.1` implementation.

## Running

```bash
npm install
cd ios && pod install && cd ..
npm run ios
npm run android
```

These commands describe the current checked-in branch family. The final RN `0.85.1` rebuild may update some supporting template details as the new ladder is validated.

## Codegen Notes

- After changing files in `src/specs/**`, re-run `cd ios && pod install && cd ..` so iOS codegen artifacts are regenerated.
- Android codegen runs as part of the Gradle build; if you get stale types, try a clean rebuild (`cd android && ./gradlew clean`).
- The codegen helpers are imported from `react-native/Libraries/...` in `src/specs/**` (ESLint deep-import warnings are disabled for specs only).

## Key Concepts

- **Fabric Native Components**: Modern React Native architecture for native views
- **Codegen & TypeScript specs**: Type-safe native interface generation
- **DirectEventHandler**: For events from native to JS
- **codegenNativeCommands**: For imperative API (play/pause/seek)
- **iOS**: RCTViewComponentView with Swift AVPlayer
- **iOS registration**: the current checked-in implementation uses app-level `thirdPartyFabricComponents`; the RN `0.85.1` migration is expected to revalidate this path against current Codegen guidance
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

## Slides

- Lecture deck: `docs/slides/React Native View modules - Lection 3.pptx`
