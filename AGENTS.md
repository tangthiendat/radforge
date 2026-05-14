# Personal Skills Framework

## Scope

This `AGENTS.md` is the project-specific authority for this repository.

Shared global guidance lives in `global/AGENTS.md`.
Do not modify `global/AGENTS.md` unless the user explicitly asks.

## Repository Layout

- `skills/<skill>/SKILL.md`: main entry file for each project skill
- `skills/<skill>/references/`: optional supporting material for deeper guidance
- `docs/specs/`: approved framework and design specs
- `docs/plans/`: written implementation plans
- `global/AGENTS.md`: shared global instructions, not this project's change target unless explicitly requested

## Default Workflow Rule

Apply this framework to non-trivial work by default.

Trivial one-step requests may skip the framework when doing so is clearly lower friction and still safe.

## Core Skills

- `brainstorming`: clarify unclear work, compare options, and get alignment before execution
- `plan`: break multi-step or risky work into an ordered execution plan
- `implement`: make the actual code, docs, config, or workflow changes
- `test`: run meaningful validation and capture evidence
- `verify-result`: confirm what changed, what was validated, and any remaining risk before claiming completion
- `debug`: reproduce, isolate, and verify the root cause of broken behavior

## Starting Skill Selection

Choose one primary starting skill for non-trivial work:

- use `brainstorming` when the request is unclear, under-specified, or has multiple reasonable approaches
- use `debug` when something is failing, regressing, or behaving unexpectedly
- use `implement` when the task is already clear and small enough to execute directly

## Conditional Skills

- use `plan` when execution is multi-step, risky, or dependency-heavy
- use `test` when there is meaningful behavior or regression risk to validate
- use `verify-result` before claiming any non-trivial work is complete

## Workflow Transitions

- if ambiguity appears during execution, return to `brainstorming`
- if execution or testing exposes a failure, switch to `debug`
- if the scope grows beyond a few obvious steps, add `plan`
- if nothing meaningful exists to validate, skip `test` but still run `verify-result`

## Human Approval Gates

Pause and ask for approval when a gate applies:

- after `brainstorming` when the work includes meaningful design or tradeoff decisions
- after `plan` when the execution path is multi-step, risky, or sensitive
- before destructive changes, broad refactors, commits, pushes, or other irreversible actions
- during `verify-result` only when another approval gate still applies or the user explicitly wants a review checkpoint

If the user explicitly asks for a narrower workflow, state what is being skipped and any resulting risk. Do not skip approval for irreversible or unusually high-risk actions.

## Workflow Flexibility

- the user may request a design-only, plan-only, implementation-only, debugging-only, testing-only, or review-style workflow
- the user may ask to add checkpoints, remove checkpoints, or stop after a specific phase
- explicit user direction may shorten the default path when doing so is safe
- when the workflow is shortened, state what was skipped and any resulting risk
- when the workflow is expanded, explain why the added phase is needed

## Project Conventions

- inspect local `docs/`, project instructions, and repository guidance files before editing
- `brainstorming` should read the related `docs/` folder first, or the closest equivalent guidance folder when `docs/` is not the right source
- keep project rules in this file and shared defaults in `global/AGENTS.md`
- treat project-level docs and specs as stronger than outside references

## Skill Authoring Rules

- keep this project `AGENTS.md` concise and project-specific
- keep each skill focused on one coherent job
- keep each `SKILL.md` lean and use supporting files only when they materially improve clarity or reliability
- use progressive disclosure: put deeper detail in `references/` rather than bloating the main skill file
- add scripts only when they improve determinism or safety
- refine skills from real repeated workflows and observed failures

## Source Selection Policy

When improving this framework, prefer:

- official documentation from reputable providers
- open standards and specifications
- strong public repositories and engineering writeups
- public practitioner feedback with real usage evidence

Use repeated patterns and concrete examples as stronger signals than promotional claims. Community feedback may refine the framework, but it does not override safety.
