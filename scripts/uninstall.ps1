param(
    [string[]]$Provider = @("all"),
    [string]$HomeRoot = $(if ($env:USERPROFILE) { $env:USERPROFILE } elseif ($HOME) { $HOME } else { throw "Unable to resolve user home directory." }),
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($HomeRoot)) {
    $HomeRoot = [Environment]::GetFolderPath("UserProfile")
}

if ([string]::IsNullOrWhiteSpace($HomeRoot)) {
    throw "Unable to resolve user home directory."
}

$StateRoot = Join-Path $HomeRoot ".radforge"
$ProviderStateRoot = Join-Path $StateRoot "providers"
$MarkerStart = "<!-- RADFORGE:BEGIN -->"
$MarkerEnd = "<!-- RADFORGE:END -->"

function Write-Log {
    param([string]$Message)

    $prefix = if ($DryRun) { "[dry-run]" } else { "[radforge]" }
    Write-Host "$prefix $Message"
}

function Read-ProviderState {
    param([string]$StatePath)

    $result = @{}
    foreach ($line in (Get-Content -LiteralPath $StatePath)) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        $parts = $line -split "=", 2
        if ($parts.Count -eq 2) {
            $result[$parts[0]] = $parts[1]
        }
    }

    $result
}

function Remove-PathIfExists {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return
    }

    if ($DryRun) {
        Write-Log "Would remove '$Path'."
        return
    }

    Remove-Item -LiteralPath $Path -Recurse -Force
}

function Read-TextFile {
    param([string]$Path)

    if (Test-Path -LiteralPath $Path) {
        return [string](Get-Content -LiteralPath $Path -Raw)
    }

    ""
}

function Write-TextFile {
    param(
        [string]$Path,
        [string]$Content
    )

    $parent = Split-Path -Parent $Path
    if (-not $DryRun) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
        Set-Content -LiteralPath $Path -Value $Content -NoNewline
    }
    else {
        Write-Log "Would write file '$Path'."
    }
}

function Clear-ManagedBlock {
    param([string]$FilePath)

    $existingContent = [string](Read-TextFile $FilePath)
    if ([string]::IsNullOrEmpty($existingContent)) {
        return ""
    }

    $pattern = [regex]::new("(?s)\r?\n?" + [regex]::Escape($MarkerStart) + ".*?" + [regex]::Escape($MarkerEnd) + "\r?\n?")
    $updatedContent = $pattern.Replace($existingContent, "", 1)
    [regex]::Replace($updatedContent, "(\r?\n){3,}", [Environment]::NewLine + [Environment]::NewLine)
}

function Get-InstalledProviderStates {
    @(
        foreach ($statePath in Get-ChildItem -LiteralPath $ProviderStateRoot -Filter "*.state" -File) {
            Read-ProviderState $statePath.FullName
        }
    )
}

function Remove-EmptyStateDirectories {
    $hasProviderStates = (Test-Path -LiteralPath $ProviderStateRoot) -and ((Get-ChildItem -LiteralPath $ProviderStateRoot -Filter "*.state" -File).Count -gt 0)

    if (-not $hasProviderStates) {
        if (Test-Path -LiteralPath $ProviderStateRoot) {
            $remaining = Get-ChildItem -LiteralPath $ProviderStateRoot -Force
            if ($remaining.Count -eq 0) {
                Remove-PathIfExists $ProviderStateRoot
            }
        }
    }

    if (Test-Path -LiteralPath $StateRoot) {
        $remainingState = Get-ChildItem -LiteralPath $StateRoot -Force
        if ($remainingState.Count -eq 0) {
            Remove-PathIfExists $StateRoot
        }
    }
}

if (-not (Test-Path -LiteralPath $ProviderStateRoot)) {
    Write-Host "No Radforge provider state found."
    exit 0
}

$installedProviderStates = Get-InstalledProviderStates
$installedProviderIds = @($installedProviderStates | ForEach-Object { $_.provider })

$selectedProviders = if ($Provider -contains "all") {
    $installedProviderIds
}
else {
    $result = New-Object System.Collections.Generic.List[string]
    foreach ($entry in $Provider) {
        foreach ($candidate in ($entry -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
            if ($installedProviderIds -contains $candidate) {
                if (-not $result.Contains($candidate)) {
                    $result.Add($candidate)
                }
            }
            else {
                Write-Warning "Skipping provider '$candidate' because no install state was found."
            }
        }
    }

    $result
}

if ($Provider -contains "all") {
    $detectedProviderNames = @($installedProviderStates | ForEach-Object { $_.display_name })
    if ($detectedProviderNames.Count -gt 0) {
        Write-Log "Detected providers: $($detectedProviderNames -join ', ')"
    }
}

foreach ($providerId in $selectedProviders) {
    $providerStatePath = Join-Path $ProviderStateRoot ($providerId + ".state")
    if (-not (Test-Path -LiteralPath $providerStatePath)) {
        continue
    }

    $providerState = Read-ProviderState $providerStatePath
    $updatedInstructions = Clear-ManagedBlock $providerState.instructions_file
    $createdByInstaller = [bool][int]$providerState.instructions_file_created

    if ([string]::IsNullOrWhiteSpace($updatedInstructions)) {
        if ($createdByInstaller) {
            Remove-PathIfExists $providerState.instructions_file
        }
        elseif (Test-Path -LiteralPath $providerState.instructions_file) {
            Write-TextFile -Path $providerState.instructions_file -Content ""
        }
    }
    elseif (Test-Path -LiteralPath $providerState.instructions_file) {
        Write-TextFile -Path $providerState.instructions_file -Content ($updatedInstructions.TrimEnd() + [Environment]::NewLine)
    }

    foreach ($skillDir in ($providerState.installed_skill_dirs -split "\|" | Where-Object { $_ })) {
        Remove-PathIfExists $skillDir
    }

    Remove-PathIfExists $providerStatePath
    Write-Log "Uninstalled Radforge for $($providerState.display_name)."
}

Remove-EmptyStateDirectories
