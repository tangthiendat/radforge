# Verify-Result Closing Patterns

Use this file when the main `SKILL.md` is not enough and you need stronger completion wording.

## Completion Summary Pattern

Use this order:

1. what changed
2. what was validated
3. what was skipped
4. what risk remains

Example:

```text
Changed:
- <specific files or behaviors>

Validated:
- <command or check> -> <result>

Skipped:
- <check not run> because <reason>

Remaining risk:
- <specific residual risk>
```

## Skipped Validation Wording

Be explicit and short.

Examples:

- `Full test suite not run because this workspace does not contain runnable project code.`
- `Build verification skipped because no build configuration exists in this repository.`

## Remaining Risk Wording

Keep risk concrete.

Examples:

- `The wording is in place, but real usage may show that some trigger descriptions need refinement.`
- `The structure is consistent, but it has not yet been exercised across several real tasks.`

## Completion Status Pattern

State the current end state explicitly.

Examples:

- `Complete: the requested change is in place and validated to the extent available here.`
- `Complete with remaining risk: the change is in place, but broader real-world usage may still reveal wording or trigger issues.`
- `Paused for approval: the work is ready for review before any high-impact follow-up action.`

## Approval Prompt Pattern

Use an approval prompt when a gate still applies.

Example:

```text
The change is implemented and verified to the extent possible here. Please review the summary above before I proceed with any high-impact follow-up action.
```
