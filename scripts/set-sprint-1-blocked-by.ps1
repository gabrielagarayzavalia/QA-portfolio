# Sets Blocked by relationships for Sprint 1 tasks (#43-#67) per SPRINT-1-PLAN.md
# Idempotent: re-running --add-blocked-by on existing links is safe.
# Run from repo root: powershell -File scripts/set-sprint-1-blocked-by.ps1
param([switch]$DryRun)

$ErrorActionPreference = "Stop"
$gh = "C:\Program Files\GitHub CLI\gh.exe"
if (-not (Test-Path $gh)) { $gh = "gh" }
$repo = "gabrielagarayzavalia/GGZenLab-Portfolio"

$pairs = @(
  @{ issue = 44; blockedBy = @(43) },
  @{ issue = 45; blockedBy = @(44) },
  @{ issue = 46; blockedBy = @(44) },
  @{ issue = 47; blockedBy = @(44) },
  @{ issue = 48; blockedBy = @(47) },
  @{ issue = 49; blockedBy = @(47) },
  @{ issue = 50; blockedBy = @(48, 49) },
  @{ issue = 51; blockedBy = @(50) },
  @{ issue = 52; blockedBy = @(51) },
  @{ issue = 53; blockedBy = @(52) },
  @{ issue = 55; blockedBy = @(47) },
  @{ issue = 56; blockedBy = @(55) },
  @{ issue = 57; blockedBy = @(56) },
  @{ issue = 58; blockedBy = @(55) },
  @{ issue = 59; blockedBy = @(55) },
  @{ issue = 60; blockedBy = @(58, 59) },
  @{ issue = 61; blockedBy = @(56, 58, 59) },
  @{ issue = 62; blockedBy = @(61) },
  @{ issue = 63; blockedBy = @(52) },
  @{ issue = 64; blockedBy = @(63, 51) },
  @{ issue = 65; blockedBy = @(51) },
  @{ issue = 66; blockedBy = @(65) },
  @{ issue = 67; blockedBy = @(66) }
)

foreach ($p in $pairs) {
  $blockers = @($p.blockedBy | ForEach-Object { [int]$_ })
  $blockerStr = ($blockers | ForEach-Object { "$_" }) -join ","
  if ($DryRun) {
    Write-Host "[dry-run] #$($p.issue) blocked by $blockerStr"
    continue
  }

  $existingJson = & $gh issue view $p.issue --repo $repo --json blockedBy 2>&1
  if ($LASTEXITCODE -ne 0) { throw "Failed to read #$($p.issue)`n$existingJson" }
  $existing = @($existingJson | ConvertFrom-Json | Select-Object -ExpandProperty blockedBy | Select-Object -ExpandProperty nodes | ForEach-Object { [int]$_.number })

  $toAdd = @($blockers | Where-Object { $_ -notin $existing })
  if ($toAdd.Count -eq 0) {
    Write-Host "SKIP #$($p.issue) (already blocked by $blockerStr)"
    continue
  }

  $addStr = ($toAdd | ForEach-Object { "$_" }) -join ","
  $out = & $gh issue edit $p.issue --repo $repo --add-blocked-by $addStr 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw "Failed #$($p.issue) add blocked-by $addStr`n$out"
  }
  Write-Host "OK #$($p.issue) blocked by $addStr"
}

Write-Host "`nBlocked-by setup complete ($($pairs.Count) issues)."
