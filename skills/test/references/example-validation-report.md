# Example Validation Report

Use this as a filled example when the template alone is too abstract.

## Target

- behavior or claim: local PowerShell installer can complete a temp-home install without touching real user config
- risk covered: installer writes to the wrong place or misses skill copies
- changed boundary: install flow and provider state handling

## Tier

- chosen tier: Tier 3 broad
- why this tier: install behavior crosses multiple providers and shared user-level paths
- why lower tiers were not enough: a one-provider smoke check would not prove the multi-provider installer path

## Checks Run

### Check 1: Temp-home install smoke test

- command or action: run `pwsh -NoProfile -File "scripts/install.ps1" -HomeRoot <temp-home>`
- expected signal: installer logs detected providers, writes provider state, and copies the live skills into each provider path
- observed result: install completed for Claude Code, Codex, and OpenCode and all expected skills were present

### Check 2: Temp-home uninstall cleanup

- command or action: run `pwsh -NoProfile -File "scripts/uninstall.ps1" -HomeRoot <temp-home>`
- expected signal: provider state files are removed and Radforge-owned skill directories are gone
- observed result: uninstall removed provider state and no Radforge skill directories remained

## Result

- status: pass
- evidence sufficiency: enough to support completion of the PowerShell validation claim
- summary: the PowerShell install and uninstall path worked end-to-end against an isolated temp home

## Closeout

- what changed: installer path validation only
- what was validated: temp-home install, state writing, skill copying, uninstall cleanup
- what was skipped: POSIX shell execution in this session
- remaining risk: shell path still needs runtime execution
- completion state: complete with remaining risk

## Skipped Validation

- shell install and uninstall were not executed because the session only validated PowerShell

## Limits

- no CI run or cross-platform validation in this example

## Next Handoff

- `stop`
