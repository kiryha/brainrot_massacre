# Brainrot Massacre

## Project Summary

Brainrot Massacre is the internal production name for a Roblox destruction sandbox created as a father-and-son project. Players will see the public title **Shoot a Brainrot**.

I am the father and I am 3d and VFX expert in the animation and film industry. Currently working as Software Engineer. Has no expirience with Roblox but comfortable with understanding general Computer Graphics pipelines and tools like Maya, Max, Houdiny, Unreal Engine, Nuke, Photoshop etc. I will need assistance with Roblox onboarding keeping in mind strong CGI background.

The central feature is satisfying, stylized character destruction. Brainrot characters do not attack the player. They can remain static in the MVP and may receive simple animations in the final game.

The project will be developed in two stages:

1. MVP — prove the Houdini-to-Roblox destruction pipeline.
2. Final Game — turn the successful destruction prototype into a playable Roblox experience.

The immediate priority is the MVP. Do not design or implement final-game systems until the MVP destruction test works reliably.

---

## Workspace Layout

The project uses two separate directories inside OneDrive.

### GitHub development repository

Path:

    OneDrive/dev/brainrot_massacre/

This directory is the Git repository and the primary workspace for Codex.

It contains:

- Project documentation
- `AGENTS.md`
- Luau source code
- Rojo configuration
- Tests
- Development tools and scripts
- Asset manifests
- Configuration files
- Small reference files suitable for Git
- GitHub workflows

Proposed structure:

    OneDrive/dev/brainrot_massacre/
    ├── README.md
    ├── AGENTS.md
    ├── .gitignore
    ├── default.project.json
    ├── src/
    │   ├── client/
    │   ├── server/
    │   └── shared/
    ├── tests/
    ├── tools/
    ├── config/
    │   └── asset_manifest.json
    └── docs/
        ├── PRODUCT_VISION.md
        ├── GAME_DESIGN.md
        ├── TECHNICAL_ARCHITECTURE.md
        ├── CONTENT_PIPELINE.md
        ├── MVP_PLAN.md
        ├── FINAL_GAME_PLAN.md
        ├── CURRENT_STATE.md
        ├── ROADMAP.md
        ├── decisions/
        └── tasks/

### Production project data

Path:

    OneDrive/projects/brainrot_massacre/

This directory contains production files and large binary assets that should not normally be committed to GitHub.

Current structure for the first character:

    OneDrive/projects/brainrot_massacre/
    ├── prod/
    │   └── 3D/
    │       ├── scenes/
    │       │   └── characters/
    │       │       └── cappuccino_assassino/
    │       │           └── cappuccino_assassino.hip
    │       └── caches/
    │           └── characters/
    │               └── cappuccino_assassino/
    │                   └── 01/
    │                       ├── cappuccino_assassino_intact.fbx
    │                       └── cappuccino_assassino_fractured.fbx
    ├── roblox/
    │   ├── places/
    │   │   └── shoot_a_brainrot_mvp_01.rbxl
    │   ├── imported_assets/
    │   └── local_tests/
    ├── models/
    ├── textures/
    ├── audio/
    ├── references/
    └── temporary/

Expected contents include:

- Houdini `.hip` files
- Houdini caches
- FBX and GLTF cache files
- Roblox Studio place files
- Imported Roblox assets
- Textures
- Audio
- Large reference files
- Temporary generated content

Version numbers do not use a `v` prefix. Choose padding from the expected number of revisions: one digit for rare milestone labels such as `mvp_1`, two digits for scene and character-cache revisions such as `01`, and more digits only where the expected count requires them.

The Git repository must not depend on hard-coded absolute OneDrive paths. External asset locations should be configurable locally.

---

## Source-Control Strategy

The GitHub repository must contain the Luau source code, not only documentation.

Roblox Studio place files are binary production data and are stored in:

    OneDrive/projects/brainrot_massacre/roblox/places/

Rojo should synchronize Luau source from:

    OneDrive/dev/brainrot_massacre/src/

into Roblox Studio.

The Git repository is the source of truth for:

- Game logic
- Architecture
- Configuration
- Documentation
- Asset identifiers
- Asset naming conventions
- Tests

The production-data directory is the source of truth for:

- Houdini scenes
- Roblox place files
- Mesh source files
- Exported meshes
- Textures and audio

---

# Stage 1: MVP

## MVP Objective

Prove the complete destruction pipeline with the smallest possible implementation.

The MVP does not need a shotgun, weapon system, character AI, animation, scoring, progression, multiple levels, or polished user interface.

