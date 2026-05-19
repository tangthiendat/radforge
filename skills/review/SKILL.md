---
name: review
description: Use when existing changes, artifacts, or workflows need bug, regression, or rollout-risk assessment rather than implementation.
maturity: core
kind: quality
owner: radforge
lastReviewed: "2026-05-19"
compatibility: provider-global instructions, bootstrap routing, and repo-local workflow contracts
---

# review

## Purpose

Assess existing changes, artifacts, or workflows for bugs, regressions, missing validation, and rollout risk.

## When To Use

- the user asks for a review
- a diff, change set, or artifact exists and needs risk assessment
- release or merge readiness needs a findings-first check
- the main job is finding problems rather than making changes

## When Not To Use

- there is no meaningful review surface yet
- the main task is to implement or validate behavior
- the issue is an active failure that still needs reproduction or diagnosis in `debug`

## Process

1. Identify the review surface: files, diff, commit range, config, docs, plan, or workflow artifact.
2. Read repo-local instructions and any docs that define the intended behavior.
3. Inspect the highest-risk surfaces first: behavior changes, config or install paths, deletion or migration logic, state or output changes, and auth, security, or secret-handling paths when present.
4. Look for correctness bugs, regressions, missing validation, rollout or migration risk, stale docs or spec mismatches, and maintainability traps likely to cause future defects.
5. Prefer evidence-backed findings. If the signal is incomplete, record an open question or residual risk instead of overstating it.
6. Group findings by severity and cite file references when possible.
7. If there are no material findings, say so explicitly and note any remaining validation gaps or unreviewed surfaces.
8. If the user wants follow-up beyond the review, hand off to `debug`, `implement`, or `plan` based on the finding type.

## Guardrails

- put findings first
- do not rewrite or fix the change unless the user asks for follow-up work
- do not invent failures or regressions without evidence
- do not hide missing validation behind a clean summary
- keep the summary brief when findings exist
- distinguish actual defects and operational risk from style preferences

## Supporting Files

- read `references/review-checklist.md` for a focused bug, regression, and rollout-risk checklist
- read `references/severity-guide.md` when you need consistent severity wording
- use `templates/review-report-template.md` when the review is non-trivial
- read `references/example-review-report.md` when you need a concrete example of the expected output shape

## Output Contract

Use this structure:

```text
Scope
Findings
Open Questions
Residual Risk
Next Handoff
```

Include in the sections above:

- findings ordered by severity
- file references when possible
- explicit confirmation when no material findings were found
- remaining validation gaps or assumptions that still affect confidence

## Handoff Rules

- `review` -> `debug`
- `review` -> `implement`
- `review` -> `plan`
- `review` -> stop
