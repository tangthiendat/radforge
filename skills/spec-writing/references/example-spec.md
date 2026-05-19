# Example Spec

Use this as a shape reference when the template feels too abstract.

## Problem

- problem statement: provider installation behavior and workflow activation rules are drifting between scripts, README, and framework guidance
- affected surface: installer scripts, provider manifests, and workflow documentation
- why a spec is needed now: the changes affect multiple boundaries and need a durable design before further implementation and cleanup

## Goals

- align install behavior, activation wording, and provider metadata expectations
- keep install behavior focused on skill distribution and bootstrap routing

## Non-Goals

- adding new provider adapters in this pass
- redesigning the full skills packaging model

## Constraints

- existing PowerShell and POSIX shell installers must stay supported
- repository-local instructions must continue to override user-level Radforge workflow defaults
- the current shipped workflow should remain lightweight for small tasks

## Proposed Design

- overview: keep bootstrap routing through `use-radforge`, simplify install behavior around skill distribution only, and tighten repo docs plus manifest metadata around that model
- key decisions:
  - preserve `use-radforge` as the workflow router for non-trivial work
  - document the current model explicitly before introducing larger packaging changes
- affected files or surfaces:
  - `AGENTS.md`
  - `README.md`
  - `providers/*/manifest.json`
  - `scripts/install.*`

## Alternatives

- considered option: reintroduce provider-global instructions as the installed baseline
- why not chosen: it adds install and uninstall complexity that is not needed for the current bootstrap-routing model

## Risks

- wording-only alignment can still leave metadata or packaging gaps if follow-up work is not planned

## Open Questions

- should future manifests grow `pack`, capability, or provider-constraint metadata?

## Approval Status

- status: ready for approval
- gate: confirm the current activation model should remain bootstrap routing without provider-global instruction installation

## Next Handoff

- `plan`
