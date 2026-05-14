---
name: verify-result
description: Use before claiming non-trivial work is complete. Summarize what changed, what was validated, what was skipped, and any remaining risk.
---

# verify-result

## Purpose

Close non-trivial work with explicit evidence and risk reporting.

## When To Use

- non-trivial work appears complete
- implementation or testing finished
- the user needs a completion summary before the next action

## When Not To Use

- the work is still in active execution
- validation has not happened yet and `test` is still needed

## Process

1. List what changed.
2. List what was validated and the exact evidence available.
3. State what was skipped and why.
4. State any remaining risk.
5. State whether the work is complete, complete with remaining risk, or paused for approval or review.
6. Ask for approval only when another gate still applies or the user explicitly wants a review checkpoint.

## Guardrails

- do not claim completion without fresh evidence
- do not hide skipped validation or residual risk
- keep the summary specific to the actual work performed

## Supporting Files

- read `references/closing-summary.md` when you need templates for completion summaries, skipped validation, or remaining-risk wording

## Output Contract

- change summary
- validation summary
- skipped steps and reasons
- remaining risk
- completion status
- approval status
- next action state when relevant
- approval prompt when required

## Handoff Rules

- `verify-result` -> stop
