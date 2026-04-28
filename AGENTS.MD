ReactNativeNativeIntegration - Agent Guidance

Purpose
This repository demonstrates a Fabric native video player tutorial for React Native `0.85.1`.

Current Project Goal
The active Linear project is `RNN`. The current epic is `S5U-712`:
- Upgrade the tutorial repo to React Native `0.85.1`
- Maintain the lecture branch ladder as a clean ancestor chain
- Keep iOS, Android, events, and commands working across the ladder
- Keep repo docs aligned with the validated ladder

Branch Policy
The canonical tutorial branches are:
- `step-0-scaffold`
- `step-1-js-spec`
- `step-2-ios`
- `step-3-android`
- `step-4-usage`
- `step-5-events`
- `step-6-commands`

Rules:
- Use the direct `step-*` ladder for new tutorial work.
- Keep canonical branch names unprefixed.
- Treat archived older branch tips as recovery points, not workflow inputs.
- Do not change `main` merge policy casually. That decision belongs in separate validation work.

How To Scope Changes
When making repo-wide guidance changes, prefer stable instructions that can survive across multiple branches:
- Keep agent-facing docs branch-agnostic where possible.
- Avoid embedding branch-specific implementation snippets in repo-wide instruction files unless the detail is stable across the ladder.
- If a note only applies to one lecture step, keep it in that branch or step-specific documentation rather than in repo-wide guidance.
- If implementation details need revalidation after a React Native or native tooling change, describe them as validation targets rather than permanent truth.

Native Comment Hygiene
When changing native iOS or Android platform implementation, keep nearby teaching comments in sync:
- Use only the two native code labels `Fabric related:` and `Implementation detail:` when adding new explanatory comments.
- Update comments when changing native behavior so they describe the current code, not the old lecture flow.
- Delete or move comments together with the native code they describe.

Propagation Strategy
When the same doc change needs to land across multiple tutorial branches, use a low-noise approach:
1. Isolate the change into a doc-only commit with no unrelated code or generated-file churn.
2. Keep the patch limited to repo-wide files such as `AGENTS.MD` and `README.md` unless another doc is truly required.
3. Land the shared wording on the earliest compatible branch.
4. Cherry-pick or replay that same commit across descendant branches.
5. If a branch has a legitimate wording difference, keep the delta local to that branch instead of making the shared doc more complex.

RN `0.85.1` Validation Constraints
Agent work should stay aligned with the validation issues under `S5U-712`:
- Tooling and dependency alignment belong to focused RN `0.85.1` step work, not to general doc-only commits.
- Jest should move to `@react-native/jest-preset` as part of the RN `0.85.1` JS/tooling step.
- iOS Fabric registration should be revalidated against `codegenConfig.ios.componentProvider` instead of assuming the current manual `thirdPartyFabricComponents()` path remains correct.
- iOS and Android command/event behavior must be validated on the direct `step-*` ladder.

Preferred Delivery Shape
For repo-wide agent guidance updates:
- Keep changes small, explicit, and easy to cherry-pick.
- Prefer updating existing top-level docs over creating new scattered process files.
- Leave unrelated workspace changes untouched.
- Call out whether the change is safe to propagate across branches.

Files Most Likely To Need Shared Guidance Updates
- `AGENTS.MD`
- `README.md`

Only update additional files when they materially affect contributor or agent workflow across branches.
