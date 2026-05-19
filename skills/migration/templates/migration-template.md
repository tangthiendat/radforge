# <Migration Title>

Replace every placeholder before finalizing.
If a field is not needed, write `none` with a brief reason.

## Migration Goal

- current path: <what exists today>
- target path: <what should exist after the migration>
- why the migration is needed now: <reason>

## Current State

- <important current behavior, compatibility promise, or dependency>

## Target State

- <intended end state>

## Compatibility Boundary

- must keep working: <old path, compatibility window, or `none`>
- can change immediately: <surface that may change now>
- can be removed later: <follow-up removal or `none`>
- support window or removal timing: <explicit timing, trigger, version, or `none`>

## Cutover Plan

- cutover trigger: <when the new path becomes primary>
- steps: <ordered transition summary>

## Rollback Path

- rollback availability: <full | partial | none>
- rollback method: <how to recover or why rollback is not possible>

## Validation Plan

- run: <command, check, or rehearsal>
- expected: <observable success>
- if it fails: <first thing to inspect>

## Open Questions

- <question or `none`>

## Approval Status

- status: <needed | requested | approved | not needed>
- gate: <approval-sensitive rollout, compatibility break, destructive change, or `none`>

## Artifact Location

- location: <docs/specs/<filename>.md | docs/plans/<filename>.md | chat-only>
- why this location is appropriate: <reason>

## Next Handoff

- `spec-writing`, `plan`, `implement`, `test`, or `stop`
