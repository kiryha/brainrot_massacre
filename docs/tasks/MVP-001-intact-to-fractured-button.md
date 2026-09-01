# MVP-001: Intact-to-Fractured Button Test

**Status:** Asset conventions approved; FBX export and Studio import pending

## Objective

Import one intact original character and its Houdini-pre-fractured counterpart. When a temporary on-screen button is pressed, replace the intact model at the same pivot, release the fragments into Roblox physics, clean them up, and respawn the intact model.

This is the first end-to-end proof of the project. Optimize for a reliable, inspectable vertical slice, not reusable final-game features.

## Context

The art is authored outside Git and imported into the Roblox Studio place. Luau is authored in this repository and synchronized through Rojo. The static neutral pose deliberately avoids animated pose matching.

Relevant documents:

- `README.md`
- `docs/CONTENT_PIPELINE.md`
- `docs/decisions/ADR-0001-use-rojo-for-luau-source.md`
- `docs/decisions/ADR-0002-separate-git-and-production-data.md`
- `docs/decisions/ADR-0003-use-houdini-for-prefracture-only.md`
- `docs/decisions/ADR-0004-use-roblox-physics-for-fragments.md`
- `docs/decisions/ADR-0005-static-character-for-mvp.md`
- `docs/decisions/ADR-0006-stylized-policy-compliant-destruction.md`
- `docs/decisions/ADR-0007-production-paths-and-version-numbers.md`

## Approval gates and inputs

The production paths and spatial contract are approved. Before implementation can be fully verified, the artist must provide or approve:

- An original or appropriately licensed, policy-safe `CappuccinoAssassino_Intact` model.
- A matching `CappuccinoAssassino_Fractured` model with roughly 10-20 useful pieces.
- The stylized outer and inner materials.

Record those values and the final Roblox asset IDs in `config/asset_manifest.json`. Keep paths relative to the external production-data root.

## Asset contract

- Houdini scene: `prod/3D/scenes/characters/cappuccino_assassino/cappuccino_assassino.hip`
- Intact FBX: `prod/3D/caches/characters/cappuccino_assassino/01/cappuccino_assassino_intact.fbx`
- Fractured FBX: `prod/3D/caches/characters/cappuccino_assassino/01/cappuccino_assassino_fractured.fbx`
- Studio place: `roblox/places/shoot_a_brainrot_mvp_01.rbxl`
- Source unit and height: meters; 1.68 m, producing 6 Roblox studs
- Axes: `+Y` up, `+X` character-right, `-Z` character-forward
- Assembly pivot: ground-center at `Y = 0`, identity orientation, identical for both versions
- Runtime/import scale: `1.0`; fix mismatches in the source/import settings rather than adding an offset
- Version spelling: numeric only, with two digits for current scene/cache revisions and no `v` prefix

Keep individual fragment pivots near their centers of volume while preserving their transforms relative to the shared assembly pivot.

## Studio asset layout

Import both FBX files into the external Studio place and normalize them to this structure:

```text
ServerStorage
└── CharacterAssets
    ├── CappuccinoAssassino_Intact       (Model; all BaseParts anchored)
    └── CappuccinoAssassino_Fractured    (Model; all BaseParts anchored)
        ├── Fragment_...
        └── Fragment_...

Workspace
├── Ground                         (anchored)
├── SpawnLocation
└── BrainrotCharacters             (created by the server)
```

The intact asset must use a `Model` wrapper even if it contains only one `MeshPart`. The fractured asset may contain folders, but every physical fragment must be a `BasePart` descendant with a stable `Fragment_*` name. Do not weld or constrain separate fragments together.

Use simple imported collision fidelity, preferably hull or box where the silhouette permits. Templates stay anchored in `ServerStorage`; only runtime clones enter `Workspace`.

## Asset overlap check

Before gameplay code is tested:

1. Clone both templates into `Workspace`.
2. Apply the same `Model:PivotTo()` transform to both.
3. Toggle their visibility or use contrasting temporary colors.
4. Inspect front, side, top, and perspective views at close range.
5. Confirm feet, silhouette, scale, orientation, and interior seams do not jump.
6. Confirm the fractured model pivot does not depend on any single fragment being present.
7. Delete the temporary clones and keep the approved templates in `ServerStorage`.

If the two models do not overlap, fix the Houdini/export/import origin rather than adding a runtime correction offset.

## Source layout

Implement the slice with these small files:

```text
src/client/DestructionButton.client.lua
src/server/CharacterSpawner.lua
src/server/DestructionService.server.lua
src/shared/DestructionConfig.lua
```

- `DestructionConfig.lua`: names, cleanup/respawn timing, impulse-speed ranges, angular strength, and collision-group names.
- `CharacterSpawner.lua`: locate the templates, clone an anchored intact model at a supplied pivot, and own the runtime folder.
- `DestructionService.server.lua`: create remotes, validate requests, own state, replace the model, configure physics, clean up, and ask the spawner to respawn.
- `DestructionButton.client.lua`: create a clearly temporary `ScreenGui` button, send a request with no client-selected target or physics values, and follow server state when enabling the button.

The server may create two runtime remotes under `ReplicatedStorage/Remotes`: `RequestDestruction` for client requests and `DestructionState` for ready/busy updates. Do not place imported assets in Rojo-managed paths.

