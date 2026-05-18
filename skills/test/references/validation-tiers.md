# Validation Tiers

Use this reference when the main `SKILL.md` is not enough and you need a more explicit rule for how much validation to run.

## Tier 1: Smoke

Use when:

- the change is local and low-risk
- one command or one manual check can prove the claim
- the blast radius is narrow and obvious

Default boundary:

- one file or one very small workflow surface

Typical evidence:

- one focused test command
- one lint or build check for the changed file or package
- one manual confirmation for a very small UX or workflow change

## Tier 2: Targeted

Use when:

- regression risk exists in the changed area
- the change touches more than one file in one coherent boundary
- one smoke check is too weak to prove the behavior

Default boundary:

- one component, one feature slice, or one install or workflow path

Typical evidence:

- targeted test subset plus one supporting command
- a focused install or workflow rehearsal for changed scripts
- a direct before-and-after repro check

## Tier 3: Broad

Use when:

- the change crosses boundaries or affects shared workflow behavior
- install, upgrade, or uninstall semantics changed
- failure would be expensive or confusing for users

Default boundary:

- multiple components, multiple workflows, or shared user-facing infrastructure

Typical evidence:

- multiple commands across the changed surface
- end-to-end or multi-phase workflow rehearsal
- targeted manual checks plus scripted checks

## Escalation Rule

Start with the lowest tier that can plausibly prove the claim.

Move up one tier when:

- the previous tier leaves the important risk untested
- the changed boundary is wider than first assumed
- the result is ambiguous and needs stronger evidence
