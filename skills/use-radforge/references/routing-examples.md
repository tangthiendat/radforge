# Routing Examples

Use this reference when a routing decision is borderline and a worked example helps. The routing precedence and heuristics stay in `SKILL.md`.

- direct: add one obvious sentence to an existing doc with no workflow implications
- `review`: inspect an existing change set for bugs, regressions, rollout risk, and missing validation before merge or release
- `review` borderline: the code already changed, and the user wants findings and confidence assessment rather than more implementation
- `brainstorming`: the request has two reasonable workflow designs and the approval boundary depends on which one is chosen
- `brainstorming` borderline: the work will likely need a plan later, but the design direction or scope split is still unresolved
- `spec-writing`: the direction is approved, but a substantial design still needs to be written to the spec folder before planning or implementation
- `spec-writing` borderline: the work is no longer ambiguous enough for `brainstorming`, but planning would be premature because the design choices still need a durable artifact
- `migration`: replace an old config or command path with a new one where the transition window, rollback, and removal timing need explicit handling
- `migration` borderline: the target design is already known, but jumping straight to `plan` would skip the compatibility boundary and cutover decision
- `implement`: tighten one existing skill file with a bounded wording change and one local readback check
- `implement` borderline: update one README install instruction and confirm it with one readback or one command run inside the same checkpoint
- `test`: implementation already happened and the remaining job is proving install behavior or regression coverage
- `test` borderline: the code change is done, but completion depends on broader install/update/uninstall proof or changed-area regression confidence
- `debug`: a repro, failing test, or broken command exists and diagnosis must come before edits
- `plan`: restructure the shared uninstall flow across the shell and PowerShell scripts, split a cross-repo workflow, or prepare a multi-phase handoff artifact
- `plan` borderline: the direction is already approved, but execution still needs ordered tasks, checkpoint boundaries, and validation sequencing before implementation should start
