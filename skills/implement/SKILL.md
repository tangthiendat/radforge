---
name: implement
description: Use when the task is clear enough to execute. Make the smallest correct change, preserve existing patterns, and hand off to testing when needed.
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

1. Confirm the direction is clear enough to execute.
2. Inspect the relevant files before editing.
3. Follow existing project patterns unless there is a concrete reason not to.
4. Start with the narrowest change in the smallest relevant boundary that can solve the problem.
5. Make the smallest correct change.
6. Preserve unrelated user changes.
7. Run the smallest meaningful validation when it is obvious and cheap.
8. Hand off to `test` when broader validation or regression coverage is needed.
9. Hand off to `brainstorming` if ambiguity appears, to `plan` if scope grows, or to `debug` if behavior is broken.

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
- next-skill handoff or stop state

## Handoff Rules

- `implement` -> `test`
- `implement` -> `brainstorming`
- `implement` -> `plan`
- `implement` -> `debug`
- `implement` -> stop
