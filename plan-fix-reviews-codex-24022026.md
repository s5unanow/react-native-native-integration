## Plan: Fix review items (Codex, 2026-02-24)

Goal: close the gaps found in the repo assessment while preserving the educational “step branches” flow (each branch only gets fixes appropriate for that step).

### Issues to fix

1. iOS Fabric component registration is missing
   - Symptom: `RTNVideoPlayerView.mm` defines `RTNVideoPlayerCls()`, but the app never registers `"RTNVideoPlayer" -> RTNVideoPlayerView` in `thirdPartyFabricComponents`, so Fabric may create `<UnimplementedView>` or fall back to interop.
   - Fix: override `thirdPartyFabricComponents` in `ios/ReactNativeNativeIntegration/AppDelegate.swift` and include `RTNVideoPlayerView`.
   - Supporting: import `RTNVideoPlayerView.h` into the Swift bridging header so Swift can reference `RTNVideoPlayerView`.

2. iOS “legacy manager” is misleading (returns blank `UIView`)
   - Symptom: `ios/RTNVideoPlayer/RTNVideoPlayerManager.mm` exports `RTNVideoPlayer` but returns an empty `UIView`, which is confusing for learners and breaks interop fallback behavior.
   - Fix: return the real `RTNVideoPlayerViewSwift` for the legacy view manager (props-only). Keep it explicitly “legacy / interop only” in docs.

3. Progress reporting keeps running after video ends
   - Symptom: progress timers/runnables can continue after end.
   - Fix:
     - iOS: stop the timer when `.AVPlayerItemDidPlayToEndTime` fires.
     - Android: stop the runnable when `Player.STATE_ENDED` fires.

4. ESLint warnings about “deep imports” in codegen specs confuse learners
   - Symptom: `@react-native/no-deep-imports` warns on `react-native/Libraries/Utilities/codegenNativeComponent` and `codegenNativeCommands` even though these are the common codegen entry points.
   - Fix: add an ESLint override that disables this rule for `src/specs/**` only.

### Branch update strategy

Create small, focused commits on the earliest branch where the fix is applicable, then cherry-pick forward onto later branches and `main`.

- `step-0-scaffold`
  - No changes (keep as pristine scaffold).

- `step-1-js-spec` (and later)
  - ESLint override for `src/specs/**`.
  - README note: deep imports are expected for codegen specs in this project.

- `step-2-ios` (and later)
  - iOS Fabric registration fix in `AppDelegate.swift`.
  - Bridging header import of `RTNVideoPlayerView.h`.
  - Legacy manager returns `RTNVideoPlayerViewSwift` (props-only).
  - README: correct the statement about how registration happens (it’s via `thirdPartyFabricComponents`, not “plugin auto-registration”).

- `step-5-events` (and later)
  - Stop progress updates on end (iOS + Android).
  - README: mention progress stops on end.

### Verification (repo-local)

- `npm run lint`
- `npx tsc -p tsconfig.json --noEmit`

Native builds are out of scope for automated verification here, but recommended manually:
- iOS: `cd ios && pod install && cd .. && npm run ios`
- Android: `npm run android`

