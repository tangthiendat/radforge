# Example Validation Report

Use this as a filled example when the template alone is too abstract.

## Target

- original goal and acceptance criteria: validate the PowerShell install/uninstall path in an isolated temp home and report runtime evidence and limits
- validation scope: validation-only request
- plan/task position: none; standalone validation
- remaining work: POSIX shell runtime evidence remains outside this validation request
- constraints and authorization: validate PowerShell only; no implementation work authorized
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
- evidence sufficiency: enough for the original PowerShell validation request; does not establish POSIX shell behavior
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
- continuation: stop at the requested validation-only boundary; report the remaining shell evidence gap without starting implementation
