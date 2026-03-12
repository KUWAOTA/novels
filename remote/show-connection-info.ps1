Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Show-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "=== $Title ===" -ForegroundColor Cyan
}

Show-Section "LAN"
$lan = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Where-Object {
        $_.IPAddress -notlike "169.254.*" -and
        $_.IPAddress -ne "127.0.0.1" -and
        $_.IPAddress -notlike "192.168.91.*" -and
        $_.IPAddress -notlike "192.168.18.*"
    } |
    Sort-Object InterfaceMetric |
    Select-Object -ExpandProperty IPAddress -Unique

if (-not $lan) {
    $lan = ipconfig |
        Select-String "IPv4 Address" |
        ForEach-Object {
            if ($_ -match ":\s+([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)") {
                $matches[1]
            }
        } |
        Where-Object {
            $_ -and
            $_ -notlike "169.254.*" -and
            $_ -ne "127.0.0.1" -and
            $_ -notlike "192.168.91.*" -and
            $_ -notlike "192.168.18.*"
        } |
        Select-Object -Unique
}

if ($lan) {
    $lan | ForEach-Object { Write-Host ("LAN IPv4:    {0}" -f $_) }
} else {
    Write-Host "LAN IPv4:    not found" -ForegroundColor Yellow
}

Show-Section "SSH"
Write-Host ("User:        {0}" -f $env:USERNAME)
Write-Host "Port:        22"
if ($lan) {
    $lan | ForEach-Object { Write-Host ("Command:     ssh {0}@{1}" -f $env:USERNAME, $_) }
}

Show-Section "Tailscale"
$tailscaleExe = "C:\Program Files\Tailscale\tailscale.exe"
if (Test-Path -LiteralPath $tailscaleExe) {
    Write-Host ("Binary:      {0}" -f $tailscaleExe)
    Write-Host "Note:        sign in to Tailscale app, then use tailscale IP or MagicDNS"
} else {
    Write-Host "Binary:      not installed" -ForegroundColor Yellow
}
