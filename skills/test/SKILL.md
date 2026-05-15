---
name: test
description: Use when there is meaningful behavior or regression risk to validate. Choose the smallest useful checks, run them, and capture fresh evidence.
---

# test

## Purpose

Validate behavior changes and capture evidence.

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
2. Choose the narrowest meaningful validation first.
3. Run broader validation only when it adds real signal.
4. Capture the command, check, or manual step used as evidence.
5. If validation fails, do not guess; hand off to `debug`.
6. If validation is limited by the environment, say exactly what could not be checked.

## Guardrails

- do not skip meaningful validation without saying why
- do not broaden validation just for ceremony when narrower checks already provide enough signal
- do not describe tests as passing unless the command or check actually succeeded
- record limits when full validation is not available

## Output Contract

- intended validation target
- commands or checks run
- pass or fail results
- skipped validation and why
- validation limits or environment constraints
- relevant failure detail when applicable
- next-skill handoff or stop state

## Handoff Rules

- `test` -> `debug`
- `test` -> stop
