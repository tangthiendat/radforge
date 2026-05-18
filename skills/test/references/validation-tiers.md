# Validation Tiers

Use this reference when the main `SKILL.md` is not enough and you need a more explicit rule for how much validation to run.

## Tier 1: Smoke

Use when:

- the change is local and low-risk
- one command or one manual check can prove the claim
- the blast radius is narrow and obvious

Default boundary:

- one file or one very small workflow surface

Stop from `implement` with Tier 1 only when:

- one checkpoint and one coherent boundary were changed
- one high-signal check is enough to support the claim
- the work did not change install, update, uninstall, config, or shared workflow semantics

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

Typical handoff from `implement`:

- multi-file work inside one coherent boundary
- regression confidence is needed beyond one local smoke check
- one changed workflow path needs direct rehearsal

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

Default minimum evidence for install, update, uninstall, config, or shared workflow changes:

- a dry-run or rehearsal when available
- readback of the changed file, installed artifact, or generated output when relevant
- verification of state or output shape when relevant
- uninstall or rollback impact when that surface changed

## Escalation Rule

Start with the lowest tier that can plausibly prove the claim.

Move up one tier when:

- the previous tier leaves the important risk untested
- the changed boundary is wider than first assumed
- the result is ambiguous and needs stronger evidence

Before stopping, ask:

- is the evidence enough to support completion?
- if not, what narrower next check or handoff is still needed?
