---
name: use-radforge
description: Use when Radforge is installed and the current task may need structured workflow routing. Respect repo-local rules, decide whether Radforge applies, and hand off to the single right core skill.
---

# use-radforge

## Purpose

Act as the default Radforge entrypoint for non-trivial work.

When this skill is invoked, it should quickly decide whether Radforge should take over the task and which single primary workflow skill should be used next.

This skill should be treated as a pre-task router, not as an optional explainer that sits beside the workflow.

## When To Use

- Radforge is installed and the user wants structured workflow help.
- a global instruction hint points to this skill
- the current task needs a quick decision about which Radforge skill should take over
- the current task is ambiguous, multi-step, failing, regressing, design-heavy, or tradeoff-heavy
- the agent has not yet chosen a more specific Radforge skill for the task

## When Not To Use

- the repository already defines a different workflow and the user wants to follow that instead
- work is already in progress under a clearer active skill
- the user explicitly does not want Radforge workflow for the task
- the task is small, clear, and low risk enough to handle directly

## Process

1. Read repo-local instructions and nearby docs first.
2. Decide whether the task is trivial enough to handle directly or whether Radforge should take over.
3. Explain Radforge in one short pass only if the user appears unfamiliar with it.
4. If Radforge should not be used, say so briefly and stop.
5. Route unclear or tradeoff-heavy work to `brainstorming`.
6. Route multi-step or dependency-heavy work to `plan`.
7. Route clear direct execution to `implement`.
8. Route failures or regressions to `debug`.
9. Let `test` and `verify-result` happen later as part of execution and closeout.

## Decision Rules

- ambiguity, open design questions, or multiple reasonable approaches -> `brainstorming`
- broad execution with several dependent steps -> `plan`
- clear, direct execution with low ambiguity -> `implement`
- broken behavior, test failures, regressions, or unexpected output -> `debug`
- tiny, obvious work may skip Radforge after acknowledging that choice

## Activation Rule

- before proceeding with non-trivial work, invoke this skill first unless a more specific repository-local workflow already applies
- once invoked, choose exactly one primary next skill or explicitly decline Radforge for the task
- do not linger in this skill after the routing decision is made

## Guardrails

- do not replace repo-local instructions with personal Radforge defaults
- do not force the full workflow into small tasks that do not need it
- stay short; this skill should route rather than become the whole workflow
- if the repository clearly wants another process, follow the repository
- choose one primary next skill instead of blending several at once
- default to using Radforge for non-trivial work rather than waiting for explicit user wording

## Output Contract

- one-pass explanation of Radforge when needed
- whether Radforge is appropriate for the current task
- the single recommended next skill
- any repo-local rule that overrides the personal default
- immediate handoff intent instead of prolonged analysis inside this skill

## Handoff Rules

- `use-radforge` -> `brainstorming`
- `use-radforge` -> `plan`
- `use-radforge` -> `implement`
- `use-radforge` -> `debug`
- `use-radforge` -> stop
