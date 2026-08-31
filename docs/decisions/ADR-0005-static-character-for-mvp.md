# ADR-0005: Use a Static Character for the MVP

**Status:** Accepted

## Context

Replacing an animated rig requires matching every fracture piece to the live pose.

## Decision

Use one anchored character in a neutral pose for the MVP.

## Reason

It isolates scale, pivot, replacement, collision, and impulse behavior—the actual pipeline under test.

## Consequences

The first character has no rig animation or movement. Animated pose matching remains a separate final-game decision.

## Alternatives rejected

Ragdolls, bone-driven fragments, pose libraries, and forced hit-reaction poses introduce unrelated complexity.

