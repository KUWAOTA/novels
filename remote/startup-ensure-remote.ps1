Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$logPath = "C:\Users\ukowu\Desktop\novel\remote\startup-ensure-remote.log"

function Write-Log {
    param([string]$Message)
    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    Add-Content -LiteralPath $logPath -Value $line
}

function Ensure-ServiceRunning {
    param([string]$Name)

    $service = Get-Service -Name $Name -ErrorAction Stop
    if ($service.StartType -ne "Automatic") {
        Set-Service -Name $Name -StartupType Automatic
        Write-Log ("Set {0} startup type to Automatic" -f $Name)
    }

    if ($service.Status -ne "Running") {
        Start-Service -Name $Name
        Write-Log ("Started service {0}" -f $Name)
    } else {
        Write-Log ("Service {0} already running" -f $Name)
    }
}

New-Item -ItemType File -Path $logPath -Force | Out-Null
Write-Log "Startup remote bootstrap begin"

Start-Sleep -Seconds 10

Ensure-ServiceRunning -Name "sshd"
Ensure-ServiceRunning -Name "Tailscale"

Write-Log "Startup remote bootstrap complete"
