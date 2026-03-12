Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = (& git rev-parse --show-toplevel).Trim()
$pidFile = Join-Path $repoRoot ".git/auto-commit/daemon.pid"

if (-not (Test-Path -LiteralPath $pidFile)) {
    Write-Host "Auto-commit is not running."
    exit 0
}

$pidRaw = Get-Content -LiteralPath $pidFile -Raw
if ([string]::IsNullOrWhiteSpace($pidRaw)) {
    Remove-Item -LiteralPath $pidFile -Force
    Write-Host "Removed stale PID file."
    exit 0
}

$processId = [int]$pidRaw.Trim()
try {
    Stop-Process -Id $processId -Force -ErrorAction Stop
    Write-Host "Stopped auto-commit daemon PID $processId."
}
catch {
    Write-Host "PID $processId was not running. Removed stale PID file."
}

if (Test-Path -LiteralPath $pidFile) {
    Remove-Item -LiteralPath $pidFile -Force
}
