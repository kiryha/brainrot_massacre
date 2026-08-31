# Technical Architecture

Rojo maps Git-controlled Luau into Roblox Studio:

- `src/client` -> `StarterPlayer/StarterPlayerScripts/Client`
- `src/server` -> `ServerScriptService/Server`
- `src/shared` -> `ReplicatedStorage/Shared`

For the first milestone, the client owns only the temporary UI and sends one request. The server validates that request, owns the single character state, swaps the asset, configures fragment physics, cleans up, and respawns.

Houdini and Roblox imports live under the external production-data root described in `README.md`. This repository stores code, relative asset metadata, and decisions, but no place files or production meshes.

See `docs/tasks/MVP-001-intact-to-fractured-button.md` for the first concrete data model and runtime sequence.

