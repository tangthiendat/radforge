---
name: use-radforge
description: Use when this personal Radforge workflow is installed and the current task may need structured routing. Respect repo-local rules, decide whether the framework applies, and hand off to the single right core skill.
maturity: core
owner: radforge
lastReviewed: "2026-05-18"
compatibility: bootstrap-only installed use and repo-local workflow contracts
---

# use-radforge

## Purpose

Act as the default entrypoint for this personal Radforge framework on non-trivial work.

This skill should make a fast routing decision, choose one primary next skill, and get out of the way.

It must still work when installed outside a repository that has no stronger local workflow contract.

## When To Use

- Radforge is installed and the task may need structured workflow help
- the user invoked this skill directly or the provider surfaced it through installed skill discovery
- the current task is ambiguous, multi-step, failing, regressing, design-heavy, or tradeoff-heavy
- the agent has not yet chosen a more specific workflow skill

## When Not To Use

- the repository already defines a different workflow and the user wants to follow that instead
- work is already in progress under a clearer active skill
- the user explicitly does not want Radforge workflow for the task
- the task is small, clear, and low risk enough to handle directly

## Process

1. Read repo-local instructions and nearby guidance first.
2. Read the closest scoped rule files when they narrow the local workflow for the area you are about to touch.
3. If repository-local workflow fully overrides Radforge, stop and follow the repository.
4. Decide whether the task is trivial enough to handle directly or whether Radforge should take over.
5. Explain Radforge in one short pass only if the user appears unfamiliar with it.
6. If Radforge should not be used, say so briefly and stop.
7. Apply repository-local routing precedence when it is explicitly defined; otherwise use the default Radforge routing precedence below.
8. Hand off to one primary next skill and stop.

## Default Routing Precedence

1. active failure, reproduced regression, or unexpected broken behavior -> `debug`
2. unresolved ambiguity, open design questions, or multiple reasonable approaches -> `brainstorming`
3. behavior validation or regression checking with no primary implementation change -> `test`
4. clear but multi-step, risky, or dependency-heavy execution -> `plan`
5. clear, low-ambiguity direct execution -> `implement`
6. tiny, obvious, low-risk work may skip Radforge and stop

## Activation Rule

- before proceeding with non-trivial work, invoke this skill first unless a stronger repository-local workflow already applies
- once invoked, choose exactly one primary next skill or explicitly decline Radforge for the task
- do not linger in this skill after the routing decision is made

## Guardrails

- do not replace repo-local instructions with personal Radforge defaults
- do not force the full workflow into small tasks that do not need it
- prefer repository-local routing only when it is explicit; otherwise use the default Radforge routing precedence above
- stay short; this skill should route rather than become the whole workflow
- if the repository clearly wants another process, follow the repository
- choose one primary next skill instead of blending several at once
- default to using Radforge for non-trivial work rather than waiting for explicit user wording

## Output Contract

- whether Radforge is appropriate for the current task
- one-pass explanation only if needed
- the single selected next skill or explicit decision to skip Radforge
- whether repository-local routing or default Radforge routing was used
- any repo-local rule that overrides the personal default
- immediate handoff intent

## Handoff Rules

- `use-radforge` -> `debug`
- `use-radforge` -> `brainstorming`
- `use-radforge` -> `test`
- `use-radforge` -> `plan`
- `use-radforge` -> `implement`
- `use-radforge` -> stop
