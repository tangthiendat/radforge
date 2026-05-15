---
name: plan
description: Use when work is multi-step, risky, or dependency-heavy. Turn an approved direction into an ordered execution plan and finalize substantial plans into docs/plans/.
---

# plan

## Purpose

Turn an approved direction into an execution plan that another competent agent or engineer could follow without guessing.

## When To Use

- execution will touch multiple files, phases, or components
- sequencing, dependencies, rollback concerns, or operational risk matter
- the user asked for a plan before implementation
- the work needs a durable handoff artifact

## When Not To Use

- the task is a clear one-step change that can be executed directly
- the work is still ambiguous and needs `brainstorming`
- the main issue is a failing or unexplained behavior that still needs `debug`

## Process

1. Read the relevant `docs/` material and repository guidance first.
2. Reconfirm the approved direction, scope boundary, and success criteria.
3. Decide whether the work fits one coherent plan. If independent workstreams appear, split them or pause for approval.
4. Lock the file map before writing task steps.
5. Break the work into ordered tasks with clear checkpoints.
6. For each task, include the intended outcome, affected files, and the narrowest useful validation.
7. Call out risks, sequencing constraints, and approval points instead of hiding them in prose.
8. Decide whether the plan must be finalized into `docs/plans/`.
9. If a written plan is required, write and finalize it before handoff.
10. Pause for approval before execution when the plan introduces meaningful scope, risk, sequencing, or decomposition decisions.

## Plan Finalization Rule

Write the plan to `docs/plans/` when any of the following are true:

- the work is multi-phase
- the work is risky or high-impact
- the work spans multiple files or components with dependencies
- the work is likely to be resumed later
- the plan is intended as a handoff artifact
- the user explicitly asks for a written plan

Use a chat-only plan only when the work is short, low-risk, and unlikely to need reuse.

## Finalization Subphase

When a written plan is required:

1. choose a focused filename under `docs/plans/`
2. write the plan in execution order
3. include the file map near the top
4. include validation steps for each meaningful phase
5. read the plan back once for gaps, contradictions, and missing checkpoints
6. tell the user where the finalized plan lives before handing off

## Guardrails

- do not plan speculative features outside the approved scope
- do not collapse several independent projects into one plan for convenience
- keep tasks small enough to execute and verify independently
- do not hide unresolved assumptions that materially affect execution
- prefer the smallest implementation that satisfies the goal
- do not defer key sequencing decisions to “implementation will decide later”

## Supporting Files

- read `references/patterns.md` when you need help shaping task granularity, file maps, or validation structure

## Output Contract

- plan scope and goal
- file map
- decomposition decision if the work was split or kept unified
- ordered task list with checkpoints
- validation strategy
- major risks and approval points
- whether `docs/plans/` finalization was required
- finalized plan path when written
- next-skill handoff

## Handoff Rules

- `plan` -> `brainstorming`
- `plan` -> `implement`
- `plan` -> stop
