param(
    [Parameter(Mandatory = $true)]
    [string]$PublicKey
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$authorizedKeys = Join-Path $HOME ".ssh\\authorized_keys"
$sshDir = Split-Path -Parent $authorizedKeys

if (-not (Test-Path -LiteralPath $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
}

if (-not (Test-Path -LiteralPath $authorizedKeys)) {
    New-Item -ItemType File -Path $authorizedKeys -Force | Out-Null
}

$normalizedKey = $PublicKey.Trim()
if ([string]::IsNullOrWhiteSpace($normalizedKey)) {
    throw "PublicKey is empty."
}

$existing = Get-Content -LiteralPath $authorizedKeys -ErrorAction SilentlyContinue
if ($existing -contains $normalizedKey) {
    Write-Host "Key already exists." -ForegroundColor Yellow
    exit 0
}

Add-Content -LiteralPath $authorizedKeys -Value $normalizedKey
Write-Host ("Added key to {0}" -f $authorizedKeys) -ForegroundColor Green
