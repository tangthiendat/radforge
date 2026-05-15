Radforge is installed for `{{PROVIDER_NAME}}` on this machine.

Shared Radforge runtime rules live at `~/.radforge/AGENTS.md`.

Before acting on a task, first check whether a Radforge skill should be used.

For ambiguous, multi-step, failing, regression, design-heavy, or tradeoff-heavy tasks, invoke `{{ENTRY_SKILL}}` before proceeding. Treat this as the default workflow for non-trivial work unless repository-local instructions clearly require another process.

When Radforge applies, follow the shared runtime rules in `~/.radforge/AGENTS.md` together with the installed skills.

For small, clear, low-risk tasks, direct execution is fine.

Repository-local instructions such as `AGENTS.md` or `CLAUDE.md` take priority over the shared Radforge rules and personal defaults.
