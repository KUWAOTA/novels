param(
    [int]$RestartDelaySeconds = 5
)

$claudeCommand = Get-Command "claude.cmd" -ErrorAction SilentlyContinue
if (-not $claudeCommand) {
    $claudeCommand = Get-Command "claude" -ErrorAction SilentlyContinue
}

if (-not $claudeCommand) {
    Write-Error "The 'claude' command was not found in PATH."
    exit 1
}

Write-Host "=================================================="
Write-Host " Claude Remote Control Guard"
Write-Host " Press Ctrl + C to exit"
Write-Host "=================================================="

while ($true) {
    Write-Host ""
    Write-Host ("[{0}] Starting claude remote-control..." -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
    Write-Host "--------------------------------------------------"

    try {
        $output = & $claudeCommand.Source remote-control 2>&1
        if ($output) {
            $output | ForEach-Object { Write-Host $_ }
        }
        $exitCode = $LASTEXITCODE
        if ($null -eq $exitCode) {
            $exitCode = 0
        }
    }
    catch {
        Write-Host $_.Exception.Message -ForegroundColor Red
        $exitCode = 1
    }

    $outputText = if ($output) { ($output | Out-String) } else { "" }
    $authExpired = $outputText -match 'OAuth token has expired' -or $outputText -match 'Please use /login' -or $outputText -match 'Authentication failed \(401\)'

    Write-Host "--------------------------------------------------"
    Write-Host ("claude remote-control exited with code {0}." -f $exitCode)

    if ($authExpired) {
        Write-Host "Authentication for Claude Code is expired." -ForegroundColor Yellow
        Write-Host "Run 'claude.cmd auth login' in this directory, complete browser sign-in, then start this watchdog again." -ForegroundColor Yellow
        Write-Host "If this is the first run in this workspace, run 'claude.cmd' once and accept the workspace trust dialog before remote-control." -ForegroundColor Yellow
        break
    }

    Write-Host ("Restarting in {0} seconds..." -f $RestartDelaySeconds)
    Write-Host "--------------------------------------------------"
    Start-Sleep -Seconds $RestartDelaySeconds
}
