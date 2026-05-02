# Fabric Video Player Demo

A step-by-step tutorial repo for building a Fabric Native Component in React Native `0.85.1`.

`main` is the landing branch for the repository. It explains the tutorial ladder and keeps a clean React Native `0.85.1` scaffold in the tree, but the canonical lesson states live on the `step-*` branches.

## Branches

| Branch | Description |
|--------|-------------|
| `main` | Landing branch and RN 0.85.1 scaffold reference |
| `step-0-scaffold` | Clean RN 0.85.1 scaffold baseline |
| `step-1-js-spec` | JS spec and React wrapper |
| `step-2-ios` | iOS Fabric implementation |
| `step-3-android` | Android Fabric implementation |
| `step-4-usage` | App usage example |
| `step-5-events` | Progress and completion events |
| `step-6-commands` | Native commands |

Use the direct `step-*` ladder when following or updating the tutorial. `step-6-commands` is the completed tutorial implementation.

## Running

On `main` and `step-0-scaffold`, the app is just the scaffold baseline:

```bash
npm install
cd ios && bundle exec pod install && cd ..
npm run ios
npm run android
```

Later step branches add the native video player, events, and commands on top of that baseline.

## Main Branch

`main` should stay small and stable:

- Point readers to the canonical tutorial branches.
- Keep repo-wide docs aligned with the validated RN `0.85.1` ladder.
- Avoid stale implementation snippets or one-off work plans.
- Do not mirror `step-6-commands` unless the repo policy changes deliberately.

## Scaffold Baseline

The code on `main` is a stock React Native `0.85.1` app named `ReactNativeNativeIntegration`, using the default Android package `com.reactnativenativeintegration`. New Architecture and Hermes are enabled by the template defaults, and Jest uses `@react-native/jest-preset`.

## Slides

- Lecture deck: `docs/slides/React Native View modules - Lection 3.pptx`
