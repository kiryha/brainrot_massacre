# Content Pipeline

1. Build an original intact character in the external production-data directory.
2. In Houdini, create 10-20 clean, closed fragments with stylized inner surfaces.
3. Give the intact and fractured assemblies the same scale, orientation, and pivot.
4. Export `brainrot_basic_intact.fbx` and `brainrot_basic_fractured.fbx`.
5. Import both into Roblox Studio and verify their silhouettes overlap before writing asset IDs to `config/asset_manifest.json`.
6. Store Studio places and imported binaries outside Git; use Rojo for Luau only.

The approved import scale, axes, origin convention, asset IDs, and material bindings are intentionally unset in the placeholder manifest.

