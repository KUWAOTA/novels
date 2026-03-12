[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$sshdExe = Join-Path $env:WINDIR "System32\OpenSSH\sshd.exe"
$sshdService = Get-Service sshd -ErrorAction SilentlyContinue
$firewallRules = Get-NetFirewallRule -DisplayName "OpenSSH Server*" -ErrorAction SilentlyContinue
$ipLines = ipconfig | Select-String "IPv4 Address|IPv4 アドレス"

Write-Host "Remote access status" -ForegroundColor Cyan
Write-Host "  ssh client : $(if (Get-Command ssh -ErrorAction SilentlyContinue) { 'ok' } else { 'missing' })"
Write-Host "  sshd.exe   : $(if (Test-Path $sshdExe) { $sshdExe } else { 'missing' })"
Write-Host "  sshd svc   : $(if ($sshdService) { $sshdService.Status } else { 'missing' })"
Write-Host "  firewall   : $(if ($firewallRules) { 'configured' } else { 'not found' })"
Write-Host ""
Write-Host "IPv4 candidates:"
$ipLines | ForEach-Object { Write-Host "  $($_.Line.Trim())" }
