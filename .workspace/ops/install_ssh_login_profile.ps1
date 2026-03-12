[CmdletBinding()]
param(
    [string]$WorkspacePath = "C:\Users\$env:USERNAME\Desktop\novel"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$profilePath = $PROFILE.CurrentUserAllHosts
$profileDir = Split-Path -Parent $profilePath

if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$startMarker = "# >>> novel ssh session helper >>>"
$endMarker = "# <<< novel ssh session helper <<<"
$block = @"
$startMarker
if (`$env:SSH_CONNECTION -or `$env:SSH_CLIENT) {
    `$workspace = '$WorkspacePath'
    if (Test-Path `$workspace) {
        Set-Location `$workspace
    }

    function global:nr {
        Set-Location '$WorkspacePath'
    }

    Write-Host ''
    Write-Host '[novel remote] SSH セッションを検出しました。' -ForegroundColor Cyan
    Write-Host ('[novel remote] cwd: {0}' -f (Get-Location).Path)

    if (Get-Command 'codex.cmd' -ErrorAction SilentlyContinue) {
        Write-Host '  codex.cmd                 Codex CLI を起動'
    }

    if (Get-Command 'claude.cmd' -ErrorAction SilentlyContinue) {
        Write-Host '  claude.cmd                Claude Code を起動'
        Write-Host '  .\.workspace\ops\auto_claude.bat   Claude remote-control watchdog'
    }

    Write-Host '  nr                        novel ルートへ移動'
    Write-Host '  git status                現在の変更を確認'
    Write-Host ''
}
$endMarker
"@

$existing = if (Test-Path $profilePath) { Get-Content -Raw -Encoding UTF8 $profilePath } else { "" }
if ($existing -match [regex]::Escape($startMarker)) {
    $pattern = "(?s)$([regex]::Escape($startMarker)).*?$([regex]::Escape($endMarker))"
    $updated = [regex]::Replace($existing, $pattern, $block.TrimEnd())
} else {
    $updated = ($existing.TrimEnd() + "`r`n`r`n" + $block.TrimEnd()).Trim() + "`r`n"
}

Set-Content -Path $profilePath -Value $updated -Encoding UTF8

Write-Host "PowerShell profile を更新しました: $profilePath" -ForegroundColor Green
Write-Host "次回の SSH ログイン時から自動で novel フォルダに移動します。"
