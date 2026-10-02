# <Validation Title>

Replace every placeholder before finalizing.
If a field is not needed, write `none` with a brief reason.

## Target

- original goal and acceptance criteria: <the authorized request and its completion conditions>
- validation scope: <checkpoint | whole request | validation-only request>
- plan/task position: <plan path and current task, or `none`>
- remaining work: <unfinished tasks and acceptance criteria, or `none`>
- constraints and authorization: <user limits, already approved scope, and any new gate>
- behavior or claim: <what this validation is proving>
- risk covered: <main regression or correctness risk>
- changed boundary: <one file, one component, install flow, cross-boundary workflow, etc.>

## Tier

- chosen tier: <Tier 1 smoke | Tier 2 targeted | Tier 3 broad>
- why this tier: <reason>
- why lower tiers were not enough: <reason or `not applicable`>

## Checks Run

### Check 1: <Name>

- command or action: <command or manual step>
- expected signal: <what success looks like>
- observed result: <what happened>

### Check 2: <Name>

- command or action: <command or manual step>
- expected signal: <what success looks like>
- observed result: <what happened>

## Result

- status: <pass | fail | partial>
- evidence sufficiency: <enough for the checkpoint | enough for the original request | not enough yet>
- summary: <one short conclusion>

## Closeout

- what changed: <short summary or `validation only`>
- what was validated: <what the checks proved>
- what was skipped: <what was not checked and why>
- remaining risk: <main confidence gap or `low`>
- completion state: <checkpoint validated; work continues | complete | complete with remaining risk | paused>

## Skipped Validation

- <what was skipped and why>

## Limits

- <environment limit, confidence gap, or "none">

## Next Handoff

- next skill: <`implement`, `debug`, or `stop`; stay in `test` if more evidence is needed>
- continuation: <next approved task with preserved task context, missing evidence, or reason for stopping>
