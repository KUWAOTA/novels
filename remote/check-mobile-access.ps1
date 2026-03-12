param()

$repoRoot = "C:\Users\ukowu\Desktop\novel"
$userAuthorizedKeys = Join-Path $HOME ".ssh\\authorized_keys"
$adminAuthorizedKeys = Join-Path $env:ProgramData "ssh\\administrators_authorized_keys"

function Show-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "=== $Title ===" -ForegroundColor Cyan
}

function Show-CommandStatus {
    param(
        [string]$Name
    )

    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($null -ne $cmd) {
        Write-Host ("[OK]   {0} -> {1}" -f $Name, $cmd.Source) -ForegroundColor Green
    } else {
        Write-Host ("[MISS] {0}" -f $Name) -ForegroundColor Yellow
    }
}

function Test-PathSafe {
    param(
        [string]$LiteralPath
    )

    try {
        return Test-Path -LiteralPath $LiteralPath -ErrorAction Stop
    }
    catch {
        return "access-denied"
    }
}

Show-Section "Basic"
Write-Host ("Repo:      {0}" -f $repoRoot)
Write-Host ("Exists:    {0}" -f (Test-Path $repoRoot))
Write-Host ("Host:      {0}" -f $env:COMPUTERNAME)
Write-Host ("User:      {0}" -f $env:USERNAME)

Show-Section "Commands"
Show-CommandStatus -Name "git"
Show-CommandStatus -Name "rg"
Show-CommandStatus -Name "codex"
Show-CommandStatus -Name "codex.cmd"
Show-CommandStatus -Name "claude"
Show-CommandStatus -Name "claude.cmd"
Show-CommandStatus -Name "ssh"
Show-CommandStatus -Name "tailscale"

Show-Section "Network"
$ips = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Where-Object {
        $_.IPAddress -notlike "169.254.*" -and
        $_.IPAddress -ne "127.0.0.1"
    } |
    Sort-Object InterfaceMetric, SkipAsSource |
    Select-Object -ExpandProperty IPAddress -Unique

if ($ips) {
    $ips | ForEach-Object { Write-Host ("IPv4:      {0}" -f $_) }
} else {
    Write-Host "IPv4:      not found" -ForegroundColor Yellow
}

Show-Section "sshd"
try {
    $sshd = Get-Service -Name "sshd" -ErrorAction Stop
    Write-Host ("Status:    {0}" -f $sshd.Status)
    Write-Host ("StartType: {0}" -f $sshd.StartType)
} catch {
    Write-Host "sshd service not found" -ForegroundColor Yellow
}

Show-Section "SSH keys"
Write-Host ("User keys:  {0}" -f $userAuthorizedKeys)
Write-Host ("Exists:     {0}" -f (Test-PathSafe -LiteralPath $userAuthorizedKeys))
Write-Host ("Admin keys: {0}" -f $adminAuthorizedKeys)
Write-Host ("Exists:     {0}" -f (Test-PathSafe -LiteralPath $adminAuthorizedKeys))

Show-Section "Git"
if (Test-Path $repoRoot) {
    try {
        $status = git -C $repoRoot status --short
        if ([string]::IsNullOrWhiteSpace(($status | Out-String))) {
            Write-Host "Working tree: clean"
        } else {
            Write-Host "Working tree: changed"
            $status | Select-Object -First 10 | ForEach-Object { Write-Host $_ }
        }
    } catch {
        Write-Host "Git status could not be read" -ForegroundColor Yellow
    }
}
