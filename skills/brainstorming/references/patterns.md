# Brainstorming Reference Patterns

Use this file when the main `SKILL.md` is not enough and you need a stronger structure for discovery or alignment.

## Clarifying Question Ladder

Use one question at a time.

Typical order:

1. goal: what outcome does the user actually want?
2. scope: is this one task or several independent tasks?
3. constraints: what must be preserved or avoided?
4. success: what would make the user consider this done?

Prefer multiple-choice questions when the likely answer space is small.

## Approach Comparison Pattern

When multiple real options exist, compare them using the same shape:

- what it is
- why it fits
- tradeoffs
- recommendation level

Recommended response pattern:

```text
Option 1: <name>
- best when: <situation>
- upside: <main benefit>
- downside: <main cost>

Option 2: <name>
- best when: <situation>
- upside: <main benefit>
- downside: <main cost>

Recommendation: <option>
Why: <short reason>
```

## Approval Gate Wording

Use an explicit gate when design or tradeoffs matter.

Example:

```text
This is the direction I recommend because it keeps the workflow lighter while preserving approval and safety boundaries. If that looks right, I’ll move to the next skill.
```

## Scope Split Signals

Decompose the work before continuing when you see signs like:

- multiple unrelated subsystems
- different delivery timelines or stakeholders
- one part can be built independently from the rest
- the design would otherwise become too large for one spec or one plan

## Output Checklist

Before handing off, confirm that you have:

- a clear problem statement
- a scope boundary or decomposition decision
- constraints or assumptions
- success criteria
- a recommended direction and the key tradeoff behind it
- any unresolved assumptions or open questions
- approval status when a gate applied
- the next-skill handoff

Recommended status shape:

```text
Goal
Scope Boundary
Constraints
Options
Recommendation
Approval Status
Next Handoff
```

Keep options lightweight when there is only one realistic direction.
