# Example Review Report

Use this as a shape reference when the template alone is too abstract.

## Scope

- reviewed surface: installer instruction-file overwrite behavior and related docs
- evidence used: scoped diff, install dry-run output, and README readback
- review boundary: `scripts/install.ps1`, `scripts/install.sh`, `README.md`

## Findings

### High

- `scripts/install.sh`: metadata capture can be corrupted because the helper both logs and returns structured stdout. If command substitution captures the log text, provider state content becomes invalid.

### Medium

- `README.md`: the overwrite flag is documented, but the earlier wording does not explain how an existing instruction file is left untouched in non-interactive runs.

## Open Questions

- was the shell installer run in an environment with live POSIX execution, or was the behavior only checked by code inspection?

## Residual Risk

- PowerShell evidence is strong, but shell runtime validation is still missing.

## Next Handoff

- `implement`
