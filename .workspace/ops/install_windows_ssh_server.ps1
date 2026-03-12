[CmdletBinding()]
param(
    [string]$AllowedUser = $env:USERNAME,
    [string]$WorkspacePath = "C:\Users\$env:USERNAME\Desktop\novel",
    [int]$Port = 22
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

if (-not (Test-IsAdministrator)) {
    Write-Error "管理者として PowerShell を開き、このスクリプトを再実行してください。"
    exit 1
}

$capability = Get-WindowsCapability -Online | Where-Object { $_.Name -like "OpenSSH.Server*" } | Select-Object -First 1
if (-not $capability) {
    throw "OpenSSH Server capability が見つかりませんでした。"
}

if ($capability.State -ne "Installed") {
    Write-Step "OpenSSH Server をインストール"
    Add-WindowsCapability -Online -Name $capability.Name | Out-Null
} else {
    Write-Step "OpenSSH Server は既にインストール済み"
}

$sshdExe = Join-Path $env:WINDIR "System32\OpenSSH\sshd.exe"
if (-not (Test-Path $sshdExe)) {
    throw "sshd.exe が見つかりません: $sshdExe"
}

$configPath = "C:\ProgramData\ssh\sshd_config"
$configDir = Split-Path -Parent $configPath
if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null
}

if (-not (Test-Path $configPath)) {
    & $sshdExe -f $configPath -t 2>$null
    if (-not (Test-Path $configPath)) {
        New-Item -ItemType File -Path $configPath -Force | Out-Null
    }
}

$startMarker = "# >>> novel remote managed block >>>"
$endMarker = "# <<< novel remote managed block <<<"
$managedBlock = @"
$startMarker
Port $Port
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitEmptyPasswords no
AllowUsers $AllowedUser
AllowTcpForwarding yes
X11Forwarding no
$endMarker
"@

$existingConfig = if (Test-Path $configPath) { Get-Content -Raw -Encoding UTF8 $configPath } else { "" }
if ($existingConfig -match [regex]::Escape($startMarker)) {
    $pattern = "(?s)$([regex]::Escape($startMarker)).*?$([regex]::Escape($endMarker))"
    $updatedConfig = [regex]::Replace($existingConfig, $pattern, $managedBlock.TrimEnd())
} else {
    $updatedConfig = ($existingConfig.TrimEnd() + "`r`n`r`n" + $managedBlock.TrimEnd()).Trim() + "`r`n"
}
Set-Content -Path $configPath -Value $updatedConfig -Encoding UTF8

Write-Step "既定シェルを PowerShell に設定"
$openSshReg = "HKLM:\SOFTWARE\OpenSSH"
if (-not (Test-Path $openSshReg)) {
    New-Item -Path $openSshReg -Force | Out-Null
}
New-ItemProperty -Path $openSshReg -Name DefaultShell -Value "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force | Out-Null

Write-Step "サービス起動と自動起動化"
Set-Service -Name sshd -StartupType Automatic
Start-Service -Name sshd

$ruleName = "OpenSSH Server ($Port)"
$existingRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
if (-not $existingRule) {
    Write-Step "Windows Firewall で SSH を開放"
    New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Action Allow -Protocol TCP -LocalPort $Port | Out-Null
} else {
    Write-Step "Windows Firewall ルールは既に存在"
}

Write-Step "設定検証"
& $sshdExe -t

$ipLines = ipconfig | Select-String "IPv4 Address|IPv4 アドレス"
$workspaceExists = Test-Path $WorkspacePath

Write-Host ""
Write-Host "SSH サーバー設定が完了しました。" -ForegroundColor Green
Write-Host "接続ユーザー: $AllowedUser"
Write-Host "ポート: $Port"
Write-Host "ワークスペース: $WorkspacePath"
Write-Host "ワークスペース存在: $workspaceExists"
Write-Host ""
Write-Host "候補IP:"
$ipLines | ForEach-Object { Write-Host "  $($_.Line.Trim())" }
Write-Host ""
Write-Host "次の手順:"
Write-Host "  1. 通常ユーザーで .workspace\\ops\\install_ssh_login_profile.ps1 を実行"
Write-Host "  2. スマホ側で ed25519 鍵を作成"
Write-Host "  3. 公開鍵を .workspace\\ops\\add_authorized_key.ps1 で登録"
Write-Host "  4. 同一Wi-Fi または Tailscale 経由で ssh $AllowedUser@<IP> で接続"
