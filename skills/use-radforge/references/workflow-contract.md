# Radforge Workflow Contract

Shared rules for every Radforge workflow skill in installed use.

Always load this contract once per task before running any Radforge skill, including when a core skill is invoked directly without `use-radforge`. Load it even when the repository has its own rules; repository-local rules win on conflict (see Precedence). If an earlier Radforge skill in the same task already loaded it, do not load it again.

Rules decide `when`. Skills decide `how`.

## Precedence

1. direct user instructions
2. repository-local instructions: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, scoped rule files, and project docs such as `docs/CODING_CONVENTION.md`
3. this contract
4. individual skill defaults

Repository-local rules override this contract when they are explicit. This contract never relaxes host or provider safety controls; when they are stricter, follow them.

If instructions conflict and the safe choice is unclear, ask one concise question.

## Active Skill

- use one active primary skill at a time
- a skill may hand off to exactly one next primary skill, or stop
- do not blend several workflow skills unless the user explicitly asks for a narrower custom process
- default routing precedence lives in `use-radforge`; repository-local routing wins when it is explicit

## Handoff Context

Carry these across every handoff and recover them on entry:

- original goal and acceptance criteria
- plan/task position and remaining work
- user constraints, including no-edit or diagnosis-only scope
- existing authorization

Existing authorization covers unchanged, already approved work. It does not extend to a materially different action.

## Escalation

- ambiguity appears during execution -> `brainstorming`
- scope grows beyond a few obvious steps -> `plan`
- validation fails or behavior is broken -> `debug`
- substantial or risky work is fully validated -> `review` is an optional last step that the agent or the user may choose; a user's decline wins
- the repository clearly requires another workflow -> follow the repository

## Approval Gates

Pause and ask before:

- destructive commands, broad deletes, hard resets, or force pushes
- commits and pushes, unless the user explicitly asked for them
- broad refactors or other irreversible actions
- changing user-level, global, or installed configuration outside the task's repository
- implementing a debug finding that materially changes code, config, or workflow, unless the user already asked to proceed

Also pause:

- after `brainstorming` when the work includes meaningful design or tradeoff decisions
- after `spec-writing` when the saved spec is approval-sensitive
- during `migration` when cutover timing, compatibility promises, rollback limits, or deletion timing need a decision
- after `plan` when the execution path is substantial, risky, or introduces meaningful sequencing decisions

When the user asks for a shorter workflow, state what is skipped and the resulting risk. Never skip approval for irreversible or unusually high-risk actions.

## Safety

- inspect relevant context before editing
- preserve unrelated and concurrent user changes; never revert or clean them up unless asked
- do not expose or commit secrets, credentials, tokens, or private environment files
- prefer the smallest correct change; do not add compatibility layers without a concrete need

## Artifacts

- a location the user names always wins; use it as given and do not move or rename it
- otherwise use the repository's existing locations and formats for specs and plans
- when neither exists, default to `docs/radforge/specs/` and `docs/radforge/plans/`, and name any newly created location in the closeout
- write a plan when the work is multi-phase, risky, spans dependent files or components, is likely to be resumed or handed off, or the user asks for one
- keep a lightweight plan in chat only when the work is short, low-risk, and unlikely to be reused

## Evidence

- do not claim success without fresh evidence
- run the narrowest high-signal check first
- if validation is skipped, state exactly why
- distinguish observed evidence from assumptions
- distinguish environment limitations from product failures
- a passing checkpoint is not completion of the original request

## Closeout

Before claiming non-trivial work is complete, state:

- what changed
- what was validated
- what was skipped and why
- any remaining risk
- whether the work is complete, complete with remaining risk, or paused

Continue remaining approved work after a validated checkpoint. Claim completion only when the original authorized scope and acceptance criteria are satisfied. Honor explicit requests to stop at a narrower boundary and report the unfinished work.
