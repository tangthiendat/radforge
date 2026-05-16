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

$ScriptRoot = if ($PSScriptRoot) { $PSScriptRoot } else { $null }
$RepoRoot = if ($ScriptRoot) { Split-Path -Parent $ScriptRoot } else { $null }
$ProvidersRoot = if ($RepoRoot) { Join-Path $RepoRoot "providers" } else { $null }
$SkillsSourceRoot = if ($RepoRoot) { Join-Path $RepoRoot "skills" } else { $null }
$StateRoot = Join-Path $HomeRoot ".radforge"
$ProviderStateRoot = Join-Path $StateRoot "providers"

function Invoke-BootstrapInstall {
    $archiveUrl = if ($env:RADFORGE_ARCHIVE_URL) {
        $env:RADFORGE_ARCHIVE_URL
    }
    else {
        "https://github.com/tangthiendat/radforge/archive/refs/heads/main.zip"
    }

    $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("radforge-" + [guid]::NewGuid())
    $archivePath = Join-Path $tempRoot "radforge.zip"

    try {
        New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
        Invoke-WebRequest $archiveUrl -OutFile $archivePath
        Expand-Archive -LiteralPath $archivePath -DestinationPath $tempRoot

        $extractedRoot = Get-ChildItem -LiteralPath $tempRoot -Directory | Select-Object -First 1
        if (-not $extractedRoot) {
            throw "Unable to locate extracted Radforge archive."
        }

        $scriptPath = Join-Path $extractedRoot.FullName "scripts\install.ps1"
        if (-not (Test-Path -LiteralPath $scriptPath)) {
            throw "Unable to locate installer inside extracted Radforge archive."
        }

        & $scriptPath -Provider $Provider -HomeRoot $HomeRoot -DryRun:$DryRun
    }
    finally {
        if (Test-Path -LiteralPath $tempRoot) {
            Remove-Item -LiteralPath $tempRoot -Recurse -Force
        }
    }
}

if (-not $RepoRoot -or -not (Test-Path -LiteralPath $ProvidersRoot) -or -not (Test-Path -LiteralPath $SkillsSourceRoot)) {
    Invoke-BootstrapInstall
    return
}

function Write-Log {
    param([string]$Message)

    $prefix = if ($DryRun) { "[dry-run]" } else { "[radforge]" }
    Write-Host "$prefix $Message"
}

function Get-UtcTimestamp {
    (Get-Date).ToUniversalTime().ToString("o")
}

function Split-RelativePath {
    param([string]$RelativePath)

    $RelativePath -split "[\\/]" | Where-Object { $_ }
}

function Join-HomeRelativePath {
    param([string]$RelativePath)

    $path = $HomeRoot
    foreach ($segment in Split-RelativePath $RelativePath) {
        $path = Join-Path $path $segment
    }

    $path
}

function Ensure-Directory {
    param([string]$Path)

    if ($DryRun) {
        Write-Log "Would create directory '$Path'."
        return
    }

    New-Item -ItemType Directory -Path $Path -Force | Out-Null
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
    Ensure-Directory $parent

    if ($DryRun) {
        Write-Log "Would write file '$Path'."
        return
    }

    Set-Content -LiteralPath $Path -Value $Content -NoNewline
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

function Clear-LegacyManagedBlock {
    param([string]$FilePath)

    $existingContent = [string](Read-TextFile $FilePath)
    if ([string]::IsNullOrEmpty($existingContent)) {
        return ""
    }

    $pattern = [regex]::new("(?s)\r?\n?" + [regex]::Escape("<!-- RADFORGE:BEGIN -->") + ".*?" + [regex]::Escape("<!-- RADFORGE:END -->") + "\r?\n?")
    $updatedContent = $pattern.Replace($existingContent, "", 1)
    [regex]::Replace($updatedContent, "(\r?\n){3,}", [Environment]::NewLine + [Environment]::NewLine)
}

function Remove-LegacyHintFromState {
    param([string]$StatePath)

    if (-not (Test-Path -LiteralPath $StatePath)) {
        return
    }

    $providerState = Read-ProviderState $StatePath
    if (-not $providerState.ContainsKey("instructions_file")) {
        return
    }

    $instructionsFile = [string]$providerState.instructions_file
    if ([string]::IsNullOrWhiteSpace($instructionsFile) -or -not (Test-Path -LiteralPath $instructionsFile)) {
        return
    }

    $updatedInstructions = Clear-LegacyManagedBlock $instructionsFile
    $createdByInstaller = $providerState.ContainsKey("instructions_file_created") -and ([string]$providerState.instructions_file_created -eq "1")

    if ([string]::IsNullOrWhiteSpace($updatedInstructions)) {
        if ($createdByInstaller) {
            Remove-PathIfExists $instructionsFile
        }
        else {
            Write-TextFile -Path $instructionsFile -Content ""
        }
    }
    else {
        Write-TextFile -Path $instructionsFile -Content ($updatedInstructions.TrimEnd() + [Environment]::NewLine)
    }
}

function Get-AvailableProviderIds {
    Get-ChildItem -LiteralPath $ProvidersRoot -Directory | Select-Object -ExpandProperty Name | Sort-Object
}

function Get-SelectedProviderIds {
    $available = Get-AvailableProviderIds
    if ($Provider -contains "all") {
        return $available
    }

    $selected = New-Object System.Collections.Generic.List[string]
    foreach ($entry in $Provider) {
        foreach ($candidate in ($entry -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })) {
            if ($available -contains $candidate) {
                if (-not $selected.Contains($candidate)) {
                    $selected.Add($candidate)
                }
            }
            else {
                Write-Warning "Skipping unsupported provider '$candidate'."
            }
        }
    }

    $selected
}