The player presses a temporary button and a static character breaks into physical pieces.

The MVP must answer one question:

> Can a Houdini-prepared fractured character be imported into Roblox, replaced correctly at runtime, and destroyed convincingly using Roblox physics?

---

## MVP Scene

The Roblox scene contains:

- Default Roblox player character
- Spawn location
- Flat ground plane
- One static Brainrot character
- One temporary destruction button
- Basic lighting
- Optional reset button

The player must be able to:

1. Join the experience.
2. Walk around the character.
3. Press the temporary destruction button.
4. Watch the intact character become fractured pieces.
5. Watch the pieces receive impulses and fall onto the ground.
6. Reset or wait for the character to respawn.
7. Repeat the destruction.

---

## MVP Character

The MVP character should be static and posed in a neutral position.

Do not add skeletal animation during the first implementation. Replacing an animated character with a fractured model introduces pose-matching problems that are outside the MVP scope.

Create two asset versions:

    CappuccinoAssassino_Intact
    CappuccinoAssassino_Fractured

Both versions must:

- Use the same scale.
- Use the same orientation.
- Use the same assembly origin.
- Use compatible model pivots.
- Occupy the same location before destruction.
- Follow consistent naming conventions.

### Intact version

`CappuccinoAssassino_Intact` may be:

- One MeshPart, or
- A simple Model containing several MeshParts.

It should remain anchored and static.

### Fractured version

`CappuccinoAssassino_Fractured` should be a Model containing approximately 10–20 separate MeshParts.

Example:

    CappuccinoAssassino_Fractured
    ├── Fragment_Head_001
    ├── Fragment_Head_002
    ├── Fragment_Torso_001
    ├── Fragment_Torso_002
    ├── Fragment_Torso_003
    ├── Fragment_LeftArm_001
    ├── Fragment_LeftArm_002
    ├── Fragment_RightArm_001
    ├── Fragment_RightArm_002
    ├── Fragment_LeftLeg_001
    ├── Fragment_RightLeg_001
    └── Fragment_Core_001

The fractured template should initially be stored outside the active Workspace, preferably in `ServerStorage`.

---

## Houdini’s MVP Role

Houdini is used for offline asset preparation.

Houdini should:

- Import or contain the intact character.
- Create controlled fracture pieces.
- Generate closed interior surfaces.
- Create clean UVs and normals.
- Assign outer and inner material groups.
- Remove tiny and invalid fragments.
- Reduce unnecessary geometry.
- Create consistent fragment names.
- Preserve the character’s assembly origin.
- Export the intact and fractured versions.

Houdini should not:

- Produce a geometry-cache animation for Roblox.
- Export an Alembic destruction cache.
- Determine the final runtime movement.
- Generate hundreds of fragments.
- Simulate every destruction in DOPs for the MVP.

Roblox physics will move the prepared fragments.

Expected FBX cache files:

    prod/3D/caches/characters/cappuccino_assassino/01/cappuccino_assassino_intact.fbx
    prod/3D/caches/characters/cappuccino_assassino/01/cappuccino_assassino_fractured.fbx

FBX is the preferred initial format. GLTF can be evaluated if it preserves the required hierarchy and materials more reliably.

---

## Stylized Destruction and Roblox Policy

The game must remain publishable and accessible to a child account.

The adult production account does not override Roblox content restrictions.

The destruction must be clearly fictional and stylized. Acceptable interior concepts include:

- Colored gel
- Foam
- Candy-like filling
- Crystals
- Glowing material
- Mechanical components
- Springs
- Plastic internal structures
- Unrealistic colored particles

Do not use:

- Realistic blood
- Recognizable organs
- Realistic exposed muscles
- Realistic intestines
- Graphic wounds
- Anatomically realistic dismemberment
- Human or animal gore

The target should be a Minimal or Mild Roblox content classification.

**Brainrot Massacre** is the internal production name. **Shoot a Brainrot** is the approved public title shown to players.

All characters should be original designs. Do not copy protected character models, music, voices, textures, or branding from existing Brainrot media.

---

## MVP Runtime Destruction

When the temporary button is pressed:

1. Validate the request on the server.
2. Reject the request if the character is already destroyed.
3. Record the intact character’s pivot.
4. Clone the fractured model from `ServerStorage`.
5. Align the fractured model to the intact model’s pivot.
6. Hide or destroy the intact model.
7. Place the fractured model in `Workspace`.
8. Unanchor all fracture pieces.
9. Apply outward, upward, and randomized impulses.
10. Apply randomized angular impulses.
11. Allow fragments to collide with the ground.
12. Prevent fragments from colliding with one another.
13. Preferably prevent fragments from colliding with players.
14. Remove the fragments after a configurable delay.
15. Respawn the intact character.

