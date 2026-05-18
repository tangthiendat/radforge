---
name: brainstorming
description: Use when a task is unclear, under-specified, or has multiple reasonable approaches. Clarify scope, compare options, and get approval before execution.
maturity: core
owner: radforge
lastReviewed: "2026-05-18"
compatibility: bootstrap-only installed use and repo-local workflow contracts
---

# brainstorming

## Purpose

Clarify unclear work before execution starts.

## When To Use

- the request is ambiguous, incomplete, or internally conflicting
- multiple approaches look reasonable
- success criteria, constraints, or sequencing are still unclear
- the user wants design help before edits

## When Not To Use

- the task is already clear and small enough to execute directly
- the main issue is a failure that needs reproduction and root-cause work first
- the user explicitly wants implementation-only and the reduced process is safe

## Process

1. Read the related `docs/` material and repository guidance first.
2. Inspect the relevant repository context before proposing changes.
3. Ask one clarifying question at a time when needed.
4. Summarize the goal, constraints, success criteria, and scope boundary.
5. If there is a real decision to make, propose 2-3 approaches with tradeoffs.
6. Recommend one direction and explain why it is the best fit.
7. If the work is too large for one coherent effort, decompose it only enough to choose a direction or split the problem into approved workstreams.
8. Pause for approval when the work includes meaningful design or tradeoff decisions.
9. Hand off to `plan` only when the approved direction is substantial, risky, or dependency-heavy.
10. Hand off to `implement` when the direction is clear and the remaining work is direct.

## Guardrails

- do not start implementation while the direction is still unclear
- keep the process lightweight when the design surface is small
- do not smuggle planning detail into brainstorming when the user has not approved the direction yet
- do not produce file maps, ordered task lists, or validation command inventories here; that is `plan` once the direction is approved
- do not fully decompose execution phases here; stop once the direction and workstream boundary are clear enough for `plan`
- do not hand off to `plan` for small direct tasks once the direction is clear
- respect design-only requests and stop after alignment when asked
- do not skip relevant repository guidance when `docs/`, specs, plans, or similar folders already describe the area

## Supporting Files

- read `references/patterns.md` when you need question patterns, approach comparison structure, or approval-gate wording

## Output Contract

Use this structure:

```text
Goal
Scope Boundary
Constraints
Options
Recommendation
Approval Status
Next Handoff
```

Include in the sections above:

- clarified problem statement and success criteria
- scope boundary or decomposition decision
- recommended direction and its key tradeoff
- unresolved assumptions or open questions

## Handoff Rules

- `brainstorming` -> `plan`
- `brainstorming` -> `implement`
- `brainstorming` -> stop
