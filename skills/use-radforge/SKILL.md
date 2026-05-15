---
name: use-radforge
description: Use when Radforge is installed and the current task may need structured workflow routing. Respect repo-local rules, decide whether Radforge applies, and hand off to the single right core skill.
---

# use-radforge

## Purpose

Act as the default Radforge entrypoint for non-trivial work.

This skill should make a fast routing decision, choose one primary next skill, and get out of the way.

## When To Use

- Radforge is installed and the task may need structured workflow help
- a global instruction hint points to this skill
- the current task is ambiguous, multi-step, failing, regressing, design-heavy, or tradeoff-heavy
- the agent has not yet chosen a more specific workflow skill

## When Not To Use

- the repository already defines a different workflow and the user wants to follow that instead
- work is already in progress under a clearer active skill
- the user explicitly does not want Radforge workflow for the task
- the task is small, clear, and low risk enough to handle directly

## Process

1. Read repo-local instructions and nearby guidance first.
2. If repository-local workflow fully overrides Radforge, stop and follow the repository.
3. Decide whether the task is trivial enough to handle directly or whether Radforge should take over.
4. Explain Radforge in one short pass only if the user appears unfamiliar with it.
5. If Radforge should not be used, say so briefly and stop.
6. Apply the routing precedence exactly once.
7. Hand off to one primary next skill and stop.

## Routing Precedence

Apply the first matching rule:

1. active failure, regression, or unexplained broken behavior -> `debug`
2. unresolved ambiguity, open design questions, or multiple reasonable approaches -> `brainstorming`
3. clear but multi-step, risky, or dependency-heavy execution -> `plan`
4. clear, direct execution with low ambiguity -> `implement`
5. tiny obvious work may skip Radforge after acknowledging that choice

## Activation Rule

- before proceeding with non-trivial work, invoke this skill first unless a stronger repository-local workflow already applies
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

- whether Radforge is appropriate for the current task
- one-pass explanation only if needed
- the single selected next skill or explicit decision to skip Radforge
- any repo-local rule that overrides the personal default
- immediate handoff intent

## Handoff Rules

- `use-radforge` -> `debug`
- `use-radforge` -> `brainstorming`
- `use-radforge` -> `plan`
- `use-radforge` -> `implement`
- `use-radforge` -> stop
