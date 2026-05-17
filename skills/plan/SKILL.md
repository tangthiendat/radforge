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
3. If the approach is still being chosen, hand back to `brainstorming` before writing an execution plan.
4. Start from `templates/execution-plan-template.md` for any non-trivial plan or plan artifact.
5. Decide whether the work fits one coherent plan. If independent workstreams appear, split them or pause for approval.
6. Lock the file map before writing task steps.
7. Break the work into ordered tasks with clear checkpoints.
8. For each task, include the intended outcome, affected files, the narrowest useful validation, and any checkpoint or approval boundary.
9. Keep the plan one level above implementation detail. If it turns into edit-by-edit narration, shrink the task or hand off to `implement`.
10. Call out risks, sequencing constraints, and approval points instead of hiding them in prose.
11. Decide whether the plan must be finalized into `docs/plans/`.
12. If a written plan is required, write and finalize it before handoff.
13. Pause for approval before execution when the plan introduces meaningful scope, risk, sequencing, or decomposition decisions.

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
2. use the canonical template headings in execution order
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
- do not let `brainstorming` and `plan` blur together; approach choice belongs upstream, execution structure belongs here

## Supporting Files

- read `references/patterns.md` when you need help shaping task granularity, file maps, or validation structure
- use `templates/execution-plan-template.md` as the default output shape when a plan needs durable structure

## Output Contract

Use this structure:

```text
Goal
Scope
File Map
Tasks
Validation Strategy
Risks And Approval Points
Finalization Decision
Next Handoff
```

Each task should include:

- intended outcome
- affected files
- validation step
- checkpoint or approval note when relevant

## Handoff Rules

- `plan` -> `brainstorming`
- `plan` -> `implement`
- `plan` -> stop
