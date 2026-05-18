---
name: implement
description: Use when the task is clear enough to execute. Make the smallest correct change, preserve existing patterns, and hand off to testing when needed.
maturity: core
owner: radforge
lastReviewed: "2026-05-18"
compatibility: bootstrap-only installed use and repo-local workflow contracts
---

# implement

## Purpose

Execute an approved change with minimal, correct edits while keeping scope and rollback boundaries visible.

## When To Use

- the task is already clear
- a plan exists and execution should start
- the user asked for direct implementation

## When Not To Use

- the work is still ambiguous and needs `brainstorming`
- the main problem is a failure that has not been reproduced and needs `debug`

## Process

1. Confirm the direction is clear enough to execute.
2. Inspect the relevant files before editing.
3. Lock the smallest execution boundary that can solve the problem before editing.
4. Follow existing project patterns unless there is a concrete reason not to.
5. Define the first execution checkpoint explicitly: target files, intended outcome, and cheapest proving check.
6. Start with that checkpoint rather than changing every related file at once.
7. Make the smallest correct change for the checkpoint and preserve unrelated user changes.
8. After each checkpoint, compare the current scope against the approved direction. If new files, dependencies, or behavior surfaces appear, stop widening silently and hand off as needed.
9. Run the smallest meaningful validation when it is obvious and cheap.
10. `implement` may stop with inline validation only when the work stayed inside one checkpoint, one coherent boundary, and Tier 1 `smoke` evidence is enough to support the claim.
11. Hand off to `test` when Tier 2 or Tier 3 evidence is needed, when regression confidence matters, or when the change affects install, update, uninstall, config, or shared workflow semantics.
12. Check adjacent owned artifacts when the change affects workflow or shared behavior: docs, uninstall or rollback paths, state or output shape, and nearby instructions that define the same surface.
13. Record the rollback or escape note when the change affects config, install behavior, or workflow semantics and the fallback is not obvious.
14. Hand off to `brainstorming` if ambiguity appears, to `plan` if scope grows, or to `debug` if behavior is broken.
15. If stopping after non-trivial work, report what changed, what was validated, what was skipped, any remaining risk, and whether the work is complete or paused.

## Guardrails

- do not widen scope without saying so
- do not keep expanding the implementation area when a narrower change is still plausible
- do not cross more than one clear boundary expansion without handing off to `plan` or explicitly restating scope
- do not add compatibility layers unless there is a concrete need
- do not close from `implement` when the claim needs more than Tier 1 `smoke` evidence or meaningful regression confidence
- do not claim success before fresh validation evidence exists
- do not stop after a non-trivial checkpoint without naming the boundary reached, validation state, and rollback or escape path when relevant
- do not stop after non-trivial work without an explicit closeout summary

## Output Contract

Use this structure:

```text
Goal
Checkpoint Reached
Files Changed
Validation
Boundary Status
Rollback Note
Next Handoff
```

Include in the sections above:

- whether the next checkpoint remains inside the approved boundary
- whether validation was run, skipped, or delegated to `test`
- blockers, open questions, or scope expansion noticed during execution

If stopping after non-trivial work, include a closeout summary covering what changed, what was validated, what was skipped, remaining risk, and whether the work is complete or paused.

## Handoff Rules

- `implement` -> `test`
- `implement` -> `brainstorming`
- `implement` -> `plan`
- `implement` -> `debug`
- `implement` -> stop
