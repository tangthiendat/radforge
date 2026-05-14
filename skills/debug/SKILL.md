---
name: debug
description: Use when something is broken, failing, regressing, or behaving unexpectedly. Reproduce the issue, isolate the cause, test a small fix, and verify the result.
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
3. Define the smallest failing scope first, preferably the component, boundary, or step closest to the failure.
4. If multiple causes are plausible, list the leading hypotheses and rank them by likelihood and testability.
5. Test one concrete hypothesis at a time, starting with the narrowest highest-signal check.
6. Change the smallest thing needed to test that hypothesis.
7. Re-run the reproduction or validation step.
8. Broaden scope only if the component-level investigation does not explain the failure.
9. Pause for approval when the cause is clear and implementation would materially change code, config, or workflow.
10. Hand off to `implement` for the actual fix when the cause is clear and implementation is approved.
11. Hand off to `verify-result` after the fix is validated.

## Guardrails

- do not guess past the evidence
- do not broaden scope before checking the smallest relevant failing area
- do not stack multiple speculative fixes at once
- respect diagnosis-first requests and stop after identification when the user does not want the fix yet
- do not claim a fix before the failure has been re-checked

## Supporting Files

- read `references/evidence-loop.md` when you need a tighter reproduction checklist, hypothesis loop, or failure-record pattern

## Output Contract

- reproduction path
- failing scope or component boundary
- observed evidence
- root-cause finding, best-supported hypothesis, or ranked leading hypotheses
- approval status or diagnosis-only status
- next check or reason for handoff
- next-skill handoff

## Handoff Rules

- `debug` -> `implement`
- `debug` -> `plan`
- `debug` -> `verify-result`
