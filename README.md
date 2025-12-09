# Fabric Video Player Demo

A step-by-step example of building a Fabric Native Component in React Native 0.82.

## Branches

Checkout each branch to follow along:

| Branch | Description |
|--------|-------------|
| `step-0-scaffold` | Clean RN 0.82 project |
| **`step-1-js-spec`** | **TypeScript component spec** |
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

Define the TypeScript Codegen spec for the `RTNVideoPlayer` Fabric component.

### What was added

- **`src/specs/RTNVideoPlayerNativeComponent.ts`** — Codegen spec defining the native component interface
  - Uses `codegenNativeComponent()` to register with Fabric
  - Props: `sourceUrl` (string), `paused` (boolean)
  - Returns `HostComponent<NativeProps>` for type-safe usage
- **`src/components/VideoPlayer.tsx`** — React wrapper component
  - Abstracts the native component from app code
  - Default 16:9 aspect ratio styling
- **`package.json`** — Added `codegenConfig` section
  - `name`: `RTNVideoPlayerSpec`
  - `type`: `components` (Fabric view component)
  - `jsSrcsDir`: `src/specs`

### Key Concepts

- **Codegen** reads TypeScript specs and generates native interfaces (C++, Java, ObjC)
- Component name `'RTNVideoPlayer'` must match native implementations exactly
- `HostComponent` is the Fabric type for native view components
