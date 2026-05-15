# Radforge Runtime Rules

This file defines the shared Radforge runtime contract installed for this user.

Repository-local instructions such as `AGENTS.md`, `CLAUDE.md`, or equivalent take priority over these shared Radforge rules.

## Active Skill Rule

Use one active primary skill at a time.

- a skill may hand off to exactly one next primary skill
- a skill may stop when the task is complete or the workflow should pause
- do not blend several workflow skills at once unless the user explicitly asks for a narrower custom process

## Workflow Skills

Core workflow skills:

- `brainstorming`: clarify unclear work, compare options, and get alignment before execution
- `plan`: turn an approved direction into an execution plan and finalize substantial plans into `docs/plans/`
- `implement`: make the actual code, docs, config, or workflow changes
- `test`: run meaningful validation and capture fresh evidence
- `debug`: reproduce, isolate, and verify the root cause of broken behavior

Bootstrap skill:

- `use-radforge`: decide whether Radforge should take over and route into the single right workflow skill

## Default Routing Rules

Apply Radforge by default to non-trivial work.

Trivial one-step requests may skip the framework when doing so is clearly lower friction and still safe.

Routing precedence:

1. active failure, regression, or unexpected behavior -> `debug`
2. unresolved ambiguity, open design questions, or multiple reasonable approaches -> `brainstorming`
3. clear but multi-step, risky, or dependency-heavy execution -> `plan`
4. clear, low-ambiguity direct execution -> `implement`
5. behavior validation or regression checking -> `test`

Escalation rules:

- if ambiguity appears during execution, return to `brainstorming`
- if scope grows beyond a few obvious steps, hand off to `plan`
- if validation fails or the behavior is broken, hand off to `debug`
- if the repository clearly requires another workflow, follow the repository

## Approval Gates

Pause and ask for approval when a gate applies:

- after `brainstorming` when the work includes meaningful design or tradeoff decisions
- after `plan` when the execution path is substantial, risky, or introduces meaningful sequencing or decomposition decisions
- before destructive changes, broad refactors, commits, pushes, or other irreversible actions
- before implementing a debug finding when the resulting fix materially changes code, config, or workflow and the user has not already asked to proceed

If the user explicitly asks for a narrower workflow, state what is being skipped and any resulting risk.
Do not skip approval for irreversible or unusually high-risk actions.

## Artifact Rules

Read local `docs/`, project instructions, and repository guidance files before editing when they are relevant.

Use written artifacts when they add durable value:

- write a spec when the work is design-heavy, under-specified, or needs approval as a durable artifact
- write a plan to `docs/plans/` when the work is substantial

A written plan in `docs/plans/` is required when any of the following are true:

- the work is multi-phase
- the work is risky or high-impact
- the work spans multiple files or components with dependencies
- the work is likely to be resumed later
- the work is intended as a handoff artifact
- the user explicitly asks for a written plan

Lightweight plans may stay in chat only when the work is short, low-risk, and unlikely to need reuse.

## Evidence And Validation Rules

- do not claim success without fresh evidence
- if validation is meaningful, run the narrowest high-signal check first
- if validation is skipped, state exactly why
- distinguish observed evidence from assumptions
- distinguish environment limitations from product failures
- treat tests, builds, linters, repro commands, and targeted manual checks as evidence, not ceremony

## Output Contract

Every non-trivial workflow result should report the relevant subset of:

- goal
- constraints
- decisions made
- files or artifacts affected
- evidence gathered
- skipped work and why
- remaining risk
- next action, handoff, or stop state

## Engineering Rules

- inspect the relevant repository context before editing
- prefer the smallest correct change over broader redesign
- preserve unrelated user changes
- do not add compatibility layers unless there is a concrete need
- keep skills focused on one coherent job
- prefer standard markdown and simple scripts over unnecessary complexity

## Closeout Rule

Before claiming non-trivial work is complete, always state:

- what changed
- what was validated
- what was skipped and why
- any remaining risk
- whether the work is complete, complete with remaining risk, or paused

This closeout rule is global and is not a separate workflow skill.

## Workflow Flexibility

- the user may request a design-only, plan-only, implementation-only, debugging-only, testing-only, or review-style workflow
- the user may ask to add checkpoints, remove checkpoints, or stop after a specific phase
- explicit user direction may shorten the default path when doing so is safe
- when the workflow is shortened, state what is being skipped and any resulting risk
- when the workflow is expanded, explain why the added phase is needed
