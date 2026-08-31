# Repository Guidance

## Read first

Read `README.md`, `docs/CURRENT_STATE.md`, and the relevant file in `docs/tasks/`. Read linked ADRs before changing an established decision.

## Layout

- `src/client`, `src/server`, `src/shared`: Rojo-managed Luau.
- `config`: small manifests and schemas; never commit absolute machine paths.
- `tests`, `tools`: automated checks and development utilities.
- `docs`: durable plans, decisions, task briefs, and current state.
- `OneDrive/projects/brainrot_massacre`: external production data (Houdini, exports, Studio places); it is not part of this repository.

## Luau and Rojo

- Use `PascalCase` for modules/services, `camelCase` for locals/functions, and `UPPER_SNAKE_CASE` only for constants.
- Prefer typed Luau at public module boundaries. Keep client, server, and shared responsibilities separate.
- The server owns character state, request validation, destruction, physics setup, cleanup, and respawn. Clients request actions and render temporary UI; never trust client state.
- Sync with `rojo serve default.project.json`. Validate a build with `rojo build -o build/brainrot_massacre.rbxlx` when Rojo is installed.

## Validation

- Run `git diff --check` and parse changed JSON before handoff.
- Run available automated tests for touched behavior.
- Gameplay changes require a Roblox Studio server/client test and a check for errors in Output. Record the result in `docs/CURRENT_STATE.md`; do not claim an unperformed Studio test.

## Safety and scope

- Keep destruction fictional and stylized: no blood, organs, realistic wounds, or copyrighted Brainrot assets.
- Do not add final-game systems while the MVP fracture test is incomplete.
- Do not modify external production data, generated Rojo builds, Roblox place files, or imported binary assets unless the user explicitly scopes that work.
- Preserve `README.md` as the high-level project definition. Keep supporting docs concise and update only the durable facts affected by the work.

## Definition of done

Code and configuration are source-controlled, responsibilities follow the authority rules, relevant checks pass, Studio behavior is verified when applicable, and `docs/CURRENT_STATE.md` plus the active task brief reflect the verified state and next step.
