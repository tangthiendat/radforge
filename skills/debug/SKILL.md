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
2. Capture the exact error, output, or behavior.
3. Define the smallest failing scope first.
4. If multiple causes are plausible, rank the leading hypotheses by likelihood and testability.
5. Test one concrete hypothesis at a time, starting with the narrowest high-signal check.
6. Change the smallest thing needed to test that hypothesis.
7. Re-run the reproduction or validation step.
8. Classify the failure when the evidence is strong enough: local defect, missing validation, dependency or configuration issue, environment or tooling issue, or architecture interaction.
9. Classify the fix path when the cause is clear enough: local fix now, validation gap first, dependency or config repair, environment follow-up, or broader architecture plan.
10. Broaden scope only if the component-level investigation does not explain the failure.
11. Pause for approval when the cause is clear and the fix would materially change code, config, or workflow beyond the original ask.
12. Hand off to `implement` for the actual fix when the cause is clear and implementation is approved.
13. Hand off to `plan` if the fix path becomes substantial or dependency-heavy.

## Guardrails

- do not guess past the evidence
- do not broaden scope before checking the smallest relevant failing area
- do not stack multiple speculative fixes at once
- respect diagnosis-first requests and stop after identification when the user does not want the fix yet
- do not claim a fix before the failure has been rechecked

## Supporting Files

- read `references/evidence-loop.md` when you need a tighter reproduction checklist, hypothesis loop, or failure-record pattern

## Output Contract

- reproduction path
- failing scope or component boundary
- observed evidence
- root-cause finding, best-supported hypothesis, or ranked leading hypotheses
- failure classification when known
- fix classification or next repair class when known
- approval status or diagnosis-only status
- next check or reason for handoff
- next-skill handoff or stop state

## Handoff Rules

- `debug` -> `implement`
- `debug` -> `plan`
- `debug` -> stop
