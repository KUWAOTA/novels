param(
    [ValidateSet("shell", "codex", "claude")]
    [string]$Tool = "shell"
)

$repoRoot = "C:\Users\ukowu\Desktop\novel"

if (-not (Test-Path $repoRoot)) {
    Write-Error "Repository not found: $repoRoot"
    exit 1
}

function Resolve-PreferredCommand {
    param(
        [string[]]$Names
    )

    foreach ($name in $Names) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($null -ne $cmd) {
            return $cmd
        }
    }

    return $null
}

Set-Location $repoRoot
$host.UI.RawUI.WindowTitle = "novel mobile session"

Write-Host ""
Write-Host "novel mobile session" -ForegroundColor Cyan
Write-Host ("repo : {0}" -f $repoRoot)
Write-Host ("host : {0}" -f $env:COMPUTERNAME)
Write-Host ("user : {0}" -f $env:USERNAME)
Write-Host ""

try {
    $status = git -C $repoRoot status --short
    if ([string]::IsNullOrWhiteSpace(($status | Out-String))) {
        Write-Host "git status: clean" -ForegroundColor Green
    } else {
        Write-Host "git status: changed" -ForegroundColor Yellow
        $status | Select-Object -First 10 | ForEach-Object { Write-Host $_ }
    }
} catch {
    Write-Host "git status: unavailable" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "quick commands" -ForegroundColor Cyan
Write-Host "  git status -sb"
Write-Host "  rg --files ."
Write-Host "  codex"
Write-Host "  claude"
Write-Host "  powershell -ExecutionPolicy Bypass -File .\\remote\\check-mobile-access.ps1"
Write-Host ""

switch ($Tool) {
    "codex" {
        $cmd = Resolve-PreferredCommand -Names @("codex.cmd", "codex")
        if ($null -eq $cmd) {
            Write-Error "codex command not found"
            exit 1
        }
        & $cmd.Source
    }
    "claude" {
        $cmd = Resolve-PreferredCommand -Names @("claude.cmd", "claude")
        if ($null -eq $cmd) {
            Write-Error "claude command not found"
            exit 1
        }
        & $cmd.Source
    }
    default {
        Write-Host "Shell mode ready." -ForegroundColor Green
    }
}
