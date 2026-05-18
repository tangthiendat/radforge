# Planning Reference Patterns

Use this file when the main `SKILL.md` is not enough and you need a stronger structure for execution planning.

## File Map Pattern

List files before tasks.

Use this shape:

```text
Create:
- path/to/new-file

Modify:
- path/to/existing-file

Validate:
- command or check that proves the phase worked
```

The file map locks in boundaries early and reduces drift while planning.

## Task Granularity Rule

Prefer tasks that are small enough to:

- touch one coherent unit of work
- be verified independently
- fail in an understandable way
- be resumed without re-reading the whole plan

If a task mixes setup, implementation, and wide verification, split it.

Each task should make the next checkpoint obvious to a new reader.

## Validation Planning Pattern

For each meaningful phase, define:

- the command or check to run
- what success looks like
- what failure would likely mean

For the overall validation strategy, list checks from narrowest to broadest.

Example:

```text
Run: <command>
Expected: <observable success>
If it fails: <first thing to inspect>
```

## Approval Point Pattern

Call for approval when a step crosses one of these boundaries:

- broad scope increase
- destructive or irreversible change
- commit or push request
- major design change discovered during planning

## Plan Split Signals

Split the work into separate plans, or pause for approval, when you see signs like:

- independent workstreams that can be built or validated separately
- different risk or approval boundaries between parts of the work
- one part depends on clarified design that another part does not
- the plan would become too large to execute or review as one coherent unit

## Plan Quality Checklist

Before handing off, confirm that the plan has:

- exact file paths
- a scope boundary or split decision
- an ordered task list
- meaningful validation steps
- expected signals and first failure interpretation for each meaningful validation step
- any unresolved assumptions that affect execution
- stated approval points
- approval status when a gate applied
- no placeholder language