For the MVP, destruction can be entirely server-side because there is only one character and a small number of fragments.

---

## MVP Roblox Systems

Keep the initial code small, but separate responsibilities.

Suggested modules:

    src/server/
    ├── DestructionService.server.lua
    └── CharacterSpawner.server.lua

    src/shared/
    └── DestructionConfig.lua

    src/client/
    └── DestructionButton.client.lua

Possible responsibilities:

### `DestructionButton.client.lua`

- Creates or controls the temporary button.
- Sends a destruction request to the server.
- Disables repeated activation until reset.

### `DestructionService.server.lua`

- Validates requests.
- Locates the target character.
- Replaces the intact model.
- Aligns the fractured model.
- Configures fragment physics.
- Applies impulses.
- Cleans up fragments.

### `CharacterSpawner.server.lua`

- Spawns the intact character.
- Tracks whether the character is intact or destroyed.
- Respawns it after destruction.

### `DestructionConfig.lua`

Contains configurable values such as:

- Fragment lifetime
- Respawn delay
- Outward impulse
- Upward impulse
- Angular impulse
- Random seed behavior
- Character asset names
- Collision-group names

---

## MVP Collision Rules

Create a dedicated collision group for destruction fragments.

Required behavior:

- Fragments collide with the ground.
- Fragments do not collide with one another.
- Fragments do not damage the player.
- Fragments preferably do not physically block the player.
- Destroyed fragments cannot be destroyed again.
- Fragment collision fidelity should use simple settings such as Box or Hull whenever visually acceptable.

Avoid precise collision geometry unless a specific fragment requires it.

---

## MVP Asset Manifest

Create a small manifest in:

    config/asset_manifest.json

The manifest should eventually record Roblox asset identifiers, but it may initially use placeholder values.

Conceptual entries:

- Character identifier
- Intact asset name
- Fractured asset name
- Source Houdini file
- Exported FBX path relative to the production-data directory
- Roblox asset identifier
- Numeric version without a `v` prefix
- Import scale
- Forward axis
- Up axis
- Assembly-origin convention
- Material bindings

Do not store absolute Windows paths in the committed manifest.

---

## MVP Acceptance Criteria

The MVP is complete when all of the following are true:

- The project can be opened in Roblox Studio.
- Rojo synchronizes the Git-controlled Luau source.
- The player spawns near the test character.
- The player can walk around the scene.
- The character is initially intact and static.
- Pressing the temporary button destroys the character exactly once.
- The fractured model appears without a visible position, rotation, or scale jump.
- Fragments receive visible linear and angular motion.
- Fragments fall and collide with the ground.
- Fragments do not violently collide with one another.
- Fragments do not damage or trap the player.
- Fragments are cleaned up.
- The intact character can respawn.
- The sequence can be repeated.
- The test works in Roblox Studio’s server/client test mode.
- No disallowed graphic content is present.
- The experience can be published for private testing.
- No critical errors appear in the Roblox output log.

---

## MVP Non-Goals

Do not implement these features during the MVP:

- Shotgun
- Weapon framework
- Damage or health
- Raycast shooting
- Character AI
- Character movement
- Character animation
- Ragdoll
- Multiple characters
- Multiple destruction states
- Arbitrary runtime mesh cutting
- Runtime `EditableMesh` fracture
- Houdini geometry-cache playback
- Scoring
- Progression
- Inventory
- Currency
- Multiple environments
- Multiplayer optimization
- Mobile-specific interface polish
- Monetization

These belong to the Final Game stage only after the MVP is approved.

---

# Stage 2: Final Game

## Final Game Objective

Convert the successful destruction prototype into a small Roblox destruction sandbox.

The Final Game remains focused on character destruction. It is not intended to become a conventional combat game with attacking enemies, a large campaign, or many levels.

Brainrots do not attack or damage players.

---

## Final Game Core Loop

The intended loop is:

    Spawn
    → Select a weapon
    → Approach a Brainrot
    → Aim and attack
    → Trigger a weapon-specific destruction response
    → Receive score or visual feedback
    → Brainrot respawns
    → Repeat

---

## Potential Final Game Features

Features may include:

