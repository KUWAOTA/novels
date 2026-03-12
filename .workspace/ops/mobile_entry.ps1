param(
    [ValidateSet("shell", "codex", "claude")]
    [string]$Tool = "shell",

    [string]$RepoPath = "C:\Users\ukowu\Desktop\novel"
)

if (-not (Test-Path $RepoPath)) {
    Write-Error "Repo path not found: $RepoPath"
    exit 1
}

Set-Location $RepoPath

function Start-Tool {
    param(
        [string]$CommandName,
        [string[]]$Arguments = @()
    )

    $command = Get-Command $CommandName -ErrorAction SilentlyContinue
    if (-not $command) {
        Write-Error "Command not found in PATH: $CommandName"
        exit 1
    }

    & $command.Source @Arguments
    exit $LASTEXITCODE
}

Write-Host "=================================================="
Write-Host " Novel Mobile Entry"
Write-Host (" Repo: {0}" -f $RepoPath)
Write-Host (" Time: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
Write-Host "=================================================="

switch ($Tool) {
    "codex" {
        Write-Host "Starting Codex in the novel workspace..."
        Start-Tool -CommandName "codex.cmd"
    }
    "claude" {
        Write-Host "Starting Claude in the novel workspace..."
        Start-Tool -CommandName "claude.cmd"
    }
    default {
        Write-Host "Workspace is ready."
        Write-Host ""
        Write-Host "Recommended commands:"
        Write-Host "  codex"
        Write-Host "  claude"
        Write-Host "  git status --short"
        Write-Host "  Get-ChildItem"
    }
}
