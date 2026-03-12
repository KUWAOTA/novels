[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspace = "C:\Users\$env:USERNAME\Desktop\novel"
if (-not (Test-Path $workspace)) {
    throw "ワークスペースが見つかりません: $workspace"
}

Set-Location $workspace

Write-Host ""
Write-Host "novel remote shell" -ForegroundColor Cyan
Write-Host "cwd: $workspace"
Write-Host ""
Write-Host "よく使うコマンド:"
Write-Host "  codex.cmd"
Write-Host "  claude.cmd"
Write-Host "  .\\.workspace\\ops\\auto_claude.bat"
Write-Host "  git status"
Write-Host ""
