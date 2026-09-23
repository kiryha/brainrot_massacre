# Content Pipeline

All paths below are relative to `OneDrive/projects/brainrot_massacre`:

- Houdini scene: `prod/3D/scenes/characters/tralalero_tralala/tralalero_tralala_004.hiplc`
- FBX cache revision: `prod/3D/caches/characters/tralalero_tralala/FBX/`, files suffixed `02`
- Studio place: `roblox/places/shoot_a_brainrot_mvp_01.rbxl`
- Optional Studio model snapshots: `roblox/imported_assets/tralalero_tralala/02/`

The Houdini scene uses meters. Tralalero Tralala targets 1.68 m, or 6 Roblox studs. Use `+Y` up, `+X` character-right, and `-Z` character-forward. Put the shared intact/fractured assembly pivot at ground-center (`Y = 0`) with identity orientation; keep individual fragment pivots near their centers of volume. Import at scale `1.0` with no corrective per-version transform.

Version numbers are numeric and never use a `v` prefix. Padding reflects the expected count: use one digit for rare milestone labels (`mvp_1`), two digits for scene/cache revisions (`01`), and additional digits only for collections expected to exceed those ranges.

Workflow:

1. Build the original intact character and 10-20 clean, closed, stylized fragments in Houdini.
2. Write `tralalero_tralala_intact_02.fbx` and `tralalero_tralala_fractured_02.fbx` to cache revision `02`.
3. Import both into Studio with identical settings and verify exact silhouette/pivot overlap.
4. Store anchored templates in `ServerStorage/CharacterAssets`; optionally save configured `.rbxm` snapshots under `roblox/imported_assets`.
5. Record approved material bindings and Roblox asset IDs in `config/asset_manifest.json`. Keep Luau in Git through Rojo and all production binaries outside Git.
