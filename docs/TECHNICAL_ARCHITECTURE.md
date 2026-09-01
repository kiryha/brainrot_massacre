# Technical Architecture

Rojo maps Git-controlled Luau into Roblox Studio:

- `src/client` -> `StarterPlayer/StarterPlayerScripts/Client`
- `src/server` -> `ServerScriptService/Server`
- `src/shared` -> `ReplicatedStorage/Shared`

For the first milestone, the client owns only the temporary UI and sends one request. The server validates that request, owns the single character state, swaps the asset, configures fragment physics, cleans up, and respawns.

Houdini scenes and caches live under `OneDrive/projects/brainrot_massacre/prod/3D`; Roblox places and imported-asset snapshots live under the sibling `roblox` directory. This repository stores code, paths relative to `OneDrive/projects/brainrot_massacre`, and decisions, but no place files or production meshes.

See `docs/tasks/MVP-001-intact-to-fractured-button.md` for the first concrete data model and runtime sequence.
