# Adds refined Sprint 1 issues (#35-#64) to GitHub Project and sets Iteration: Sprint 1.
# Epic #9 stays in Backlog iteration (manual verify after run).
# Run from repo root: powershell -File scripts/add-sprint-1-to-project.ps1
# Requires: gh auth refresh -s read:project,project
param(
  [int]$ProjectNumber = 0,
  [switch]$IncludeOptionalLab,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$gh = "C:\Program Files\GitHub CLI\gh.exe"
if (-not (Test-Path $gh)) { $gh = "gh" }
$owner = "gabrielagarayzavalia"
$repo = "$owner/GGZenLab-Portfolio"
$projectName = "GGZenLab Portfolio"

# Core Sprint 1 (stories + tasks with label sprint-1)
$sprintIssues = 35..64
if ($IncludeOptionalLab) {
  $sprintIssues = 35..67
}

function Resolve-ProjectNumber {
  param([int]$Num)
  if ($Num -gt 0) { return $Num }
  $envNum = $env:GGL_PROJECT_NUMBER
  if ($envNum -match '^\d+$') { return [int]$envNum }
  Write-Host "Resolving project number for '$projectName'..."
  $json = & $gh project list --owner $owner --limit 20 --format json 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw "gh project list failed. Run: gh auth refresh -s read:project,project`n$json"
  }
  $projects = $json | ConvertFrom-Json
  $match = @($projects | Where-Object { $_.title -eq $projectName } | Select-Object -First 1)
  if (-not $match) {
    throw "Project '$projectName' not found. Pass -ProjectNumber N or set `$env:GGL_PROJECT_NUMBER"
  }
  return [int]$match.number
}

function Get-IterationFieldId {
  param([int]$ProjNum)
  $fieldsJson = & $gh project field-list $ProjNum --owner $owner --format json
  $fields = $fieldsJson | ConvertFrom-Json
  $iter = @($fields.fields | Where-Object { $_.name -eq "Iteration" } | Select-Object -First 1)
  if (-not $iter) { throw "Iteration field not found on project #$ProjNum" }
  return $iter
}

function Get-Sprint1IterationId {
  param($IterationField)
  $sprint1 = @($IterationField.configuration.iterations | Where-Object { $_.title -eq "Sprint 1" } | Select-Object -First 1)
  if (-not $sprint1) {
    throw "Iteration 'Sprint 1' not found. Create it in Project Settings -> Iterations."
  }
  return $sprint1.id
}

function Issue-InProject {
  param([int]$ProjNum, [int]$IssueNum)
  $url = "https://github.com/$repo/issues/$IssueNum"
  $items = & $gh project item-list $ProjNum --owner $owner --limit 500 --format json 2>$null
  if (-not $items) { return $false }
  $parsed = $items | ConvertFrom-Json
  return @($parsed.items | Where-Object { $_.content.url -eq $url }).Count -gt 0
}

$projNum = Resolve-ProjectNumber -Num $ProjectNumber
Write-Host "Project: $projectName (#$projNum)"

$iterField = Get-IterationFieldId -ProjNum $projNum
$sprint1Id = Get-Sprint1IterationId -IterationField $iterField
Write-Host "Iteration field id: $($iterField.id) | Sprint 1 id: $sprint1Id"

$added = 0
$skipped = 0
foreach ($num in $sprintIssues) {
  $url = "https://github.com/$repo/issues/$num"
  if ($DryRun) {
    Write-Host "[dry-run] Would add #$num and set Sprint 1"
    continue
  }
  if (-not (Issue-InProject -ProjNum $projNum -IssueNum $num)) {
    & $gh project item-add $projNum --owner $owner --url $url | Out-Null
    Write-Host "Added to project: #$num"
    $added++
  } else {
    Write-Host "Already in project: #$num"
    $skipped++
  }
  $itemJson = & $gh project item-list $projNum --owner $owner --limit 500 --format json | ConvertFrom-Json
  $item = @($itemJson.items | Where-Object { $_.content.url -eq $url } | Select-Object -First 1)
  if ($item) {
    & $gh project item-edit $projNum --owner $owner --id $item.id `
      --field-id $iterField.id --iteration-id $sprint1Id | Out-Null
    Write-Host "  -> Iteration: Sprint 1"
  }
}

Write-Host "`n=== Sprint 1 project setup ==="
Write-Host "Added: $added | Already present: $skipped | Issues: $($sprintIssues[0])-$($sprintIssues[-1])"
Write-Host "Epic #9: keep Iteration = Backlog (verify manually in project UI)"
Write-Host "Board filter: iteration:@current + label:track:po"
Write-Host "WIP order: see projects/qa-job-hunter/SPRINT-1-PLAN.md"
