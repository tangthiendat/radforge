param(
    [string[]]$Provider = @("all"),
    [string]$HomeRoot = $(if ($env:USERPROFILE) { $env:USERPROFILE } elseif ($HOME) { $HOME } else { throw "Unable to resolve user home directory." }),
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$ScriptRoot = if ($PSScriptRoot) { $PSScriptRoot } else { $null }
$RepoRoot = if ($ScriptRoot) { Split-Path -Parent $ScriptRoot } else { $null }
$ProvidersRoot = Join-Path $RepoRoot "providers"
$SkillsSourceRoot = Join-Path $RepoRoot "skills"
$StateRoot = Join-Path $HomeRoot ".radforge"
$ProviderStateRoot = Join-Path $StateRoot "providers"
$MarkerStart = "<!-- RADFORGE:BEGIN -->"
$MarkerEnd = "<!-- RADFORGE:END -->"
$EntrySkillName = "use-radforge"

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

        $scriptPath = Join-Path $tempRoot "radforge-main\scripts\install.ps1"
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
        return Get-Content -LiteralPath $Path -Raw
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

function Render-Template {
    param([hashtable]$Manifest)

    $templatePath = Join-Path $RepoRoot $Manifest.hintTemplate
    $content = Get-Content -LiteralPath $templatePath -Raw
    $content = $content.Replace("{{PROVIDER_NAME}}", [string]$Manifest.displayName)
    $content = $content.Replace("{{ENTRY_SKILL}}", $EntrySkillName)
    $content.TrimEnd()
}

function Set-ManagedBlock {
    param(
        [string]$FilePath,
        [string]$BlockContent
    )

    $existingContent = Read-TextFile $FilePath
    $createdFile = -not (Test-Path -LiteralPath $FilePath)
    $newline = [Environment]::NewLine
    $managedBlock = ($MarkerStart, $BlockContent.TrimEnd(), $MarkerEnd) -join $newline
    $updatedContent = $null

    if ($existingContent.Contains($MarkerStart) -and $existingContent.Contains($MarkerEnd)) {
        $pattern = [regex]::new("(?s)" + [regex]::Escape($MarkerStart) + ".*?" + [regex]::Escape($MarkerEnd))
        $updatedContent = $pattern.Replace($existingContent, $managedBlock, 1)
    }
    elseif ([string]::IsNullOrWhiteSpace($existingContent)) {
        $updatedContent = $managedBlock + $newline
    }
    else {
        $updatedContent = $existingContent.TrimEnd() + $newline + $newline + $managedBlock + $newline
    }

    Write-TextFile -Path $FilePath -Content $updatedContent

    @{
        InstructionsFileCreated = $createdFile
    }
}

function Copy-SkillLibrary {
    param([string]$DestinationRoot)

    Ensure-Directory $DestinationRoot

    $installedPaths = New-Object System.Collections.Generic.List[string]
    foreach ($skillDir in Get-ChildItem -LiteralPath $SkillsSourceRoot -Directory) {
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
        "instructions_file=$($Metadata.instructions_file)"
        "instructions_file_created=$($Metadata.instructions_file_created)"
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
    $manifest = Load-ProviderManifest $providerId
    $instructionsFile = Join-HomeRelativePath $manifest.instructionsFile
    $skillsDir = Join-HomeRelativePath $manifest.skillsDir
    $hintContent = Render-Template $manifest
    $blockResult = Set-ManagedBlock -FilePath $instructionsFile -BlockContent $hintContent
    $installedSkillDirs = Copy-SkillLibrary -DestinationRoot $skillsDir

    Write-ProviderState -Metadata @{
        provider = $manifest.provider
        display_name = $manifest.displayName
        instructions_file = $instructionsFile
        instructions_file_created = if ($blockResult.InstructionsFileCreated) { 1 } else { 0 }
        skills_dir = $skillsDir
        installed_skill_dirs = @($installedSkillDirs)
        installed_at_utc = Get-UtcTimestamp
    }

    Write-Log "Installed Radforge for $($manifest.displayName)."
}
