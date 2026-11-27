---
name: spec-writing
description: Use when approved or nearly approved direction needs a durable design artifact before planning or implementation.
maturity: core
kind: design
owner: radforge
lastReviewed: "2026-11-27"
compatibility: bootstrap routing and repo-local workflow contracts
---

# spec-writing

## Purpose

Produce a durable spec for design-heavy, approval-sensitive, or cross-cutting work before execution planning starts.

## When To Use

- the work needs a written spec in the repository's spec folder (default `docs/radforge/specs/`)
- the direction is mostly chosen but the design still needs to be made durable
- multiple files, components, or workflows will be affected and the design should be preserved before implementation
- approval depends on a concrete written design rather than a short brainstorming summary

## When Not To Use

- the direction is still unresolved and needs `brainstorming` first
- the main need is execution sequencing, checkpoints, or validation ordering, which belongs to `plan`
- the task is already clear enough for direct `implement`
- the work is only a README or small documentation wording change

## Shared Contract

Load the `use-radforge` skill's `references/workflow-contract.md` once per task, before other steps. Repository-local rules win on conflict. If the file is missing, say so and keep the approval, evidence, and closeout gates anyway.

## Process

1. Reconfirm the problem, scope, and current direction before writing the spec.
2. Inspect the relevant repository context, existing specs, plans, and nearby implementation surfaces.
3. Start from `templates/spec-template.md` for any non-trivial spec artifact.
4. Write the problem, goals, non-goals, constraints, and proposed design in concrete repository terms.
5. Capture alternatives only when there is a real tradeoff worth preserving for approval or later review.
6. Call out risks, open questions, migration concerns, and approval-sensitive decisions explicitly instead of burying them in prose.
7. Replace every placeholder with repository-specific content and save the artifact according to the rule below.
8. Read the saved artifact back and fix any remaining placeholders, contradictions, or drift from the agreed direction before asking for approval.
9. Pause for approval when the spec introduces approval-sensitive design, migration, compatibility, rollout, or workflow decisions. Present the saved path, or the chat-only spec, so the user approves the exact version that exists.
10. Record the approval response in the spec's approval status. If feedback changes a material decision, revise, save, read back, and request approval again; wording-only fixes do not reopen approval.
11. Name the expected next handoff clearly: usually `plan`, sometimes `implement`, or back to `brainstorming` if the design is not ready.

## Spec Finalization Rule

Write the spec as a file when any of the following are true:

- the work is design-heavy or cross-cutting
- the spec is approval-sensitive
- the design is intended for reuse, review, or handoff
- multiple files, components, or workflows are affected and the reasoning should be preserved
- the user asks for a written spec or names a path for it

Use a chat-only spec only when the scope is small, simple, and not worth a durable spec file.

Choose the location in this order:

1. the path the user names, used as given
2. the repository's existing spec folder
3. `docs/radforge/specs/`

## Guardrails

- do not use this skill while the direction is still too ambiguous for a stable design
- do not turn the spec into an execution plan with ordered implementation tasks
- do not skip non-goals or constraints when they materially shape the design
- do not keep alternatives just for ceremony when one direction is already settled
- do not request approval for a durable spec before it is saved and read back
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
Artifact Location
Next Handoff
```

Include in the sections above:

- the affected repository surface or design boundary
- the reason a durable spec is needed instead of going directly to `plan` or `implement`
- whether the artifact is finalized in the spec folder or intentionally kept chat-only
- whether the spec is ready for approval, planning, or further clarification

## Handoff Rules

- `spec-writing` -> `plan`
- `spec-writing` -> `implement`
- `spec-writing` -> `brainstorming`
- `spec-writing` -> stop
