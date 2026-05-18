# <Validation Title>

Replace every placeholder before finalizing.
If a field is not needed, write `none` with a brief reason.

## Target

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
- summary: <one short conclusion>

## Closeout

- what changed: <short summary or `validation only`>
- what was validated: <what the checks proved>
- what was skipped: <what was not checked and why>
- remaining risk: <main confidence gap or `low`>
- completion state: <complete | complete with remaining risk | paused>

## Skipped Validation

- <what was skipped and why>

## Limits

- <environment limit, confidence gap, or "none">

## Next Handoff

- `debug` or `stop`
