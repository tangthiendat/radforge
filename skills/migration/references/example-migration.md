# Example Migration Note

Use this as a shape reference when the template feels too abstract.

## Migration Goal

- current path: provider installs still rely on the old command name `old-sync`
- target path: installs use `radforge sync` as the only supported command
- why the migration is needed now: command naming is being unified before wider provider rollout

## Current State

- docs, scripts, and existing user habits still reference `old-sync`
- some repos may still follow the older command in internal setup notes

## Target State

- `radforge sync` becomes the primary command everywhere
- `old-sync` is treated as deprecated and later removed

## Compatibility Boundary

- must keep working: `old-sync` must still be recognized during the transition window
- can change immediately: docs and new examples can point to `radforge sync`
- can be removed later: legacy alias support after the transition window
- support window or removal timing: remove the alias after one release if install and support docs show no remaining dependency

## Cutover Plan

- cutover trigger: release of the unified command plus updated install docs
- steps: update docs and scripts first, keep alias support temporarily, remove legacy path in a follow-up release

## Rollback Path

- rollback availability: partial
- rollback method: docs and aliases can be restored quickly, but any user automation already changed to the new command will not roll back automatically

## Validation Plan

- run: installer dry-run plus readback of command references in docs and scripts
- expected: only the new command is documented as primary and legacy support remains where promised
- if it fails: inspect compatibility references and the temporary alias path first

## Open Questions

- whether the transition window needs one release or two

## Approval Status

- status: needed
- gate: user-visible command transition and later removal timing

## Artifact Location

- location: `docs/plans/<filename>.md`
- why this location is appropriate: the target command is already known and the remaining value is preserving the transition sequence and validation steps

## Next Handoff

- `plan`
