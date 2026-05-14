param(
    [string[]]$Provider = @("all"),
    [string]$HomeRoot = $(if ($env:USERPROFILE) { $env:USERPROFILE } elseif ($HOME) { $HOME } else { throw "Unable to resolve user home directory." }),
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

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
