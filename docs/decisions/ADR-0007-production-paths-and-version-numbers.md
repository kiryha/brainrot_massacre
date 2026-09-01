# ADR-0007: Production Paths and Version Numbers

**Status:** Accepted

## Context

The existing Houdini pipeline has established scene/cache locations and different asset types have different expected revision counts.

## Decision

Use `prod/3D/scenes/characters/<character>/` for character HIP files and `prod/3D/caches/characters/<character>/<revision>/` for FBXs, relative to the production-data root. Use numeric versions without a `v` prefix. Choose padding by expected count: one digit for rare milestones, two for scene/cache revisions, and more only when needed.

The first files are `cappuccino_assassino/cappuccino_assassino.hip`, cache revision `01`, and `roblox/places/shoot_a_brainrot_mvp_01.rbxl`.

## Reason

This matches the established production pipeline while keeping names compact, sortable, and proportional to their likely revision counts.

## Consequences

Manifests and docs use the same relative paths and numeric spelling. Prefixed asset versions are invalid; task identifiers such as `MVP-001` remain separate sequence IDs, not asset versions.

## Alternatives rejected

A universal prefix-and-three-digit convention adds unnecessary characters and padding; a separate export directory would duplicate the cache layout.
