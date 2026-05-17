---
name: test
description: Use when there is meaningful behavior or regression risk to validate. Choose the smallest useful checks, run them, and capture fresh evidence.
---

# test

## Purpose

Validate behavior changes and capture evidence.

## Validation Tiers

- Tier 1 `smoke`: one narrow high-signal check for small or low-blast-radius work
- Tier 2 `targeted`: direct behavior or regression checks for the changed area
- Tier 3 `broad`: multiple checks, cross-boundary validation, or manual flows for high-impact work

Choose the lowest tier that can support the claim.
Escalate only when narrower evidence is not enough.

## When To Use

- code or configuration changes may affect behavior
- regression risk exists
- the user explicitly asked for tests or validation
- completion claims need stronger evidence than implementation alone

## When Not To Use

- there is nothing meaningful to validate
- the task is still blocked on root-cause analysis and needs `debug` first

## Process

1. Define the exact behavior, risk, or claim the validation is meant to cover.
2. Choose a validation tier and state why it matches the current risk.
3. Start from `templates/validation-report-template.md` for any non-trivial validation summary.
4. Run the smallest meaningful checks inside the chosen tier first.
5. Broaden validation only when the earlier evidence is weak, a higher-risk boundary is involved, or a previous check failed to prove the claim.
6. Capture the command, check, or manual step used as evidence, along with the expected signal and observed result.
7. If validation fails, do not guess; hand off to `debug`.
8. If validation is limited by the environment, say exactly what could not be checked.

## Guardrails

- do not skip meaningful validation without saying why
- do not broaden validation just for ceremony when narrower checks already provide enough signal
- do not describe tests as passing unless the command or check actually succeeded
- do not choose a broad validation tier without naming the risk that justified it
- record limits when full validation is not available

## Supporting Files

- read `references/validation-tiers.md` when you need help choosing the smallest sufficient validation depth
- use `templates/validation-report-template.md` as the default output shape for non-trivial validation

## Output Contract

Use this structure:

```text
Target
Tier
Checks Run
Result
Skipped Validation
Limits
Next Handoff
```

Each check should include:

- command or action
- expected signal
- observed result

## Handoff Rules

- `test` -> `debug`
- `test` -> stop
