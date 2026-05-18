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
4. Decide whether the task is trivial enough to handle directly or whether this personal Radforge workflow should activate.
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

## Routing Heuristics

- handle directly only when the task is tiny, obvious, low risk, has no approval gate, and does not need multi-step coordination
- choose `brainstorming` when the direction is still unclear, approval depends on a design choice, or multiple reasonable approaches remain
- choose `implement` when the task is clear and bounded, execution is still direct, and no major sequencing or dependency management is needed
- stay with `implement` when one checkpoint inside one coherent boundary plus one Tier 1-style smoke check is enough to support the claim
- choose `plan` only after the direction is approved or already clear, and the remaining job is execution structure, sequencing, file mapping, validation ordering, or resumable handoff preparation
- choose `plan` when the work is multi-phase, dependency-heavy, likely to be resumed or handed off, or changes install, update, uninstall, config, or shared workflow semantics
- choose `test` when validation or regression checking is the primary job and no main implementation change is pending
- prefer `test` over `implement` when the remaining confidence gap is broader proof: Tier 2 or Tier 3 evidence, regression confidence, cross-file proof, or install/update/uninstall/config/shared-workflow validation
- choose `debug` when something is broken, regressed, or unexplained enough that diagnosis must come first

## Routing Examples

- direct: add one obvious sentence to an existing doc with no workflow implications
- `brainstorming`: the request has two reasonable workflow designs and the approval boundary depends on which one is chosen
- `brainstorming` borderline: the work will likely need a plan later, but the design direction or scope split is still unresolved
- `implement`: tighten one existing skill file with a bounded wording change and one local readback check
- `implement` borderline: update one installer message and confirm it with one dry-run or readback inside the same checkpoint
- `test`: implementation already happened and the remaining job is proving install behavior or regression coverage
- `test` borderline: the code change is done, but completion depends on broader install/update/uninstall proof or changed-area regression confidence
- `debug`: a repro, failing test, or broken command exists and diagnosis must come before edits
- `plan`: restructure a shared installer flow, split a cross-repo workflow, or prepare a multi-phase handoff artifact
- `plan` borderline: the direction is already approved, but execution still needs ordered tasks, checkpoint boundaries, and validation sequencing before implementation should start

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

Use this structure:

```text
Decision
Routing Basis
Selected Skill
Override
Next Handoff
```

Include in the sections above:

- whether Radforge is appropriate for the current task
- one-pass explanation only if needed
- whether repository-local routing or default Radforge routing was used
- any repo-local rule that overrides the personal default
- the single selected next skill or explicit decision to skip Radforge

## Handoff Rules

- `use-radforge` -> `debug`
- `use-radforge` -> `brainstorming`
- `use-radforge` -> `test`
- `use-radforge` -> `plan`
- `use-radforge` -> `implement`
- `use-radforge` -> stop
