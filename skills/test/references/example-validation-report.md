# Example Validation Report

Use this as a filled example when the template alone is too abstract. The scenario and the observed results are invented for illustration; they are not a record of a real run.

## Target

- original goal and acceptance criteria: validate the skills CLI install and the POSIX uninstall script in an isolated temp home and report runtime evidence and limits
- validation scope: validation-only request
- plan/task position: none; standalone validation
- remaining work: PowerShell uninstall runtime evidence remains outside this validation request
- constraints and authorization: validate the CLI install and `scripts/uninstall.sh` only; no implementation work authorized
- behavior or claim: the CLI installs every skill once, and the uninstall script removes an old script-style install, without touching the real home folder
- risk covered: install or uninstall writes to the wrong place, misses skills, or leaves state behind
- changed boundary: install path moved to the skills CLI; uninstall scripts kept for old installs

## Tier

- chosen tier: Tier 3 broad
- why this tier: the claim crosses two tools, several agents, and shared user-level paths
- why lower tiers were not enough: a single-agent smoke check would not show the shared folder and the symlinked agent folder behaving together

## Checks Run

### Check 1: Temp-home CLI install

- command or action: run `HOME=<temp-home> DISABLE_TELEMETRY=1 npx skills add <repo-root> -g --skill '*' -a claude-code -a codex -y`
- expected signal: nine skills appear once in `<temp-home>/.agents/skills`, and `<temp-home>/.claude/skills` holds links to them
- observed result: the command exited 0; nine skill folders were present in the shared folder and nine links in the Claude Code folder

### Check 2: Temp-home uninstall of an old install

- command or action: build an old-style install in a second temp home (a state file plus one Radforge-marked skill folder), then run `sh scripts/uninstall.sh --home-root <temp-home>`
- expected signal: the marked skill folder and the state folder are removed, and an unrelated user skill folder is left alone
- observed result: the command exited 0; the marked folder and the state folder were gone and the user folder remained

## Result

- status: pass
- evidence sufficiency: enough for the original request; it does not establish PowerShell uninstall behavior or behavior in real agent applications
- summary: the CLI install and the POSIX uninstall worked against isolated temp homes

## Closeout

- what changed: nothing; validation only
- what was validated: CLI install into the shared and linked folders, POSIX uninstall of an old-style install, and preservation of an unrelated skill folder
- what was skipped: PowerShell uninstall and live agent loading
- remaining risk: the PowerShell uninstall path and each agent's actual loading of the skills are unproven
- completion state: complete with remaining risk

## Skipped Validation

- `scripts/uninstall.ps1` was not executed because PowerShell was not available in this session
- a dry-run preview was not counted as evidence of any write

## Limits

- no CI run or cross-platform validation in this example
- the results above are invented to show the report shape

## Next Handoff

- `stop`
- continuation: stop at the requested validation-only boundary; report the remaining PowerShell evidence gap without starting implementation
- optional review: not applicable; this was a validation-only request
