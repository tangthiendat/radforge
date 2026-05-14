---
name: plan
description: Use when work is multi-step, risky, or dependency-heavy. Turn an approved direction into an ordered execution plan with validation and checkpoints.
---

# plan

## Purpose

Turn a chosen direction into an actionable execution plan.

## When To Use

- execution will touch multiple files or phases
- the work has risk, sequencing, or dependency concerns
- the user asked for a plan before implementation

## When Not To Use

- the task is a clear one-step change
- the work is still ambiguous and needs `brainstorming`
- the task is blocked on reproducing a failure and needs `debug`

## Process

1. Read the related `docs/` folder first, or the closest equivalent guidance folder if `docs/` is not the right source.
2. Re-read the approved direction and current repository context.
3. Confirm the work still fits one coherent plan; if unresolved ambiguity appears, hand off to `brainstorming`, and if independent workstreams appear, split the plan or pause for approval.
4. Decide the concrete file map before writing tasks.
5. Break the work into small ordered tasks.
6. Include exact validation steps for each meaningful phase.
7. Call out approval gates before risky or high-impact actions.
8. Save the plan in `docs/plans/` when the user wants a written handoff.
9. Pause for approval before execution when the plan introduces meaningful scope, risk, sequencing, or decomposition decisions.

## Guardrails

- do not plan speculative features that are outside the approved scope
- do not force one plan when the work should be split into separate independent plans
- keep tasks small enough to execute and verify independently
- do not hide unresolved assumptions that materially affect execution
- prefer the smallest implementation that satisfies the goal

## Supporting Files

- read `references/patterns.md` when you need help shaping tasks, mapping files, or writing validation steps

## Output Contract

- concrete file map
- scope boundary or decomposition decision
- ordered task list
- validation strategy
- major execution risks or checkpoints
- unresolved assumptions or open questions
- approval points
- approval status
- next-skill handoff

## Handoff Rules

- `plan` -> `brainstorming`
- `plan` -> `implement`
- `plan` -> stop
