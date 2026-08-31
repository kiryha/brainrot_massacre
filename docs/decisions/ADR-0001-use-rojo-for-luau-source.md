# ADR-0001: Use Rojo for Luau Source

**Status:** Accepted

## Context

Roblox Studio place files are binary production data, while gameplay logic needs reviewable source control.

## Decision

Keep Luau in `src/` and synchronize it with `default.project.json` through Rojo.

## Reason

Text source produces useful diffs, normal code review, and repeatable builds.

## Consequences

Studio is not the source of truth for mapped scripts. Place files stay outside Git, and developers need Rojo for sync/build work.

## Alternatives rejected

Editing scripts only inside Studio and committing place files would hide meaningful code history in binary changes.