- Several original Brainrot characters
- Several small environments
- Static, idle, walk-in-place, roaming, or fleeing characters
- Shotgun
- Pistol
- Hammer
- Axe
- Sword
- Other stylized weapons
- Weapon-specific impulses
- Character hit reactions
- Multiple destruction zones
- Different fracture variants
- Muzzle flashes
- Impact particles
- Stylized fluids
- Sound effects
- Camera shake
- Scoring
- Combos
- Character respawning
- Weapon-selection interface
- Mobile, gamepad, and desktop input
- Multiplayer support
- Client-side cosmetic debris
- Performance budgets and object pooling

These are candidate features, not current commitments.

---

## Final Game Technical Direction

The final architecture should extend the MVP instead of replacing it.

Potential systems:

    WeaponService
    HitDetectionService
    DestructionService
    CharacterService
    CharacterRegistry
    EffectsService
    RespawnService
    ScoreService

The server should remain authoritative for:

- Weapon ownership
- Fire rate
- Valid shots
- Character state
- Destruction state
- Score
- Respawning

Clients may eventually handle:

- Cosmetic particles
- Small non-colliding fragments
- Camera shake
- Local sound layering
- Other temporary visual effects

---

## Animation Considerations

Animated characters create an additional problem: the fractured model must match the character’s pose at the moment of destruction.

This problem is intentionally excluded from the MVP.

Possible Final Game solutions include:

1. Stop the animation and move the character into a known destruction pose before replacement.
2. Maintain several fractured variants for predefined poses.
3. Associate rigid fragments with corresponding character bones and calculate their transforms at destruction time.
4. Use a short hit-reaction animation that ends in the pose used by the fractured asset.

The simplest acceptable solution should be selected only after the static-character MVP succeeds.

---

## Destruction Principles

The project should preserve these principles:

- Destruction is artist-directed.
- Houdini creates fracture geometry and interior surfaces.
- Roblox supplies runtime physics and interaction.
- Runtime arbitrary cutting is not a priority.
- A small number of excellent fragments is preferable to hundreds of generic shards.
- Destruction should be exaggerated and satisfying.
- Visual content must remain fictional and Roblox-compliant.
- Systems should support adding characters and weapons through configuration rather than duplicated code.

---

# Documentation and Codex Workflow

## `AGENTS.md`

Create a concise repository-level `AGENTS.md` containing:

- Repository layout
- External production-data layout
- Required documents to read
- Luau naming and formatting conventions
- Rojo workflow
- Test commands
- Client/server authority rules
- Roblox policy constraints
- Files and directories agents must not modify
- Definition of done
- Documentation update requirements

Do not copy the entire README into `AGENTS.md`.

## Project State

Use `docs/CURRENT_STATE.md` as the short persistent project checkpoint.

It should contain:

- Current stage
- Current milestone
- Completed work
- Work in progress
- Known blockers
- Next three tasks
- Last verified build
- Last successful Roblox Studio test

Keep it concise and update it after meaningful progress.

## Architecture Decisions

Store important decisions in:

    docs/decisions/

Initial decisions should include:

    ADR-0001-use-rojo-for-luau-source.md
    ADR-0002-separate-git-and-production-data.md
    ADR-0003-use-houdini-for-prefracture-only.md
    ADR-0004-use-roblox-physics-for-fragments.md
    ADR-0005-static-character-for-mvp.md
    ADR-0006-stylized-policy-compliant-destruction.md
    ADR-0007-production-paths-and-version-numbers.md

Each decision should include:

- Context
- Decision
- Reason
- Consequences
- Alternatives rejected

## Task Briefs

Store bounded implementation tasks in:

    docs/tasks/

Each task should define:

- Objective
- Context
- Relevant documents
- Requirements
- Acceptance criteria
- Files likely to change
- Explicit non-goals
- Validation steps
- Handoff notes
- Status

Agents should not treat chat history as the project’s permanent memory. Important decisions and verified state must be recorded in repository documentation.

---

# Initial Codex Assignment

Codex should begin with project scaffolding and documentation only.

Initial tasks:

1. Inspect the repository.
2. Preserve this README as the high-level project definition.
3. Create the proposed directory structure.
4. Create a concise `AGENTS.md`.
5. Create the initial documentation files.
6. Create the initial ADR files.
7. Create `docs/CURRENT_STATE.md`.
8. Create `docs/MVP_PLAN.md` with ordered implementation tasks.
9. Create placeholder Rojo and source directories.
10. Create an appropriate `.gitignore`.
11. Create a placeholder asset manifest schema.
12. Document any assumptions requiring user approval.

Do not implement gameplay logic during the initial scaffolding task.

After scaffolding, the first implementation milestone should be:

> Import an intact character and a pre-fractured version, then replace and physically break the character when a temporary button is pressed.
