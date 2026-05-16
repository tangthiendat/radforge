# Radforge

Radforge is a reusable workflow and skills package for coding agents.

It installs a reusable skill library so the agent can use Radforge workflow skills when they are available or when you ask for them explicitly.

## Quickstart

Install Radforge directly from GitHub with a single command.

## Supported Providers

Current installer support is for the CLI/provider user-level setup. Desktop apps and IDE extensions may also load these skills when they share the same provider skill system, but Radforge does not yet have dedicated desktop-app or IDE-extension installer targets.

- Claude Code
- Codex
- OpenCode

## Install

Choose the path that matches how you use the provider.

### CLI Users

Use the default install if you want Radforge available for the normal CLI/provider setup.

#### Install all supported providers

### Windows PowerShell

```powershell
irm "https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/install.ps1" | iex
```

### macOS Or Linux

```sh
curl -fsSL https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/install.sh | bash
```

The default install targets all supported providers.

#### Install specific providers

Available provider values:

- `claude-code`
- `codex`
- `opencode`

### Windows PowerShell

```powershell
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/install.ps1"))) -Provider codex,claude-code
```

### macOS Or Linux

```sh
curl -fsSL https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/install.sh | bash -s -- --provider codex,opencode
```

### Desktop App Or IDE Extension Users

If your desktop app or IDE extension uses the same provider skill system, install with an explicit provider value such as `codex`, `claude-code`, or `opencode`.

If the expected provider folders do not exist yet, the installer creates them.

#### Windows PowerShell

```powershell
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/install.ps1"))) -Provider codex
```

#### macOS Or Linux

```sh
curl -fsSL https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/install.sh | bash -s -- --provider codex
```

### Preview Changes Without Writing To Disk

### Windows PowerShell

```powershell
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/install.ps1"))) -DryRun
```

### macOS Or Linux

```sh
curl -fsSL https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/install.sh | bash -s -- --dry-run
```

## Uninstall

If you installed for a desktop app or IDE extension through a shared provider path, uninstall with the same explicit provider value you used during install.

### Uninstall all installed providers

### Windows PowerShell

```powershell
irm "https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/uninstall.ps1" | iex
```

### macOS Or Linux

```sh
curl -fsSL https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/uninstall.sh | bash
```

### Uninstall specific providers

Use the same provider values as install:

- `claude-code`
- `codex`
- `opencode`

### Windows PowerShell

```powershell
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/uninstall.ps1"))) -Provider codex,claude-code
```

### macOS Or Linux

```sh
curl -fsSL https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/uninstall.sh | bash -s -- --provider codex,opencode
```

## How It Works

Radforge installs one main thing into your AI tool setup:

- a shared skill library in the provider's user-level skills directory

The normal flow is:

1. install Radforge for one or more supported providers
2. start a task in your coding tool
3. if the provider exposes installed skills, the agent can discover `use-radforge`
4. if it does not route automatically, ask the agent to use `use-radforge`
5. `use-radforge` routes into the right workflow skill for the task

Small, clear, low-risk tasks can still run directly without forcing the full workflow.

Repository-local instructions still take priority over user-level Radforge defaults.

## What's Inside

### Workflow Skills

- `brainstorming`: clarifies goals and design before implementation
- `plan`: breaks multi-step work into an execution plan
- `implement`: carries out clear implementation tasks
- `test`: validates changes with meaningful checks
- `debug`: reproduces and isolates failures before fixing them

### Bootstrap Skill

- `use-radforge`: the entry skill that decides whether Radforge should take over and routes into the single right workflow skill

### Workflow Closeout

- once Radforge workflow is in use, non-trivial work should report what changed, what was validated, what was skipped, and any remaining risk

## What Gets Installed

For each selected provider, the installer:

- copies every skill from `skills/` into the provider's user-level skills directory
- installs `use-radforge` alongside the core workflow skills
- records uninstall metadata in `~/.radforge/providers/<provider>.state`

The installer is additive and conservative:

- it removes only Radforge-owned installed skill directories during uninstall
- it can clean up legacy provider hint blocks from older installs when you reinstall
- it does not replace repository-local instructions

## Updating Radforge

Rerun install to refresh the installed skill copies.

If you installed with an explicit provider value, especially for a desktop app or IDE extension that shares a provider path, rerun install with the same explicit provider value.

If you are updating from an older version that used provider-global hints, rerun install once to remove the legacy hint blocks.

### Windows PowerShell

```powershell
irm "https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/install.ps1" | iex
```

### macOS Or Linux

```sh
curl -fsSL https://raw.githubusercontent.com/tangthiendat/radforge/main/scripts/install.sh | bash
```

If you want to preview an update first, use the dry-run commands from the install section.

## Notes

- when no provider is specified, the installer selects all supported providers in this repository and logs the detected provider names
- uninstall uses the stored provider state files in `~/.radforge/providers/` to remove only Radforge-managed assets
- actual skill auto-invocation still depends on the provider surfacing installed skills to the model for that session
