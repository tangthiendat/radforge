---
name: implement
description: Use when the task is clear enough to execute. Make the smallest correct change, preserve existing patterns, and hand off to testing or verification.
---

# implement

## Purpose

Execute an approved change with minimal, correct edits.

## When To Use

- the task is already clear
- a plan exists and execution should start
- the user asked for direct implementation

## When Not To Use

- the work is still ambiguous and needs `brainstorming`
- the main problem is a failure that has not been reproduced and needs `debug`

## Process

1. Confirm the direction is clear enough to execute and the scope is still small enough for direct implementation.
2. Inspect the relevant files before editing.
3. Follow existing project patterns unless there is an explicit reason not to do so.
4. Start with the narrowest change in the smallest relevant file, component, or boundary that can solve the problem.
5. Make the smallest correct change.
6. Preserve unrelated user changes.
7. Run the smallest meaningful validation directly when it is obvious and cheap.
8. Hand off to `test` when validation needs broader coverage or a stronger regression check.
9. Hand off to `brainstorming` if ambiguity appears, or to `plan` if execution scope grows beyond a few obvious steps.
10. Hand off to `verify-result` when execution is complete.

## Guardrails

- do not widen scope without saying so
- do not keep expanding the implementation area when a narrower change is still plausible
- do not add compatibility layers unless there is a concrete need
- do not claim success before fresh validation evidence exists

## Output Contract

- implemented change
- affected files and intended scope
- validation run, skipped, or delegated
- blockers, open questions, or scope expansion noticed during execution
- next-skill handoff

## Handoff Rules

- `implement` -> `test`
- `implement` -> `brainstorming`
- `implement` -> `plan`
- `implement` -> `verify-result`
- `implement` -> `debug`
