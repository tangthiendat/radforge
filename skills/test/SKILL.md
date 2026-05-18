---
name: test
description: Use when there is meaningful behavior or regression risk to validate. Choose the smallest useful checks, run them, and capture fresh evidence.
maturity: core
owner: radforge
lastReviewed: "2026-05-18"
compatibility: bootstrap-only installed use and repo-local workflow contracts
---

# test

## Purpose

Validate behavior changes and capture evidence.

## Validation Tiers

- Tier 1 `smoke`: one narrow high-signal check for small or low-blast-radius work
- Tier 2 `targeted`: direct behavior or regression checks for the changed area
- Tier 3 `broad`: multiple checks, cross-boundary validation, or manual flows for high-impact work

Default tier selection:

- choose Tier 1 for one-file or one-boundary local work
- choose Tier 2 for changed-area regression risk or multi-file work within one coherent boundary
- choose Tier 3 for cross-boundary, install, upgrade, uninstall, or shared workflow changes

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

## When `implement` Must Hand Off Here

- the claim needs Tier 2 `targeted` or Tier 3 `broad` evidence
- the change crosses files or behavior boundaries that need regression confidence
- install, update, uninstall, config, or shared workflow semantics changed
- completion would otherwise depend on broader proof than one local smoke check

## Process

1. Define the exact behavior, risk, or claim the validation is meant to cover.
2. Choose a validation tier and state why it matches the current risk and changed boundary.
3. Start from `templates/validation-report-template.md` for any non-trivial validation summary.
4. Run the smallest meaningful checks inside the chosen tier first.
5. For install, update, uninstall, config, or workflow changes, the default minimum evidence is a dry-run or rehearsal when available, readback of the changed file or installed artifact when relevant, verification of state or output shape when relevant, and uninstall or rollback impact when that surface changed.
6. Broaden validation only when the earlier evidence is weak, a higher-risk boundary is involved, or a previous check failed to prove the claim.
7. Capture the command, check, or manual step used as evidence, along with the expected signal and observed result.
8. State whether the gathered evidence is sufficient to support completion, or whether more validation or a handoff is still needed.
9. If validation fails, do not guess; hand off to `debug`.
10. If validation is limited by the environment, say exactly what could not be checked.
11. If stopping after non-trivial validation work, report what changed, what was validated, what was skipped, and any remaining risk.

## Guardrails

- do not skip meaningful validation without saying why
- do not broaden validation just for ceremony when narrower checks already provide enough signal
- do not describe tests as passing unless the command or check actually succeeded
- do not choose a broad validation tier without naming the risk that justified it
- record limits when full validation is not available
- do not stop after non-trivial validation without an explicit closeout summary

## Supporting Files

- read `references/validation-tiers.md` when you need help choosing the smallest sufficient validation depth
- use `templates/validation-report-template.md` as the default output shape for non-trivial validation
- read `references/example-validation-report.md` when the template alone is too abstract and you need a concrete filled example

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

The `Result` section should state whether the evidence is enough to support completion.

If validation stops here for non-trivial work, include a closeout summary covering what changed, what was validated, what was skipped, and remaining risk.

## Handoff Rules

- `test` -> `debug`
- `test` -> stop
