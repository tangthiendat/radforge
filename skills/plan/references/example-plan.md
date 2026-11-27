# Example Execution Plan

Use this as a shape reference when the template feels too abstract. The scenario is invented for illustration.

## Goal

- outcome: let users move from an old script install to the skills CLI without ending up with duplicate skills
- success signal: after following the README steps in an isolated home folder, the old state folder is gone and each skill exists once

## Scope

In:

- README upgrade steps
- proving the upgrade path against a hand-built old-style install

Out:

- changes to the uninstall scripts' code
- new agents or new install options

Assumptions:

- old installs left a state file under `~/.radforge/providers/` and skill folders marked as Radforge-managed

## File Map

Create:

- none because the work only changes an existing doc

Modify:

- `README.md`

Validate:

- `sh scripts/uninstall.sh --home-root <temp-home>`
- `HOME=<temp-home> npx skills add <repo-root> -g --skill '*' -a claude-code -y`

Defer:

- `scripts/uninstall.ps1` runtime validation until PowerShell is available

## Tasks

### Task 1: Write the upgrade steps

Outcome:
README tells script users to uninstall first, then install with the skills CLI, and explains why both must not stay installed.

Files:

- `README.md`

Validation:
Read back the changed section and compare each command with the commands used in Task 2.

Expected signal:
Every command in the README appears in the validation checks, with the same flags.

If it fails:
Fix the README wording to match the command that works, not the other way round.

Checkpoint:
none

Risk:
low

### Task 2: Prove the upgrade path in an isolated home

Outcome:
Evidence that uninstall followed by a CLI install leaves one copy of each skill.

Files:

- none; this task only runs commands

Validation:
Create a temp home with a state file and a marked skill folder, run the uninstall script against it, then run the CLI install with `HOME` pointed at the same temp home. A dry-run preview is not evidence for this task; run the real commands against the temp home only.

Expected signal:
After uninstall, no `.radforge` folder and no marked skill folders remain. After the CLI install, each skill appears once.

If it fails:
Inspect which folders the uninstall script read from the state file before changing any README text.

Checkpoint:
pause if the uninstall script needs a code change; that is outside this plan's scope

Risk:
medium because the commands touch install locations, though only inside the temp home

## Validation Strategy

- ordered checks from narrowest to broadest:

  - run: read back the README section and compare its commands with the Task 2 commands
  - expected: the commands and flags match exactly
  - if it fails: correct the README before running anything

  - run: the uninstall and CLI install commands from Task 2 in the temp home
  - expected: one copy of each skill and no leftover state folder
  - if it fails: inspect the state file contents and the marker files first

- lowest useful validation first: yes, because the readback is cheap and catches wrong commands before they are run

## Risks And Approval Points

- the commands must never run against the real home folder; every command sets the temp home explicitly

## Finalization Decision

- Plan artifact required: yes, because the work spans documentation and runtime validation and may be resumed
- Final path: `docs/radforge/plans/<date>-script-to-cli-upgrade.md`
- Placeholder check complete: yes

## Next Handoff

- `implement`
