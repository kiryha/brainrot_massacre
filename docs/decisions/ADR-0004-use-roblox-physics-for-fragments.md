# ADR-0004: Use Roblox Physics for Fragments

**Status:** Accepted

## Context

Pre-fractured pieces still need responsive motion and ground collision at runtime.

## Decision

Let the server unanchor the imported fragments and apply mass-scaled linear and angular impulses using Roblox physics.

## Reason

This is interactive, compact, and easy to tune without shipping baked simulations.

## Consequences

Collision groups, simple collision fidelity, fragment budgets, cleanup, and repeatable Studio testing are required.

## Alternatives rejected

Baked Houdini simulations are less interactive; custom physics is unnecessary for the first milestone.

