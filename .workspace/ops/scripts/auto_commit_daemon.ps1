param(
    [int]$IntervalSeconds = 900,
    [string]$MessagePrefix = "auto: snapshot",
    [switch]$Push
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-RepoRoot {
    $root = & git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($root)) {
        throw "Git repository root could not be resolved."
    }

    return $root.Trim()
}

function Get-StatePaths {
    param([string]$RepoRoot)

    $stateDir = Join-Path $RepoRoot ".git/auto-commit"
    if (-not (Test-Path -LiteralPath $stateDir)) {
        New-Item -ItemType Directory -Path $stateDir | Out-Null
    }

    return @{
        StateDir = $stateDir
        PidFile = Join-Path $stateDir "daemon.pid"
        BaselineFile = Join-Path $stateDir "baseline.json"
        LogFile = Join-Path $stateDir "daemon.log"
    }
}

function Write-Log {
    param(
        [string]$Message,
        [string]$LogFile
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -LiteralPath $LogFile -Value "[$timestamp] $Message"
}

function Test-IndexClean {
    & git diff --cached --quiet
    return ($LASTEXITCODE -eq 0)
}

function Get-StatusPaths {
    $lines = & git -c core.quotepath=false status --porcelain=v1 -uall
    if ($LASTEXITCODE -ne 0) {
        throw "git status failed."
    }

    $paths = New-Object System.Collections.Generic.List[string]
    foreach ($line in $lines) {
        if ([string]::IsNullOrWhiteSpace($line) -or $line.Length -lt 4) {
            continue
        }

        $pathText = $line.Substring(3)
        if ($pathText.Contains(" -> ")) {
            foreach ($part in ($pathText -split " -> ")) {
                if (-not [string]::IsNullOrWhiteSpace($part)) {
                    $paths.Add($part)
                }
            }
            continue
        }

        $paths.Add($pathText)
    }

    return $paths | Sort-Object -Unique
}

function Get-PathFingerprint {
    param(
        [string]$RepoRoot,
        [string]$RelativePath
    )

    $fullPath = Join-Path $RepoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $fullPath)) {
        return "__MISSING__"
    }

    $item = Get-Item -LiteralPath $fullPath
    if ($item.PSIsContainer) {
        return "__DIR__"
    }

    return (Get-FileHash -LiteralPath $fullPath -Algorithm SHA256).Hash
}

function New-Baseline {
    param([string]$RepoRoot)

    $map = @{}
    foreach ($path in (Get-StatusPaths)) {
        $map[$path] = Get-PathFingerprint -RepoRoot $RepoRoot -RelativePath $path
    }

    return $map
}

function Load-Baseline {
    param([string]$BaselineFile)

    if (-not (Test-Path -LiteralPath $BaselineFile)) {
        return @{}
    }

    $raw = Get-Content -LiteralPath $BaselineFile -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return @{}
    }

    $data = ConvertFrom-Json -InputObject $raw
    if ($null -eq $data) {
        return @{}
    }

    $map = @{}
    foreach ($property in $data.PSObject.Properties) {
        $map[$property.Name] = [string]$property.Value
    }

    return $map
}

function Save-Baseline {
    param(
        [hashtable]$Baseline,
        [string]$BaselineFile
    )

    $json = $Baseline | ConvertTo-Json
    Set-Content -LiteralPath $BaselineFile -Value $json
}

function Get-DeltaPaths {
    param(
        [string]$RepoRoot,
        [hashtable]$Baseline
    )

    $delta = New-Object System.Collections.Generic.List[string]
    foreach ($path in (Get-StatusPaths)) {
        $currentFingerprint = Get-PathFingerprint -RepoRoot $RepoRoot -RelativePath $path
        $baselineFingerprint = $null
        $hasBaseline = $Baseline.ContainsKey($path)
        if ($hasBaseline) {
            $baselineFingerprint = [string]$Baseline[$path]
        }

        if (-not $hasBaseline -or $baselineFingerprint -ne $currentFingerprint) {
            $delta.Add($path)
        }
    }

    return $delta | Sort-Object -Unique
}

function Test-ProcessAlive {
    param([int]$ProcessId)

    try {
        $null = Get-Process -Id $ProcessId -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

$repoRoot = Get-RepoRoot
Set-Location -LiteralPath $repoRoot
$paths = Get-StatePaths -RepoRoot $repoRoot

if (Test-Path -LiteralPath $paths.PidFile) {
    $existingPidRaw = Get-Content -LiteralPath $paths.PidFile -Raw
    if (-not [string]::IsNullOrWhiteSpace($existingPidRaw)) {
        $existingPid = [int]$existingPidRaw.Trim()
        if ($existingPid -ne $PID -and (Test-ProcessAlive -ProcessId $existingPid)) {
            throw "Auto-commit daemon is already running with PID $existingPid."
        }
    }
}

Set-Content -LiteralPath $paths.PidFile -Value $PID

try {
    if (-not (Test-IndexClean)) {
        Write-Log -LogFile $paths.LogFile -Message "Startup aborted because the git index already has staged changes."
        throw "The git index already has staged changes. Clear the index before starting auto-commit."
    }

    $baseline = New-Baseline -RepoRoot $repoRoot
    Save-Baseline -Baseline $baseline -BaselineFile $paths.BaselineFile
    Write-Log -LogFile $paths.LogFile -Message "Daemon started. Baseline saved with $($baseline.Count) tracked dirty paths."

    while ($true) {
        Start-Sleep -Seconds $IntervalSeconds

        if (-not (Test-IndexClean)) {
            Write-Log -LogFile $paths.LogFile -Message "Skipped cycle because the git index has staged changes."
            continue
        }

        $baseline = Load-Baseline -BaselineFile $paths.BaselineFile
        $deltaPaths = @(Get-DeltaPaths -RepoRoot $repoRoot -Baseline $baseline)
        if ($deltaPaths.Count -eq 0) {
            continue
        }

        & git add --all -- $deltaPaths
        if ($LASTEXITCODE -ne 0) {
            Write-Log -LogFile $paths.LogFile -Message "git add failed."
            continue
        }

        $commitMessage = "{0} {1}" -f $MessagePrefix, (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        & git commit -m $commitMessage
        if ($LASTEXITCODE -ne 0) {
            Write-Log -LogFile $paths.LogFile -Message "git commit produced no commit or failed. Resetting baseline."
            $baseline = New-Baseline -RepoRoot $repoRoot
            Save-Baseline -Baseline $baseline -BaselineFile $paths.BaselineFile
            continue
        }

        Write-Log -LogFile $paths.LogFile -Message "Created commit: $commitMessage"

        if ($Push.IsPresent) {
            & git push
            if ($LASTEXITCODE -eq 0) {
                Write-Log -LogFile $paths.LogFile -Message "Push succeeded."
            }
            else {
                Write-Log -LogFile $paths.LogFile -Message "Push failed."
            }
        }

        $baseline = New-Baseline -RepoRoot $repoRoot
        Save-Baseline -Baseline $baseline -BaselineFile $paths.BaselineFile
    }
}
finally {
    if (Test-Path -LiteralPath $paths.PidFile) {
        $currentPidRaw = Get-Content -LiteralPath $paths.PidFile -Raw
        if (-not [string]::IsNullOrWhiteSpace($currentPidRaw) -and [int]$currentPidRaw.Trim() -eq $PID) {
            Remove-Item -LiteralPath $paths.PidFile -Force
        }
    }
}
