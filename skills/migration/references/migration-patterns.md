# Migration Patterns

Use this file when the main `SKILL.md` is not enough and you need stronger structure for compatibility, cutover, or rollback decisions.

## Migration Trigger Pattern

Prefer `migration` when the important question is not only how to build the new path, but how to move safely from the old path to the new one.

Common triggers:

- replacing a config shape or install behavior
- renaming or restructuring a user-facing path
- deprecating an old API, command, or workflow
- changing state shape or stored data expectations

Do not use `migration` when there is no meaningful transition boundary.

## Compatibility Boundary Pattern

State explicitly:

- what must keep working during the transition
- what can change immediately
- what is deferred for later removal

If the old path will stop working, say when and why.

## Cutover Pattern

Use this shape:

```text
Current: <old path>
Target: <new path>
Cutover: <when the new path becomes primary>
Removal: <when the old path can be removed>
```

## Rollback Pattern

Name the real rollback class:

- full rollback: the old path can be restored cleanly
- partial rollback: some recovery is possible, but not everything reverses
- no rollback: the change is destructive or one-way

Do not imply safe rollback if the state transition is irreversible.

## Approval Gate Pattern

Pause for approval when the migration affects:

- compatibility promises
- destructive removal timing
- irreversible state changes
- rollout behavior users will notice
- shared workflow semantics

## Output Checklist

Before handing off, confirm that you have:

- a clear current state and target state
- a stated compatibility boundary
- a cutover plan
- a real rollback note
- a validation plan
- open questions or assumptions when they still matter
- approval status
- a clear next handoff
