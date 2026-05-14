---
name: brainstorming
description: Use when a task is unclear, under-specified, or has multiple reasonable approaches. Clarify scope, compare options, and get approval before execution.
---

# brainstorming

## Purpose

Clarify unclear work before execution starts.

## When To Use

- the request is ambiguous or incomplete
- multiple approaches look reasonable
- success criteria or constraints are still unclear
- the user wants design help before edits

## When Not To Use

- the task is already clear and small enough to execute directly
- the main problem is a bug that needs reproduction and root-cause work first
- the user explicitly wants implementation-only and the reduced process is safe

## Process

1. Read the related `docs/` folder first, or the closest equivalent guidance folder if `docs/` is not the right source.
2. Inspect the rest of the relevant repository context.
3. Ask one clarifying question at a time when needed.
4. Summarize the goal, constraints, and success criteria.
5. Propose 2-3 approaches with tradeoffs when there is a real choice.
6. Recommend one path.
7. Pause for approval if the work includes meaningful design or tradeoff decisions.
8. Hand off to `plan` only if the work is multi-step or risky; for small direct tasks, hand off to `implement` once the direction is clear.

## Guardrails

- do not start implementation while the direction is still unclear
- keep the process lightweight when the design surface is small
- do not hand off to `plan` for small direct tasks once the direction is clear
- respect design-only requests and stop after alignment when asked
- do not skip relevant repository guidance when `docs/`, specs, plans, or similar folders already describe the area

## Supporting Files

- read `references/patterns.md` when you need question patterns, approach-comparison structure, or approval-gate wording

## Output Contract

- clarified problem statement
- scope boundary or decomposition decision
- constraints and success criteria
- recommended direction and key tradeoff
- unresolved assumptions or open questions
- approval status
- next-skill handoff

## Handoff Rules

- `brainstorming` -> `plan`
- `brainstorming` -> `implement`
- `brainstorming` -> stop
