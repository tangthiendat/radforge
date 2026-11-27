# Example Review Report

Use this as a shape reference when the template alone is too abstract. The change under review and the findings are invented to show the format; they do not describe this repository.

## Scope

- reviewed surface: a hypothetical README change that adds upgrade steps for users moving from script installs to the skills CLI
- evidence used: scoped diff and README readback
- review boundary: `README.md`

## Findings

### High

- `README.md`: the upgrade steps tell users to run the CLI install first and the uninstall second. The uninstall script removes folders recorded in the old state file, which can include folders the CLI install just refreshed, so a user can end up with no skills after following the steps in this order.

### Medium

- `README.md`: the text says to avoid using both install methods but does not say which folders the two methods write to, so a user cannot tell whether they currently have both.

## Open Questions

- was the upgrade order run against a real old-style install, or only reasoned from the script source?

## Residual Risk

- POSIX uninstall behavior is covered by the diff reading only; PowerShell uninstall behavior has no runtime evidence.

## Next Handoff

- `implement`