## Server requirements

### Request validation

- Accept requests only from a connected player while the single target state is `Ready`.
- Apply a small per-player request rate limit even though the operation is also state-guarded.
- Ignore client-provided model references, pivots, impulses, delays, or asset names.
- Change state before cloning so simultaneous requests cannot both succeed.
- If template validation or cloning fails, leave/restore the intact character, return to `Ready`, and warn with a useful message.

### Atomic replacement sequence

For one accepted request:

1. Capture the current intact model pivot.
2. Clone `CappuccinoAssassino_Fractured` from `ServerStorage/CharacterAssets`.
3. Verify that the clone contains the expected number of `BasePart` fragments.
4. Keep every fragment anchored while assigning collision properties.
5. Apply the captured pivot with `Model:PivotTo()`.
6. Parent the aligned fractured clone to the runtime folder.
7. Remove the intact runtime model only after the fractured clone is valid and aligned.
8. Unanchor the fragments and apply motion.

No intact and fractured model should be visible at different transforms during the same rendered frame.

### Fragment physics

Register `DestructionFragments` and `Players` collision groups. Configure the pairs so fragments collide with `Default` ground/world geometry, but not with other fragments or player characters. Assign current and newly added player-character `BasePart` descendants to `Players`.

For each fragment:

- Set its collision group before unanchoring.
- Keep world collision enabled.
- Unanchor it and prefer server network ownership for this small MVP.
- Compute an outward direction from the fractured model center to the fragment center; use a randomized horizontal fallback for a central fragment.
- Add configurable upward and small random lateral components.
- Call `ApplyImpulse()` with the velocity-like impulse scaled by `AssemblyMass`, so heavy and light pieces launch at comparable speeds.
- Call `ApplyAngularImpulse()` with a randomized axis and configurable, mass-scaled strength.

Use `Random.new()` per destruction event. Do not depend on a fixed production seed, but allow a temporary seed during debugging when a result must be reproduced.

### Cleanup and respawn

- Keep one reference/generation token for the active destruction so delayed cleanup cannot affect a newer spawn.
- After the configured fragment lifetime, destroy the fractured runtime model.
- Respawn a fresh anchored intact clone at the captured pivot.
- Change state to `Ready` only after the intact clone exists, then notify all clients.
- Destroy player-specific rate-limit entries when players leave.

## Client requirements

- Generate one temporary button in code; no polished UI asset is required.
- Label the busy state clearly and disable activation as soon as the local request is sent.
- Treat `DestructionState` from the server as authoritative for re-enabling.
- Do not predict the swap, clone fragments, or apply physics locally.
- Keep keyboard/gamepad/mobile polish outside this task; normal GUI activation is sufficient.

## Acceptance criteria

- Rojo builds the project and synchronizes all four Luau files into the intended services.
- The approved intact and fractured templates exist under `ServerStorage/CharacterAssets` and the manifest contains their verified metadata.
- Starting a server spawns exactly one anchored intact character near the player.
- One button activation causes exactly one server-authoritative swap.
- The fractured silhouette appears at the same position, rotation, and scale as the intact silhouette.
- Approximately 10-20 pieces receive visible outward, upward, and angular motion.
- Pieces collide with the ground but not with one another or player characters.
- The player is not damaged, trapped, or physically launched by fragments.
- Repeated clicks and two near-simultaneous players do not create duplicate fracture models.
- Fragments are removed, the intact model respawns at the original pivot, and the button becomes ready again.
- The complete loop succeeds at least five consecutive times in Studio server/client mode.
- Roblox Output contains no critical errors or repeated warnings.
- `docs/CURRENT_STATE.md` records the build and Studio test results honestly.

## Explicit non-goals

No weapons, hit detection, health, damage, animation, ragdoll, AI, scoring, particles, sound, camera shake, arbitrary cutting, multiple characters, pooling, or production UI.

## Files likely to change

- `src/client/DestructionButton.client.lua`
- `src/server/CharacterSpawner.lua`
- `src/server/DestructionService.server.lua`
- `src/shared/DestructionConfig.lua`
- `config/asset_manifest.json`
- `docs/CURRENT_STATE.md`
- This task brief's status and handoff notes

The external Studio place and imported assets also change, but remain outside Git.

## Validation steps

1. Parse `default.project.json` and both asset-manifest JSON files.
2. Run `rojo build -o build/brainrot_massacre.rbxlx`.
3. Run available Luau formatting/static checks and `git diff --check`.
4. Complete the asset overlap check in Studio.
5. Test with Studio's server/client mode, including rapid repeat input and two clients.
6. Run five full destroy-cleanup-respawn cycles while watching Explorer, physics behavior, and Output.
7. Record exact results and any unresolved defect in `docs/CURRENT_STATE.md`.

## Handoff notes

Scaffolding intentionally contains no gameplay Luau. Begin with the HIP and cache paths in the asset contract, then validate the real hierarchy and approved pivot/axis values in `shoot_a_brainrot_mvp_01.rbxl`; code cannot compensate reliably for a mismatched cache. If Rojo is unavailable locally, install/configure it as a separate tooling step and do not mark the build verified until the command succeeds.
