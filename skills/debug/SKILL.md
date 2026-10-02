---
name: debug
description: Use when something is broken, failing, regressing, or behaving unexpectedly. Reproduce the issue, isolate the cause, test a small fix, and verify the result.
maturity: core
kind: workflow
owner: radforge
lastReviewed: "2026-10-02"
compatibility: bootstrap routing and repo-local workflow contracts
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

1. Recover the original goal, acceptance criteria, plan/task position, remaining work, user constraints, and existing authorization. Establish diagnosis-only, no-edit, or fix-authorized scope before reproduction or any experiment.
2. Reproduce the issue or failure within that scope.
3. Record the reproduction exactly: trigger, actual result, expected result, whether the issue is consistent or intermittent, and the smallest known failing boundary.
4. Define the smallest failing scope first.
5. If multiple causes are plausible, rank the leading hypotheses by likelihood and testability.
6. Test one concrete hypothesis at a time: state the suspected cause and choose the smallest check that would confirm it.
7. Prefer read-only checks. Before any mutation, confirm that the experiment fits the user's scope and existing authorization. Explicit no-edit requests prohibit mutation. A routine reversible experiment within authorized scope needs no repeated approval; use a read-only alternative or obtain approval before an experiment outside that scope.
8. When mutation is authorized, prefer an isolated fixture, temporary override, or disposable copy. Record the relevant pre-experiment state and the agent's exact changes, then change the smallest thing needed to test the hypothesis.
9. Re-run the reproduction or validation step and keep or discard the hypothesis from the evidence.
10. Before the next hypothesis or handoff, restore only the agent's experimental changes and confirm restoration. Retain a change only when retaining or implementing it is already authorized; diagnosis-only work must not leave a fix behind. If overlapping user edits or state changes prevent safe restoration, stop further mutation, preserve the user's work, and report the unresolved experiment state.
11. Classify the failure when the evidence is strong enough: local defect, missing validation, dependency or configuration issue, environment or tooling issue, or architecture interaction.
12. Classify the fix path when the cause is clear enough: local fix now, validation gap first, dependency or config repair, environment follow-up, or broader architecture plan.
13. Broaden scope only if the component-level investigation does not explain the failure.
14. Pause for approval when the cause is clear and the fix would materially change code, config, or workflow beyond the original ask.
15. Hand off to `implement` for the actual fix when the cause is clear and implementation is approved, preserving original task context and any authorized retained changes.
16. Hand off to `test` when the root issue is primarily a validation gap and the main remaining job is evidence gathering.
17. Hand off to `plan` if the fix path becomes substantial or dependency-heavy.

## Guardrails

- do not guess past the evidence
- do not broaden scope before checking the smallest relevant failing area
- do not stack multiple speculative fixes at once
- do not move to a new hypothesis before concluding the current one from the evidence
- respect diagnosis-first requests and stop after identification when the user does not want the fix yet
- do not treat an experimental mutation as exempt from the user's scope or approval limits
- do not use broad resets or cleanup to remove experiments; preserve pre-existing and concurrent user changes
- do not silently retain experimental changes or conceal incomplete restoration
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
- experiment scope, exact agent-owned changes or `none`, restoration evidence, and any authorized retained or unresolved changes
- original task context and remaining approved work for the next skill

## Handoff Rules

- `debug` -> `implement`
- `debug` -> `test`
- `debug` -> `plan`
- `debug` -> stop
