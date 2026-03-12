[CmdletBinding(DefaultParameterSetName = "Text")]
param(
    [Parameter(Mandatory = $true, ParameterSetName = "Text")]
    [string]$PublicKey,

    [Parameter(Mandatory = $true, ParameterSetName = "File")]
    [string]$PublicKeyFile
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($PSCmdlet.ParameterSetName -eq "File") {
    if (-not (Test-Path $PublicKeyFile)) {
        throw "公開鍵ファイルが見つかりません: $PublicKeyFile"
    }
    $PublicKey = (Get-Content -Raw -Encoding UTF8 $PublicKeyFile).Trim()
}

if ($PublicKey -notmatch "^(ssh-ed25519|ssh-rsa|ecdsa-sha2-nistp256)\s+\S+") {
    throw "公開鍵の形式が不正です。"
}

$sshDir = Join-Path $HOME ".ssh"
$authorizedKeysPath = Join-Path $sshDir "authorized_keys"

if (-not (Test-Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
}

if (-not (Test-Path $authorizedKeysPath)) {
    New-Item -ItemType File -Path $authorizedKeysPath -Force | Out-Null
}

$existingKeys = Get-Content -Path $authorizedKeysPath -ErrorAction SilentlyContinue
if ($existingKeys -contains $PublicKey) {
    Write-Host "この公開鍵は既に登録済みです。"
    exit 0
}

Add-Content -Path $authorizedKeysPath -Value $PublicKey -Encoding UTF8
Write-Host "authorized_keys に公開鍵を追加しました: $authorizedKeysPath" -ForegroundColor Green
Write-Host "必要なら次を実行して権限を確認してください:"
Write-Host '  icacls "$HOME\.ssh"'
