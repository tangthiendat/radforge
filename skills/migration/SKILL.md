---
name: migration
description: Use when the main job is moving from an old path to a new one with compatibility, cutover, rollback, or rollout concerns.
maturity: core
kind: operational
owner: radforge
lastReviewed: "2026-05-19"
compatibility: bootstrap routing and repo-local workflow contracts
---

# migration

## Purpose

Plan and structure migrations where the hard part is the transition boundary between current and target behavior, not just the implementation itself.

## When To Use

- the work replaces an old path with a new one
- compatibility, cutover timing, rollback, or staged removal matters
- the migration affects config, API shape, install behavior, workflow semantics, data shape, naming, or user-facing paths
- the implementation is not the only risk; the transition itself needs explicit handling

## When Not To Use

- the direction is still unresolved and needs `brainstorming`
- the main missing artifact is a durable design, which should go to `spec-writing`
- the work is just ordinary execution sequencing with no meaningful transition boundary, which belongs to `plan`
- the task is already clear enough for direct `implement` and has no real compatibility or cutover concern
- the main issue is active broken behavior that still needs `debug`

## Process

1. Define the migration goal in current-state to target-state terms.
2. Inspect the current path, the intended target path, and any repository guidance that defines compatibility or support expectations.
3. Identify the compatibility boundary explicitly: what must keep working, what can change immediately, and what can be removed later.
4. Record the cutover plan, rollback path, and validation plan before choosing the implementation path.
5. Call out one-way or destructive edges explicitly: data loss, deleted paths, unsupported downgrade, state rewrites, or user-facing breakage.
6. Pause for approval when the migration introduces approval-sensitive rollout, compatibility, deletion timing, irreversible changes, or shared workflow semantics.
7. Hand off to `spec-writing` when the target design or migration policy still needs a durable artifact before execution.
8. Hand off to `plan` when the migration path is clear but the remaining work is multi-step, resumable, or dependency-heavy.
9. Hand off to `implement` when the migration path is already clear and the remaining work is direct.
10. Hand off to `test` when broader migration validation is the primary remaining job.

## Migration Finalization Rule

- Use `spec-writing` when migration policy, compatibility promises, rollout behavior, or cutover reasoning should be preserved as a durable design artifact in `docs/specs/`.
- Use `plan` when the migration path is already decided but execution, sequencing, or cutover steps should be preserved as a durable plan in `docs/plans/`.
- Chat-only migration output is acceptable only when the transition is small, simple, low-risk, and not worth a durable artifact.

## Guardrails

- do not treat a normal code change as a migration when no real transition boundary exists
- do not delete the old path without naming the cutover and rollback implications
- do not assume rollback exists when the change is destructive or one-way
- do not hide compatibility assumptions or support windows
- do not hand off without approval when the migration is approval-sensitive
- do not stop after non-trivial migration work without naming approval status and next handoff

## Supporting Files

- use `templates/migration-template.md` when the migration summary is non-trivial
- read `references/migration-patterns.md` when you need stronger cutover, compatibility, or rollback framing
- read `references/example-migration.md` when the template alone is too abstract

## Output Contract

Use this structure:

```text
Migration Goal
Current State
Target State
Compatibility Boundary
Cutover Plan
Rollback Path
Validation Plan
Open Questions
Approval Status
Artifact Location
Next Handoff
```

Include in the sections above:

- what is changing now versus later
- whether the migration artifact is intentionally chat-only or should become `docs/specs/` or `docs/plans/`
- whether the migration is reversible, partially reversible, or one-way
- what evidence will show the transition is safe enough to proceed
- whether the next best handoff is `spec-writing`, `plan`, `implement`, or `test`

## Handoff Rules

- `migration` -> `spec-writing`
- `migration` -> `plan`
- `migration` -> `implement`
- `migration` -> `test`
- `migration` -> stop
