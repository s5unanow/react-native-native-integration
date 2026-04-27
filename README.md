# Fabric Video Player Demo

A step-by-step tutorial repo for building a Fabric Native Component in React Native.

This branch is the clean React Native `0.85.1` scaffold baseline. It intentionally does not include the custom video player component yet.

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

## This Step

Start from a fresh React Native `0.85.1` app that later branches can build on one layer at a time.

### What was added

- A stock React Native app named `ReactNativeNativeIntegration`.
- The default Android package `com.reactnativenativeintegration`.
- New Architecture and Hermes enabled by the template defaults.
- Jest configured with `@react-native/jest-preset`.
- No custom native video component, Codegen spec, Fabric registration, or Android package registration yet.

## Slides

- Lecture deck: `docs/slides/React Native View modules - Lection 3.pptx`
