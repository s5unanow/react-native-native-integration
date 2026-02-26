# Fabric Video Player Demo

A step-by-step example of building a Fabric Native Component in React Native 0.82.

## Branches

Checkout each branch to follow along:

| Branch | Description |
|--------|-------------|
| **`step-0-scaffold`** | **Clean RN 0.82 project** |
| `step-1-js-spec` | TypeScript component spec |
| `step-2-ios` | iOS native implementation |
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

Starting point: a clean React Native 0.82 project scaffolded with `@react-native-community/cli`.

- React Native **0.82.1** with React 19.1.1
- New Architecture (Fabric) enabled by default
- TypeScript configured
- iOS and Android project structure ready

No custom native code yet — this is the baseline we'll build on.

## Slides

- Lecture deck: `docs/slides/React Native View modules - Lection 3.pptx`
