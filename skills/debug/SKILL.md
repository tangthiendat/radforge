---
name: debug
description: Use when something is broken, failing, regressing, or behaving unexpectedly. Reproduce the issue, isolate the cause, test a small fix, and verify the result.
maturity: core
owner: radforge
lastReviewed: "2026-05-18"
compatibility: bootstrap-only installed use and repo-local workflow contracts
---

# debug

## Purpose

Find and verify the root cause of broken behavior.

## When To Use

- a bug report or failure exists
- tests, builds, or commands are failing
- behavior regressed or does not match expectations

## When Not To Use

- the task is mainly design or scoping work and needs `brainstorming`
- the work is a clean structural improvement and should start in `implement`, using `plan` first if the cleanup is large or risky

## Process

1. Reproduce the issue or failure.
2. Record the reproduction exactly: trigger, actual result, expected result, whether the issue is consistent or intermittent, and the smallest known failing boundary.
3. Define the smallest failing scope first.
4. If multiple causes are plausible, rank the leading hypotheses by likelihood and testability.
5. Test one concrete hypothesis at a time.
6. For each loop, state the suspected cause, choose the smallest check that would confirm it, run the reproduction or validation again, and keep or discard the hypothesis from the evidence.
7. Change the smallest thing needed to test that hypothesis.
8. Re-run the reproduction or validation step.
9. Classify the failure when the evidence is strong enough: local defect, missing validation, dependency or configuration issue, environment or tooling issue, or architecture interaction.
10. Classify the fix path when the cause is clear enough: local fix now, validation gap first, dependency or config repair, environment follow-up, or broader architecture plan.
11. Broaden scope only if the component-level investigation does not explain the failure.
12. Pause for approval when the cause is clear and the fix would materially change code, config, or workflow beyond the original ask.
13. Hand off to `implement` for the actual fix when the cause is clear and implementation is approved.
14. Hand off to `plan` if the fix path becomes substantial or dependency-heavy.

## Guardrails

- do not guess past the evidence
- do not broaden scope before checking the smallest relevant failing area
- do not stack multiple speculative fixes at once
- do not move to a new hypothesis before concluding the current one from the evidence
- respect diagnosis-first requests and stop after identification when the user does not want the fix yet
- do not claim a fix before the failure has been rechecked

## Supporting Files

- read `references/evidence-loop.md` when you need a tighter reproduction checklist, hypothesis loop, or failure-record pattern

## Output Contract

Use this structure:

```text
Reproduction
Failing Boundary
Evidence
Hypothesis Status
Classification
Next Check
Handoff
```

Include in the sections above:

- exact trigger, actual result, expected result, and consistency
- root-cause finding, best-supported hypothesis, or ranked leading hypotheses
- failure classification and fix classification when known
- approval status or diagnosis-only status

## Handoff Rules

- `debug` -> `implement`
- `debug` -> `plan`
- `debug` -> stop
