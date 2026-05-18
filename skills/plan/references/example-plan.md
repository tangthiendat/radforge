# Example Execution Plan

Use this as a shape reference when the template feels too abstract.

## Goal

- outcome: tighten installer cleanup behavior without changing supported providers
- success signal: reinstall removes legacy hint blocks and new install keeps only skill copies

## Scope

In:

- installer cleanup logic
- provider state handling
- README wording for migration behavior

Out:

- new providers
- desktop plugin support

Assumptions:

- existing provider state files may still contain legacy instruction metadata

## File Map

Create:

- none because the work only changes existing installer and docs files

Modify:

- `scripts/install.ps1`
- `scripts/install.sh`
- `README.md`

Validate:

- `pwsh -NoProfile -File "scripts/install.ps1" -DryRun`

Defer:

- `scripts/uninstall.sh` deeper runtime validation until shell execution is available

## Tasks

### Task 1: Remove legacy hint during reinstall

Outcome:
Reinstall strips the old managed hint block before writing refreshed provider state.

Files:

- `scripts/install.ps1`
- `scripts/install.sh`

Validation:
Run local dry-run and confirm legacy-cleanup path can execute without error.

Expected signal:
Dry-run reaches the legacy-cleanup path and completes provider-state writing without errors.

If it fails:
Inspect state parsing and legacy managed-block removal before widening scope.

Checkpoint:
pause if provider state format needs a breaking change

Risk:
medium because migration code touches existing installs

### Task 2: Sync migration wording

Outcome:
README accurately says reinstall can clean legacy hint blocks from older installs.

Files:

- `README.md`

Validation:
Read back changed section for wording drift or stale claims.

Expected signal:
README matches the current migration behavior without describing removed installer behavior.

If it fails:
Inspect the install, uninstall, and update sections for duplicated or conflicting wording.

Checkpoint:
none

Risk:
low

## Validation Strategy

- ordered checks from narrowest to broadest:

  - run: `pwsh -NoProfile -File "scripts/install.ps1" -DryRun`
  - expected: legacy-cleanup path and provider-state write path complete without error
  - if it fails: inspect state parsing and legacy cleanup before checking docs

  - run: read back changed `README.md` and script sections
  - expected: wording and migration behavior stay aligned with the edited code
  - if it fails: inspect duplicated or stale wording before widening validation

- lowest useful validation first: yes, because the local dry-run covers the risky migration path before broader shell validation

## Risks And Approval Points

- migration logic must not remove unrelated provider content

## Finalization Decision

- Plan artifact required: no
- Final path: chat only
- Placeholder check complete: yes

## Next Handoff

- `implement`
