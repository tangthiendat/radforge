# Spec Writing Patterns

Use this file when the main `SKILL.md` is not enough and you need a stronger structure for design artifacts.

## Spec Trigger Pattern

Prefer `spec-writing` after `brainstorming` when:

- the direction is mostly chosen but needs durable written design
- approval depends on concrete design details rather than a short recommendation
- the work crosses components, workflows, or repository boundaries
- later `plan` or `implement` work would otherwise lose important design reasoning

Do not use it when the main remaining need is task sequencing; that is `plan`.

Default to a durable spec in `docs/specs/`.
Use chat-only output only when the scope is small, simple, and not worth a spec file.

## Problem Framing Pattern

Start with repository-specific facts, not generic architecture prose.

Capture:

- what is changing
- what boundary is affected
- why the current state is not enough
- why a durable spec is the right artifact now

## Design Decision Pattern

When recording a meaningful decision, use this shape:

```text
Decision: <what is being chosen>
Why: <main reason>
Tradeoff: <main cost or limitation>
```

## Alternatives Pattern

Only include alternatives when they preserve useful reasoning for approval or future review.

Use this shape:

```text
Option: <name>
Why not chosen: <short reason>
```

## Approval Gate Pattern

Call for approval when design choices affect rollout, compatibility, migration, or workflow semantics.

Example:

```text
This design is ready for approval because the direction is now concrete enough to preserve the key tradeoffs, risks, and boundaries before planning starts.
```

## Output Checklist

Before handing off, confirm that you have:

- a clear problem statement
- explicit goals and non-goals
- real constraints
- a concrete proposed design
- alternatives only where they add value
- stated risks and open questions
- approval status
- a clear next handoff
