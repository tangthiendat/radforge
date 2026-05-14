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

## When Not To Use

- there is nothing meaningful to validate
- the task is still blocked on root-cause analysis and needs `debug` first

## Process

1. Confirm what behavior, change, or risk the validation is meant to cover.
2. Choose the narrowest meaningful validation first.
3. Run broader validation only when it adds real signal.
4. Read failures carefully before changing code.
5. Hand off to `debug` if validation fails.
6. Hand off to `verify-result` when validation is complete or when further validation is not meaningful in the current environment.

## Guardrails

- do not skip meaningful validation without saying why
- do not broaden validation just for ceremony when narrower checks already provide enough signal
- do not describe tests as passing unless the command was run successfully
- record limits when full validation is not available

## Output Contract

- intended validation target
- commands or checks run
- pass or fail results
- skipped validation and why
- validation limits or environment constraints
- relevant failure detail when applicable
- next-skill handoff

## Handoff Rules

- `test` -> `debug`
- `test` -> `verify-result`
