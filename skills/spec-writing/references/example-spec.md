# Example Spec

Use this as a shape reference when the template feels too abstract. The scenario is invented for illustration.

## Problem

- problem statement: install locations and upgrade guidance differ between a legacy script installer, a third-party skills CLI, and the README, so users can end up with duplicate or missing skills
- affected surface: README install and upgrade guidance, the uninstall scripts, and the repository layout notes in `AGENTS.md`
- why a spec is needed now: the change affects how every user installs and upgrades and needs a durable design before documentation and scripts are edited

## Goals

- one supported install path for all agents
- a clear upgrade path for users of the legacy installer

## Non-Goals

- building a custom installer or CLI
- adding per-agent metadata to this repository

## Constraints

- the install tool needs a modern Node.js runtime
- uninstall scripts must keep working for installs made by earlier releases
- repository-local instructions must continue to override user-level Radforge workflow defaults

## Proposed Design

- overview: install through the skills CLI only, keep the uninstall scripts for one release window, and document the upgrade as "uninstall, then install"
- key decisions:
  - drop the legacy install scripts and provider metadata rather than maintaining two install paths
  - keep uninstall scripts so old installs can be removed
- affected files or surfaces:
  - `README.md`
  - `AGENTS.md`
  - `scripts/uninstall.*`

## Alternatives

- considered option: keep the legacy installer as a fallback for users without Node.js
- why not chosen: it doubles maintenance, and its per-agent install paths can drift from where the CLI installs

## Risks

- users without Node.js lose their install path

## Open Questions

- when should the uninstall scripts themselves be removed?

## Approval Status

- status: ready for approval
- gate: confirm that dropping the no-Node.js install path is acceptable

## Artifact Location

- location: `docs/radforge/specs/<filename>.md`
- why this location is appropriate: the design changes the install path for every user and should remain reviewable after implementation starts

## Next Handoff

- `plan`
