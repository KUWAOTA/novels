param(
    [int]$IntervalMinutes = 15,
    [string]$MessagePrefix = "auto: snapshot"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = (& git rev-parse --show-toplevel).Trim()
$stateDir = Join-Path $repoRoot ".git/auto-commit"
$pidFile = Join-Path $stateDir "daemon.pid"
$daemonScript = Join-Path $repoRoot ".workspace/ops/scripts/auto_commit_daemon.ps1"

if (Test-Path -LiteralPath $pidFile) {
    $existingPidRaw = Get-Content -LiteralPath $pidFile -Raw
    if (-not [string]::IsNullOrWhiteSpace($existingPidRaw)) {
        $existingPid = [int]$existingPidRaw.Trim()
        try {
            $null = Get-Process -Id $existingPid -ErrorAction Stop
            Write-Host "Auto-commit is already running with PID $existingPid."
            exit 0
        }
        catch {
        }
    }
}

$arguments = @(
    "-NoLogo"
    "-ExecutionPolicy", "Bypass"
    "-File", $daemonScript
    "-IntervalSeconds", ($IntervalMinutes * 60)
    "-MessagePrefix", $MessagePrefix
)

$process = Start-Process -FilePath "powershell.exe" -ArgumentList $arguments -WorkingDirectory $repoRoot -WindowStyle Minimized -PassThru
Write-Host "Started auto-commit daemon with PID $($process.Id)."
Write-Host "Log file: $stateDir\\daemon.log"
