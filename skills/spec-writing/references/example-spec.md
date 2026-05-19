# Example Spec

Use this as a shape reference when the template feels too abstract.

## Problem

- problem statement: provider installation behavior and workflow activation rules are drifting between scripts, README, and framework guidance
- affected surface: installer scripts, provider manifests, and workflow documentation
- why a spec is needed now: the changes affect multiple boundaries and need a durable design before further implementation and cleanup

## Goals

- align install behavior, activation wording, and provider metadata expectations
- preserve safe overwrite and ignore behavior for provider instruction files

## Non-Goals

- adding new provider adapters in this pass
- redesigning the full skills packaging model

## Constraints

- existing PowerShell and POSIX shell installers must stay supported
- repository-local instructions must continue to override provider-global instructions
- the current shipped workflow should remain lightweight for small tasks

## Proposed Design

- overview: keep provider-global instruction installation, keep bootstrap routing through `use-radforge`, and tighten repo docs plus manifest metadata around that model
- key decisions:
  - keep provider-global instructions as the installed baseline
  - preserve `use-radforge` as the workflow router for non-trivial work
  - document the current model explicitly before introducing larger packaging changes
- affected files or surfaces:
  - `global/AGENTS.md`
  - `AGENTS.md`
  - `README.md`
  - `providers/*/manifest.json`
  - `scripts/install.*`

## Alternatives

- considered option: return to pure bootstrap-only discovery
- why not chosen: it no longer matches the current installed behavior and would reintroduce activation drift

## Risks

- wording-only alignment can still leave metadata or packaging gaps if follow-up work is not planned

## Open Questions

- should future manifests grow `pack`, capability, or provider-constraint metadata?

## Approval Status

- status: ready for approval
- gate: confirm the current activation model should remain provider-global instructions plus bootstrap routing

## Next Handoff

- `plan`
