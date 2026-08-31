# ADR-0003: Use Houdini for Pre-fracture Only

**Status:** Accepted

## Context

The MVP needs art-directed fragments and interior surfaces, not arbitrary runtime cutting.

## Decision

Use Houdini offline to create a modest set of named rigid fragments and export them with the intact model.

## Reason

Offline preparation gives the artist control over topology, materials, normals, UVs, origin, and fragment count.

## Consequences

Each character needs an intact and a fractured asset. A new cut pattern requires a new export.

## Alternatives rejected

Runtime `EditableMesh` cutting, Alembic playback, geometry caches, and hundreds of simulated fragments add risk without proving the MVP question.

