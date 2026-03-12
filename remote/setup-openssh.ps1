Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Assert-Admin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw "Please run this script from an elevated PowerShell window."
    }
}

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host ("== {0} ==" -f $Message) -ForegroundColor Cyan
}

Assert-Admin

$capabilityName = "OpenSSH.Server~~~~0.0.1.0"
$firewallRuleName = "sshd-novel"
$userAuthorizedKeys = Join-Path $HOME ".ssh\\authorized_keys"
$adminAuthorizedKeys = Join-Path $env:ProgramData "ssh\\administrators_authorized_keys"

Write-Step "OpenSSH Server"
$capability = Get-WindowsCapability -Online -Name $capabilityName
if ($capability.State -ne "Installed") {
    Add-WindowsCapability -Online -Name $capabilityName | Out-Null
    Write-Host "Installed OpenSSH Server." -ForegroundColor Green
} else {
    Write-Host "OpenSSH Server is already installed." -ForegroundColor Green
}

Write-Step "sshd service"
Set-Service -Name "sshd" -StartupType Automatic
Start-Service -Name "sshd"
$service = Get-Service -Name "sshd"
Write-Host ("Status: {0}" -f $service.Status) -ForegroundColor Green

Write-Step "Firewall"
$existingRule = Get-NetFirewallRule -Name $firewallRuleName -ErrorAction SilentlyContinue
if ($null -eq $existingRule) {
    New-NetFirewallRule `
        -Name $firewallRuleName `
        -DisplayName "OpenSSH Server (novel)" `
        -Enabled True `
        -Direction Inbound `
        -Protocol TCP `
        -Action Allow `
        -LocalPort 22 | Out-Null
    Write-Host "Added Windows Firewall rule for TCP 22." -ForegroundColor Green
} else {
    Enable-NetFirewallRule -Name $firewallRuleName | Out-Null
    Write-Host "Enabled existing Firewall rule." -ForegroundColor Green
}

Write-Step "authorized_keys"
New-Item -ItemType Directory -Force -Path (Split-Path $userAuthorizedKeys) | Out-Null
if (-not (Test-Path -LiteralPath $userAuthorizedKeys)) {
    New-Item -ItemType File -Path $userAuthorizedKeys | Out-Null
    Write-Host ("Created: {0}" -f $userAuthorizedKeys) -ForegroundColor Green
} else {
    Write-Host ("Exists: {0}" -f $userAuthorizedKeys) -ForegroundColor Green
}

Write-Host ""
Write-Host "Setup complete. Next steps:" -ForegroundColor Cyan
Write-Host ("1. Append your phone public key to {0}" -f $userAuthorizedKeys)
Write-Host ("2. If needed, also review {0}" -f $adminAuthorizedKeys)
Write-Host "3. Install Tailscale on both the PC and the phone"
Write-Host "4. Run remote\\check-mobile-access.ps1"
