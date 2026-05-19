---
name: spec-writing
description: Use when approved or nearly approved direction needs a durable design artifact before planning or implementation.
maturity: core
kind: design
owner: radforge
lastReviewed: "2026-05-19"
compatibility: provider-global instructions, bootstrap routing, and repo-local workflow contracts
---

# spec-writing

## Purpose

Produce a durable spec for design-heavy, approval-sensitive, or cross-cutting work before execution planning starts.

## When To Use

- the work needs a written spec in `docs/specs/`
- the direction is mostly chosen but the design still needs to be made durable
- multiple files, components, or workflows will be affected and the design should be preserved before implementation
- approval depends on a concrete written design rather than a short brainstorming summary

## When Not To Use

- the direction is still unresolved and needs `brainstorming` first
- the main need is execution sequencing, checkpoints, or validation ordering, which belongs to `plan`
- the task is already clear enough for direct `implement`
- the work is only a README or small documentation wording change

## Process

1. Reconfirm the problem, scope, and current direction before writing the spec.
2. Inspect the relevant repository context, existing specs, plans, and nearby implementation surfaces.
3. Start from `templates/spec-template.md` for any non-trivial spec artifact.
4. Write the problem, goals, non-goals, constraints, and proposed design in concrete repository terms.
5. Capture alternatives only when there is a real tradeoff worth preserving for approval or later review.
6. Call out risks, open questions, migration concerns, and approval-sensitive decisions explicitly instead of burying them in prose.
7. Name the expected next handoff clearly: usually `plan`, sometimes `implement`, or back to `brainstorming` if the design is not ready.
8. If the spec is the intended artifact, write it to `docs/specs/` and replace every placeholder with repository-specific content.

## Guardrails

- do not use this skill while the direction is still too ambiguous for a stable design
- do not turn the spec into an execution plan with ordered implementation tasks
- do not skip non-goals or constraints when they materially shape the design
- do not keep alternatives just for ceremony when one direction is already settled
- do not stop after non-trivial spec work without naming approval status and the next handoff

## Supporting Files

- use `templates/spec-template.md` as the default shape for non-trivial specs
- read `references/spec-patterns.md` when you need stronger design structure, tradeoff framing, or approval wording
- read `references/example-spec.md` when the template alone is too abstract

## Output Contract

Use this structure:

```text
Problem
Goals
Non-Goals
Constraints
Proposed Design
Alternatives
Risks
Open Questions
Approval Status
Next Handoff
```

Include in the sections above:

- the affected repository surface or design boundary
- the reason a durable spec is needed instead of going directly to `plan` or `implement`
- whether the spec is ready for approval, planning, or further clarification

## Handoff Rules

- `spec-writing` -> `plan`
- `spec-writing` -> `implement`
- `spec-writing` -> `brainstorming`
- `spec-writing` -> stop
