# Radforge

Radforge is a reusable workflow and skills package for coding agents.

It installs a reusable skill library plus provider-level instructions so the agent knows when to route non-trivial work into a more structured workflow.

## Quickstart

Install Radforge directly from GitHub with a single command.

## Supported Providers

- Claude Code
- Codex
- OpenCode

## Install

### Windows PowerShell

```powershell
irm "https://raw.githubusercontent.com/tangthiendat/radforge/main/install.ps1" | iex
```

### macOS Or Linux

```sh
curl -fsSL https://raw.githubusercontent.com/tangthiendat/radforge/main/install.sh | bash
```

## Optional Install Flags

Install only specific providers:

```powershell
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/tangthiendat/radforge/main/install.ps1"))) -Provider codex,claude-code
```

```sh
curl -fsSL https://raw.githubusercontent.com/tangthiendat/radforge/main/install.sh | bash -s -- --provider codex,opencode
```

Preview changes without writing to disk:

```powershell
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/tangthiendat/radforge/main/install.ps1"))) -DryRun
```

```sh
curl -fsSL https://raw.githubusercontent.com/tangthiendat/radforge/main/install.sh | bash -s -- --dry-run
```

## Uninstall

### Windows PowerShell

```powershell
irm "https://raw.githubusercontent.com/tangthiendat/radforge/main/uninstall.ps1" | iex
```

### macOS Or Linux

```sh
curl -fsSL https://raw.githubusercontent.com/tangthiendat/radforge/main/uninstall.sh | bash
```

## How It Works

Radforge installs two main things into your AI tool setup:

- a Radforge-managed instructions block in the provider's user-level instructions file
- a shared skill library in the provider's user-level skills directory

The normal flow is:

1. install Radforge for one or more supported providers
2. start a task in your coding tool
3. the provider reads the installed instructions and skills
4. for non-trivial work, the agent should check whether Radforge applies before proceeding
5. if it applies, the agent invokes `use-radforge`
6. `use-radforge` routes into the right workflow skill for the task

The current instruction layer is modeled after the Superpowers approach: the installed instructions tell the agent to check for Radforge usage before acting on ambiguous, multi-step, failing, regression, design-heavy, or tradeoff-heavy tasks.

Small, clear, low-risk tasks can still run directly without forcing the full workflow.

Repository-local instructions still take priority over user-level Radforge defaults.

## What's Inside

### Workflow Skills

- `brainstorming`: clarifies goals and design before implementation
- `plan`: breaks multi-step work into an execution plan
- `implement`: carries out clear implementation tasks
- `test`: validates changes with meaningful checks
- `verify-result`: confirms what changed and what was verified
- `debug`: reproduces and isolates failures before fixing them

### Bootstrap Skill

- `use-radforge`: the entry skill that decides whether Radforge should take over and routes into the single right workflow skill

## What Gets Installed

For each selected provider, the installer:

- copies every skill from `skills/` into the provider's user-level skills directory
- writes a Radforge-managed instruction block into the provider's user-level instructions file
- installs `use-radforge` alongside the core workflow skills
- records uninstall metadata in `~/.radforge/providers/<provider>.state`

The installer is additive and conservative:

- it updates only the Radforge-managed block inside the instructions file
- it removes only Radforge-owned installed skill directories during uninstall
- it does not replace repository-local instructions

## Updating Radforge

If you change the Radforge templates or skill files in this repository, rerun the install script to refresh the installed instructions block and skill copies.

Examples:

```powershell
irm "https://raw.githubusercontent.com/tangthiendat/radforge/main/install.ps1" | iex
```

```sh
curl -fsSL https://raw.githubusercontent.com/tangthiendat/radforge/main/install.sh | bash
```

If you only want to preview what would happen, use dry-run mode.

## Notes

- when no provider is specified, the installer selects all supported providers in this repository and logs the detected provider names
- uninstall uses the stored provider state files in `~/.radforge/providers/` to remove only Radforge-managed assets
- actual skill auto-invocation still depends on the provider surfacing user instructions and installed skills to the model for that session
