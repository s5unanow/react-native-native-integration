ReactNativeNativeIntegration - Agent Guidance

Purpose
This repository demonstrates a Fabric native video player tutorial for React Native. The current checked-in branch family is the historical React Native `0.82.1` sequence, while the active project goal is to rebuild the tutorial on React Native `0.85.1`.

Current Project Goal
The active Linear project is `RNN`. The current epic is `S5U-712`:
- Upgrade the tutorial repo to React Native `0.85.1`
- Rebuild the lecture branch ladder as a clean ancestor chain
- Keep iOS, Android, events, and commands working on the rebuilt ladder
- Update repo docs after the new ladder is validated

Branch Policy
Treat the repository as having two branch families:
- Historical branches: `step-0-scaffold` through `step-6-commands`
- Target branches: `rn85-step-0-scaffold` through `rn85-step-6-commands`

Rules:
- Do not rewrite or repurpose the historical `step-*` branches.
- Do not describe the historical `step-*` branches as the future canonical path for new work.
- Prefer work that advances or documents the `rn85-step-*` migration path.
- Do not change `main` merge policy casually. That decision belongs to the final validation work after the RN `0.85.1` ladder is accepted.

How To Scope Changes
When making repo-wide guidance changes, prefer stable instructions that can survive across multiple branches:
- Keep agent-facing docs branch-agnostic where possible.
- Avoid embedding branch-specific implementation snippets in repo-wide instruction files unless the detail is stable across the ladder.
- If a note only applies to one lecture step, keep it in that branch or step-specific documentation rather than in repo-wide guidance.
- If current implementation details are being revalidated as part of the RN `0.85.1` migration, describe them as validation targets rather than permanent truth.

Propagation Strategy
When the same doc change needs to land across multiple tutorial branches, use the same low-noise approach as the RN upgrade work:
1. Isolate the change into a doc-only commit with no unrelated code or generated-file churn.
2. Keep the patch limited to repo-wide files such as `AGENTS.MD` and `README.md` unless another doc is truly required.
3. Land the shared wording on the earliest compatible branch.
4. Cherry-pick or replay that same commit across descendant branches.
5. If a branch has a legitimate wording difference, keep the delta local to that branch instead of making the shared doc more complex.

RN `0.85.1` Migration Constraints
Agent work should stay aligned with the migration issues under `S5U-712`:
- Tooling and dependency alignment belong to the RN `0.85.1` step work, not to general doc-only commits.
- Jest should move to `@react-native/jest-preset` as part of the RN `0.85.1` JS/tooling step.
- iOS Fabric registration should be revalidated against `codegenConfig.ios.componentProvider` instead of assuming the current manual `thirdPartyFabricComponents()` path remains correct.
- iOS and Android command/event behavior must be validated on the rebuilt ladder, not assumed from the current `0.82.1` implementation.

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
