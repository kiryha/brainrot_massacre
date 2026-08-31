# ADR-0002: Separate Git and Production Data

**Status:** Accepted

## Context

Houdini scenes, caches, mesh exports, and Roblox places are large binaries with different versioning needs from code.

## Decision

Keep code and small metadata in `OneDrive/dev/brainrot_massacre`; keep production binaries in `OneDrive/projects/brainrot_massacre`.

## Reason

The split keeps Git fast and makes ownership of generated and source assets clear.

## Consequences

Manifests use paths relative to the production-data root. A fresh code checkout does not include art assets or Studio places.

## Alternatives rejected

Committing all binaries to normal Git would inflate history; hard-coded absolute links would make the project machine-specific.