function Load-ProviderManifest {
    param([string]$ProviderId)

    $manifestPath = Join-Path (Join-Path $ProvidersRoot $ProviderId) "manifest.json"
    (Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json -AsHashtable)
}

function Get-ProviderDisplayNames {
    param([string[]]$ProviderIds)

    @(
        foreach ($providerId in $ProviderIds) {
            (Load-ProviderManifest $providerId).displayName
        }
    )
}

function Copy-SkillLibrary {
    param([string]$DestinationRoot)

    Ensure-Directory $DestinationRoot

    $installedPaths = New-Object System.Collections.Generic.List[string]
    foreach ($skillDir in Get-ChildItem -LiteralPath $SkillsSourceRoot -Directory) {
        $skillFile = Join-Path $skillDir.FullName "SKILL.md"
        if (-not (Test-Path -LiteralPath $skillFile)) {
            continue
        }

        $destination = Join-Path $DestinationRoot $skillDir.Name
        if (Test-Path -LiteralPath $destination) {
            Remove-PathIfExists $destination
        }

        if ($DryRun) {
            Write-Log "Would copy skill '$($skillDir.FullName)' to '$destination'."
        }
        else {
            Copy-Item -LiteralPath $skillDir.FullName -Destination $destination -Recurse -Force
        }

        $installedPaths.Add($destination)
    }

    $installedPaths
}

function Write-ProviderState {
    param([hashtable]$Metadata)

    $statePath = Join-Path $ProviderStateRoot ($Metadata.provider + ".state")
    $content = @(
        "provider=$($Metadata.provider)"
        "display_name=$($Metadata.display_name)"
        "skills_dir=$($Metadata.skills_dir)"
        "installed_skill_dirs=$([string]::Join('|', $Metadata.installed_skill_dirs))"
        "installed_at_utc=$($Metadata.installed_at_utc)"
    ) -join [Environment]::NewLine

    Write-TextFile -Path $statePath -Content ($content + [Environment]::NewLine)
}

$selectedProviders = Get-SelectedProviderIds
if ($selectedProviders.Count -eq 0) {
    Write-Host "No supported providers selected."
    exit 0
}

if ($Provider -contains "all") {
    $detectedProviderNames = Get-ProviderDisplayNames $selectedProviders
    Write-Log "Detected providers: $($detectedProviderNames -join ', ')"
}

foreach ($providerId in $selectedProviders) {
    $providerStatePath = Join-Path $ProviderStateRoot ($providerId + ".state")
    Remove-LegacyHintFromState $providerStatePath

    $manifest = Load-ProviderManifest $providerId
    $skillsDir = Join-HomeRelativePath $manifest.skillsDir
    $installedSkillDirs = Copy-SkillLibrary -DestinationRoot $skillsDir

    Write-ProviderState -Metadata @{
        provider = $manifest.provider
        display_name = $manifest.displayName
        skills_dir = $skillsDir
        installed_skill_dirs = @($installedSkillDirs)
        installed_at_utc = Get-UtcTimestamp
    }

    Write-Log "Installed Radforge for $($manifest.displayName)."
}
