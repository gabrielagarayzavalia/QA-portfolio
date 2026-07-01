# Refinement migration: close superseded issues #14-#34 (B-06/B-13 subset) and create refined stories/tasks.
# Run from repo root: powershell -File scripts/refine-job-hunter-issues.ps1
$ErrorActionPreference = "Stop"
$gh = "C:\Program Files\GitHub CLI\gh.exe"
if (-not (Test-Path $gh)) { $gh = "gh" }
$repo = "gabrielagarayzavalia/GGZenLab-Portfolio"
$tmp = Join-Path $env:TEMP "gh-jh-refine"
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

function Ensure-Label($name, $color, $desc) {
  $list = & $gh label list --repo $repo --limit 300 --json name --jq ".[].name" 2>$null
  if ($list -notcontains $name) {
    & $gh label create $name --repo $repo --color $color --description $desc 2>$null
    Write-Host "Label: $name"
  }
}

function Issue-Exists($title) {
  $issues = & $gh issue list --repo $repo --state all --limit 300 --json title 2>$null | ConvertFrom-Json
  if (-not $issues) { return $false }
  return @($issues | Where-Object { $_.title -eq $title }).Count -gt 0
}

function Format-TaskBody($meta) {
  @"
## Meta
| Campo | Valor |
|-------|--------|
| ID | $($meta.Id) |
| Story | $($meta.Story) |
| Layer | $($meta.Layer) |
| Depends on | $($meta.Depends) |

## Outcome (1 frase)
$($meta.Outcome)

## Scope
$($meta.Scope)

## Out of scope
$($meta.OutOfScope)

## Definition of Done
$($meta.DoD)

## Verify
$($meta.Verify)

## Files
$($meta.Files)
"@
}

function New-Issue($title, $body, [string[]]$labels) {
  if (Issue-Exists $title) {
    Write-Host "SKIP (exists): $title"
    $num = & $gh issue list --repo $repo --state all --search "in:title `"$title`"" --json number,title --jq ".[] | select(.title==`"$title`") | .number" 2>$null
    if ($num) { return [int]$num }
    return $null
  }
  $bodyFile = Join-Path $tmp ([Guid]::NewGuid().ToString() + ".md")
  Set-Content -Path $bodyFile -Value $body -Encoding UTF8
  $labelArgs = $labels | ForEach-Object { "--label"; $_ }
  $url = & $gh issue create --repo $repo --title $title --body-file $bodyFile @labelArgs
  Remove-Item $bodyFile -Force -ErrorAction SilentlyContinue
  $num = [int](($url -split '/')[-1])
  Write-Host "Created #$num : $title"
  return $num
}

function Close-Superseded($num, $comment) {
  $state = & $gh issue view $num --repo $repo --json state --jq .state 2>$null
  if ($state -eq "CLOSED") {
    Write-Host "Already closed: #$num"
    return
  }
  & $gh issue close $num --repo $repo --comment $comment | Out-Null
  & $gh issue edit $num --repo $repo --add-label "superseded" 2>$null
  Write-Host "Closed superseded: #$num"
}

# Labels
Ensure-Label "superseded" "F9D0C4" "Replaced by refined backlog"
Ensure-Label "subtask" "FEF2C0" "Sub-task of PO task"
Ensure-Label "layer:infra" "BFD4F2" "Layer infra"
Ensure-Label "layer:db" "BFD4F2" "Layer db"
Ensure-Label "layer:api" "BFD4F2" "Layer api"
Ensure-Label "layer:pipeline" "BFD4F2" "Layer pipeline"
Ensure-Label "layer:adapter" "BFD4F2" "Layer adapter"
Ensure-Label "layer:ui" "BFD4F2" "Layer ui"
Ensure-Label "layer:docs" "BFD4F2" "Layer docs"
Ensure-Label "layer:qa" "BFD4F2" "Layer qa"
Ensure-Label "sprint-1" "0E8A16" "Sprint 1 refined scope"

# --- Close superseded ---
$supersededMap = @{
  14 = "Superseded by US-JH-B06-1, US-JH-B06-2, US-JH-B06-3, US-JH-B06-4. See BACKLOG-REFINED.md"
  15 = "Superseded by US-JH-B13-0, US-JH-B13-1, US-JH-B13-2, US-JH-B13-3. See BACKLOG-REFINED.md"
  25 = "Superseded by JH-T-B06-1-01"
  26 = "Superseded by JH-T-B06-1-02, JH-T-B06-2-01, JH-T-B06-2-02, JH-T-B06-2-03"
  27 = "Superseded by JH-T-B13-0-01"
  28 = "Superseded by JH-T-B13-1-01, JH-T-B13-1-02, JH-T-B13-1-03"
  29 = "Superseded by JH-T-B13-2-01"
  33 = "Superseded by JH-T-B13-2-02, JH-T-B13-3-01, JH-T-B13-3-02"
  34 = "Superseded by JH-T-B13-3-03, JH-T-B13-3-04"
}
foreach ($kv in $supersededMap.GetEnumerator()) {
  Close-Superseded $kv.Key $kv.Value
}

# --- Stories ---
$stories = @(
  @{
    Title = "[Story] US-JH-B06-1 — Persistencia local Mongo"
    Labels = @("user-story","type:story","track:po","mini-project:job-hunter","backlog:B-06","priority:high","sprint-1")
    Body = @"
Story ID: US-JH-B06-1
Backlog ID: B-06
Parent Epic: EPIC-JH (#9)
Supersedes: #14 (partial)

As a job seeker
I want MongoDB running locally with seed from existing JSON
So that I can persist data without losing history

AC (tasks):
- [ ] JH-T-B06-1-01
- [ ] JH-T-B06-1-02
- [ ] JH-T-B06-1-03
- [ ] JH-T-B06-1-04
"@
  },
  @{
    Title = "[Story] US-JH-B06-2 — Write path post-análisis"
    Labels = @("user-story","type:story","track:po","mini-project:job-hunter","backlog:B-06","priority:high","sprint-1")
    Body = @"
Story ID: US-JH-B06-2
Backlog ID: B-06
Parent Epic: EPIC-JH (#9)
Depends on: US-JH-B06-1
Supersedes: #14 (partial), #26 (partial)

As a job seeker
I want each analysis run saved to Mongo with job dedup
So that re-runs do not duplicate offers

AC (tasks):
- [ ] JH-T-B06-2-01
- [ ] JH-T-B06-2-02
- [ ] JH-T-B06-2-03
- [ ] JH-T-B06-2-04
"@
  },
  @{
    Title = "[Story] US-JH-B06-3 — Read path dashboard"
    Labels = @("user-story","type:story","track:po","mini-project:job-hunter","backlog:B-06","priority:high","sprint-1")
    Body = @"
Story ID: US-JH-B06-3
Backlog ID: B-06
Parent Epic: EPIC-JH (#9)
Depends on: US-JH-B06-2
Supersedes: #14 (partial)

As a job seeker
I want the dashboard to load jobs from Mongo via API
So that I query history without reading JSON files

AC (tasks):
- [ ] JH-T-B06-3-01
- [ ] JH-T-B06-3-02
- [ ] JH-T-B06-3-03
"@
  },
  @{
    Title = "[Story] US-JH-B06-4 — Lab QA Mongo"
    Labels = @("user-story","type:story","track:po","mini-project:job-hunter","backlog:B-06")
    Body = @"
Story ID: US-JH-B06-4
Backlog ID: B-06
Parent Epic: EPIC-JH (#9)
Depends on: US-JH-B06-3
Optional: Sprint 1 end or Sprint 2

AC (tasks):
- [ ] JH-T-B06-4-01
- [ ] JH-T-B06-4-02
- [ ] JH-T-B06-4-03
"@
  },
  @{
    Title = "[Story] US-JH-B13-0 — Spike ToS multi-fuente"
    Labels = @("user-story","type:story","track:po","mini-project:job-hunter","backlog:B-13","priority:high","sprint-1")
    Body = @"
Story ID: US-JH-B13-0
Backlog ID: B-13
Parent Epic: EPIC-JH (#9)
Supersedes: #27

AC (tasks):
- [ ] JH-T-B13-0-01
"@
  },
  @{
    Title = "[Story] US-JH-B13-1 — Contrato adapters + LinkedIn"
    Labels = @("user-story","type:story","track:po","mini-project:job-hunter","backlog:B-13","priority:high","sprint-1")
    Body = @"
Story ID: US-JH-B13-1
Depends on: US-JH-B06-2
Supersedes: #28

AC (tasks):
- [ ] JH-T-B13-1-01
- [ ] JH-T-B13-1-02
- [ ] JH-T-B13-1-03
"@
  },
  @{
    Title = "[Story] US-JH-B13-2 — Fuentes LATAM MVP"
    Labels = @("user-story","type:story","track:po","mini-project:job-hunter","backlog:B-13","priority:high","sprint-1")
    Body = @"
Story ID: US-JH-B13-2
Depends on: US-JH-B13-1
Supersedes: #29, #33 (partial)

AC (tasks):
- [ ] JH-T-B13-2-01
- [ ] JH-T-B13-2-02
- [ ] JH-T-B13-2-03
"@
  },
  @{
    Title = "[Story] US-JH-B13-3 — Orquestación + UX fuente"
    Labels = @("user-story","type:story","track:po","mini-project:job-hunter","backlog:B-13","priority:high","sprint-1")
    Body = @"
Story ID: US-JH-B13-3
Depends on: US-JH-B13-2, US-JH-B06-3
Supersedes: #33 (partial), #34

AC (tasks):
- [ ] JH-T-B13-3-01
- [ ] JH-T-B13-3-02
- [ ] JH-T-B13-3-03
- [ ] JH-T-B13-3-04
"@
  }
)

$storyNumbers = @{}
foreach ($s in $stories) {
  $n = New-Issue $s.Title $s.Body $s.Labels
  if ($n) { $storyNumbers[$s.Title] = $n }
}

# --- Tasks ---
$tasks = @(
  @{ Id="JH-T-B06-1-01"; Title="[Task] JH-T-B06-1-01 — Docker mongo:7 in compose + healthcheck"; Story="US-JH-B06-1"; Layer="infra"; Depends="—"; LayerLabel="layer:infra"
     Outcome="MongoDB 7 runs via docker compose with healthcheck passing."
     Scope="- Add mongo service to docker-compose.yml (repo root or qa-job-hunter)`n- Port 27017, volume mongodb_data`n- Healthcheck: mongosh ping"
     OutOfScope="App connection code (JH-T-B06-1-02)"
     DoD="- [ ] docker compose up starts mongo`n- [ ] healthcheck green"
     Verify="docker compose up -d && docker compose ps"
     Files="- docker-compose.yml" },
  @{ Id="JH-T-B06-1-02"; Title="[Task] JH-T-B06-1-02 — src/db/client.ts + MONGODB_URI"; Story="US-JH-B06-1"; Layer="db"; Depends="JH-T-B06-1-01"; LayerLabel="layer:db"
     Outcome="App connects to Mongo using MONGODB_URI from env."
     Scope="- src/db/client.ts with getDb(), connect(), disconnect()`n- Default uri mongodb://localhost:27017/qa_job_hunter"
     OutOfScope="Repositories, seed script"
     DoD="- [ ] connect() succeeds against local mongo"
     Verify="npx tsx -e `"import { connect } from './src/db/client.ts'; connect().then(()=>console.log('ok'))`""
     Files="- projects/qa-job-hunter/src/db/client.ts" },
  @{ Id="JH-T-B06-1-03"; Title="[Task] JH-T-B06-1-03 — npm run db:seed from jobs-result.json"; Story="US-JH-B06-1"; Layer="pipeline"; Depends="JH-T-B06-1-02"; LayerLabel="layer:pipeline"
     Outcome="One command seeds Mongo from output/jobs-result.json."
     Scope="- Script src/db/seed.ts`n- npm run db:seed in package.json"
     OutOfScope="Analyze pipeline write"
     DoD="- [ ] Seed inserts jobs from JSON"
     Verify="npm run db:seed && mongosh --eval 'db.jobs.countDocuments()'"
     Files="- src/db/seed.ts, package.json" },
  @{ Id="JH-T-B06-1-04"; Title="[Task] JH-T-B06-1-04 — README Mongo local setup"; Story="US-JH-B06-1"; Layer="docs"; Depends="JH-T-B06-1-01"; LayerLabel="layer:docs"
     Outcome="README documents Mongo + seed steps."
     Scope="- Section in projects/qa-job-hunter/README.md"
     OutOfScope="Portfolio docs subpage"
     DoD="- [ ] MONGODB_URI and compose steps documented"
     Verify="Read README section"
     Files="- projects/qa-job-hunter/README.md" },
  @{ Id="JH-T-B06-2-01"; Title="[Task] JH-T-B06-2-01 — Collections + indexes"; Story="US-JH-B06-2"; Layer="db"; Depends="JH-T-B06-1-02"; LayerLabel="layer:db"
     Outcome="Collections analysis_runs, jobs, skipped_jobs exist with indexes."
     Scope="- ensureIndexes() on startup or migration script`n- Index matchPercent, url, scrapedAt"
     OutOfScope="saveRun implementation"
     DoD="- [ ] Indexes created idempotently"
     Verify="mongosh show indexes on jobs"
     Files="- src/db/indexes.ts" },
  @{ Id="JH-T-B06-2-02"; Title="[Task] JH-T-B06-2-02 — Repo saveRun()"; Story="US-JH-B06-2"; Layer="db"; Depends="JH-T-B06-2-01"; LayerLabel="layer:db"
     Outcome="Each analyze creates analysis_runs document."
     Scope="- saveRun(AnalysisResult metadata) in src/db/runs.ts"
     OutOfScope="upsertJobs"
     DoD="- [ ] Run doc has scrapedAt, totals, provider"
     Verify="Unit test or manual insert"
     Files="- src/db/runs.ts" },
  @{ Id="JH-T-B06-2-03"; Title="[Task] JH-T-B06-2-03 — Repo upsertJobs() dedup"; Story="US-JH-B06-2"; Layer="db"; Depends="JH-T-B06-2-01"; LayerLabel="layer:db"
     Outcome="Jobs upserted by url/id without duplicates."
     Scope="- upsertJobs(JobMatch[], runId) in src/db/jobs.ts"
     OutOfScope="analyze hook"
     DoD="- [ ] Second upsert same url updates not duplicates"
     Verify="Call upsert twice, count stays 1"
     Files="- src/db/jobs.ts" },
  @{ Id="JH-T-B06-2-04"; Title="[Task] JH-T-B06-2-04 — Hook 3-analyze-match.ts persist"; Story="US-JH-B06-2"; Layer="pipeline"; Depends="JH-T-B06-2-02, JH-T-B06-2-03"; LayerLabel="layer:pipeline"
     Outcome="After analyze, Mongo has run + jobs (JSON export optional)."
     Scope="- Call saveRun + upsertJobs at end of 3-analyze-match.ts`n- Guard if MONGODB_URI unset"
     OutOfScope="GET /api/jobs"
     DoD="- [ ] Full analyze writes to Mongo"
     Verify="npx tsx src/3-analyze-match.ts then mongosh count"
     Files="- src/3-analyze-match.ts" },
  @{ Id="JH-T-B06-3-01"; Title="[Task] JH-T-B06-3-01 — GET /api/jobs"; Story="US-JH-B06-3"; Layer="api"; Depends="JH-T-B06-2-04"; LayerLabel="layer:api"
     Outcome="API returns jobs from Mongo sorted by matchPercent."
     Scope="- GET /api/jobs?sort=matchPercent&order=desc in serve-dashboard.ts`n- listJobs query"
     OutOfScope="Dashboard UI, source filter (B13-3-04)"
     DoD="- [ ] JSON shape compatible with dashboard"
     Verify="curl http://localhost:3847/api/jobs"
     Files="- src/serve-dashboard.ts, src/db/jobs.ts" },
  @{ Id="JH-T-B06-3-02"; Title="[Task] JH-T-B06-3-02 — dashboard app.js uses /api/jobs"; Story="US-JH-B06-3"; Layer="ui"; Depends="JH-T-B06-3-01"; LayerLabel="layer:ui"
     Outcome="Dashboard loads from /api/jobs with optional JSON fallback."
     Scope="- Update dashboard/app.js fetch URL`n- Keep sort UI working"
     OutOfScope="Source badge"
     DoD="- [ ] npm run dashboard shows Mongo data"
     Verify="npm run dashboard"
     Files="- dashboard/app.js" },
  @{ Id="JH-T-B06-3-03"; Title="[Task] JH-T-B06-3-03 — Feedback API compatible Mongo"; Story="US-JH-B06-3"; Layer="api"; Depends="JH-T-B06-3-01"; LayerLabel="layer:api"
     Outcome="Reject feedback works when jobs served from Mongo."
     Scope="- Ensure job id in feedback matches Mongo docs`n- feedback.ts unchanged or minimal"
     OutOfScope="New feedback features"
     DoD="- [ ] POST /api/feedback/reject still works"
     Verify="Reject job in UI, check match-feedback.json"
     Files="- src/feedback.ts, src/serve-dashboard.ts" },
  @{ Id="JH-T-B13-0-01"; Title="[Task] JH-T-B13-0-01 — Doc ToS/rate limits per source"; Story="US-JH-B13-0"; Layer="docs"; Depends="—"; LayerLabel="layer:docs"
     Outcome="sources-research.md covers LinkedIn, GetOnBoard, Indeed AR."
     Scope="- projects/qa-job-hunter/docs/sources-research.md`n- ToS summary, rate limits, API vs scrape, risk matrix"
     OutOfScope="Implementation"
     DoD="- [ ] Doc published in repo"
     Verify="File exists and readable"
     Files="- projects/qa-job-hunter/docs/sources-research.md" },
  @{ Id="JH-T-B13-1-01"; Title="[Task] JH-T-B13-1-01 — JobSourceAdapter + JobListing types"; Story="US-JH-B13-1"; Layer="adapter"; Depends="JH-T-B06-2-01"; LayerLabel="layer:adapter"
     Outcome="JobSourceAdapter interface and source/externalId on JobListing."
     Scope="- src/adapters/types.ts`n- Extend src/types.ts JobListing"
     OutOfScope="LinkedIn implementation"
     DoD="- [ ] Types compile"
     Verify="npx tsc --noEmit"
     Files="- src/adapters/types.ts, src/types.ts" },
  @{ Id="JH-T-B13-1-02"; Title="[Task] JH-T-B13-1-02 — LinkedInAdapter refactor"; Story="US-JH-B13-1"; Layer="adapter"; Depends="JH-T-B13-1-01"; LayerLabel="layer:adapter"
     Outcome="LinkedIn scrape uses adapter; same output as before."
     Scope="- src/adapters/linkedin-adapter.ts`n- Refactor 2-scrape-jobs.ts to delegate"
     OutOfScope="GetOnBoard, Indeed"
     DoD="- [ ] Scrape still produces jobs-result-raw.json"
     Verify="npx tsx src/2-scrape-jobs.ts"
     Files="- src/adapters/linkedin-adapter.ts, src/2-scrape-jobs.ts" },
  @{ Id="JH-T-B13-1-03"; Title="[Task] JH-T-B13-1-03 — Fixture tests LinkedIn adapter"; Story="US-JH-B13-1"; Layer="qa"; Depends="JH-T-B13-1-02"; LayerLabel="layer:qa"
     Outcome="Tests parse fixture HTML without network."
     Scope="- tests/fixtures/linkedin/`n- test adapter.search() returns JobListing[]"
     OutOfScope="Live scrape in CI"
     DoD="- [ ] Tests pass offline"
     Verify="npm test (when added)"
     Files="- tests/adapters/linkedin.test.ts" },
  @{ Id="JH-T-B13-2-01"; Title="[Task] JH-T-B13-2-01 — GetOnBoardAdapter MVP"; Story="US-JH-B13-2"; Layer="adapter"; Depends="JH-T-B13-1-01"; LayerLabel="layer:adapter"
     Outcome="GetOnBoard returns normalized JobListing[]."
     Scope="- src/adapters/getonboard-adapter.ts"
     OutOfScope="Orchestrator"
     DoD="- [ ] Manual search returns listings"
     Verify="Adapter smoke test script"
     Files="- src/adapters/getonboard-adapter.ts" },
  @{ Id="JH-T-B13-2-02"; Title="[Task] JH-T-B13-2-02 — IndeedAdapter AR MVP"; Story="US-JH-B13-2"; Layer="adapter"; Depends="JH-T-B13-1-01"; LayerLabel="layer:adapter"
     Outcome="Indeed Argentina returns normalized JobListing[]."
     Scope="- src/adapters/indeed-adapter.ts region AR"
     OutOfScope="Orchestrator"
     DoD="- [ ] Manual search returns listings"
     Verify="Adapter smoke test"
     Files="- src/adapters/indeed-adapter.ts" },
  @{ Id="JH-T-B13-2-03"; Title="[Task] JH-T-B13-2-03 — Contract test all adapters"; Story="US-JH-B13-2"; Layer="qa"; Depends="JH-T-B13-2-01, JH-T-B13-2-02"; LayerLabel="layer:qa"
     Outcome="Every adapter output validates JobListing schema."
     Scope="- Shared validator function`n- Tests for linkedin, getonboard, indeed fixtures"
     OutOfScope="E2E scrape"
     DoD="- [ ] Invalid fixture fails test"
     Verify="npm test"
     Files="- tests/adapters/contract.test.ts" },
  @{ Id="JH-T-B13-3-01"; Title="[Task] JH-T-B13-3-01 — scrape-orchestrator.ts"; Story="US-JH-B13-3"; Layer="pipeline"; Depends="JH-T-B13-1-02, JH-T-B13-2-01, JH-T-B13-2-02"; LayerLabel="layer:pipeline"
     Outcome="Orchestrator runs enabled adapters and merges results."
     Scope="- src/scrape-orchestrator.ts`n- config enabled sources"
     OutOfScope="run-all wiring"
     DoD="- [ ] Returns merged JobListing[]"
     Verify="npx tsx script calling orchestrator"
     Files="- src/scrape-orchestrator.ts, src/config.ts" },
  @{ Id="JH-T-B13-3-02"; Title="[Task] JH-T-B13-3-02 — run-all.ts uses orchestrator"; Story="US-JH-B13-3"; Layer="pipeline"; Depends="JH-T-B13-3-01"; LayerLabel="layer:pipeline"
     Outcome="run-all scrape step uses orchestrator not direct 2-scrape-jobs."
     Scope="- Update run-all.ts and 2-scrape-jobs entry"
     OutOfScope="Dashboard UI"
     DoD="- [ ] run-all completes multi-source scrape"
     Verify="npx tsx src/run-all.ts"
     Files="- src/run-all.ts" },
  @{ Id="JH-T-B13-3-03"; Title="[Task] JH-T-B13-3-03 — Source badge UI"; Story="US-JH-B13-3"; Layer="ui"; Depends="JH-T-B06-3-02"; LayerLabel="layer:ui"
     Outcome="List and detail show job source badge."
     Scope="- dashboard/app.js + styles.css badge per source"
     OutOfScope="Filter dropdown"
     DoD="- [ ] Badge visible for linkedin/getonboard/indeed"
     Verify="npm run dashboard with multi-source data"
     Files="- dashboard/app.js, dashboard/styles.css" },
  @{ Id="JH-T-B13-3-04"; Title="[Task] JH-T-B13-3-04 — Source filter + API ?source="; Story="US-JH-B13-3"; Layer="api"; Depends="JH-T-B13-3-03, JH-T-B06-3-01"; LayerLabel="layer:api"
     Outcome="User filters jobs by source in UI; API supports ?source=."
     Scope="- GET /api/jobs?source=indeed`n- Filter control in dashboard"
     OutOfScope="New adapters"
     DoD="- [ ] Filter reduces list correctly"
     Verify="curl with ?source= and UI filter"
     Files="- src/serve-dashboard.ts, dashboard/app.js" },
  @{ Id="JH-T-B06-4-01"; Title="[Task] JH-T-B06-4-01 — Gherkin feature Mongo persistence"; Story="US-JH-B06-4"; Layer="docs"; Depends="JH-T-B06-3-01"; LayerLabel="layer:docs"
     Outcome="Gherkin feature for save run + list jobs."
     Scope="- gherkin/mongo-persistence.feature"
     OutOfScope="Automation code"
     DoD="- [ ] Feature with AC IDs"
     Verify="Review feature file"
     Files="- projects/qa-job-hunter/gherkin/" },
  @{ Id="JH-T-B06-4-02"; Title="[Task] JH-T-B06-4-02 — API tests GET /api/jobs"; Story="US-JH-B06-4"; Layer="qa"; Depends="JH-T-B06-3-01"; LayerLabel="layer:qa"
     Outcome="Automated test hits GET /api/jobs."
     Scope="- Postman collection or minimal node test"
     OutOfScope="Full Newman CI"
     DoD="- [ ] Test asserts 200 + array shape"
     Verify="Run test script"
     Files="- tests/api/jobs.test.ts" },
  @{ Id="JH-T-B06-4-03"; Title="[Task] JH-T-B06-4-03 — Subpage docs qa-job-hunter EN/ES"; Story="US-JH-B06-4"; Layer="docs"; Depends="JH-T-B06-3-02"; LayerLabel="layer:docs"
     Outcome="Portfolio subpage links to Mongo lab."
     Scope="- docs/projects/qa-job-hunter/index.html"
     OutOfScope="Full i18n pass"
     DoD="- [ ] Page live on GitHub Pages"
     Verify="Open site /docs/projects/qa-job-hunter/"
     Files="- docs/projects/qa-job-hunter/" }
)

$backlogLabel = @{ "B06" = "backlog:B-06"; "B13" = "backlog:B-13" }
foreach ($t in $tasks) {
  $bl = if ($t.Id -match "B06") { "backlog:B-06" } else { "backlog:B-13" }
  $sprint = if ($t.Story -match "B06-4") { @() } else { @("sprint-1") }
  $labels = @("task","type:task","track:po","mini-project:job-hunter", $bl, $t.LayerLabel) + $sprint
  $body = Format-TaskBody $t
  New-Issue $t.Title $body $labels | Out-Null
}

# Update Epic #9
$epicBody = @"
Epic ID: EPIC-JH
Goal: Agentic job search for QA roles — scrape, LLM match, dashboard, multi-source, tracking roadmap
Repo: projects/qa-job-hunter/

## Done (P-JH)
- [x] P-JH-01 LinkedIn scrape (#10 closed)
- [x] P-JH-02 LLM match (#11 closed)
- [x] P-JH-03 Dashboard (#12 closed)
- [x] P-JH-04 Feedback (#13 closed)

## Sprint 1 refined (B-06 + B-13)
- [ ] US-JH-B06-1 Persistencia local Mongo
- [ ] US-JH-B06-2 Write path
- [ ] US-JH-B06-3 Read path dashboard
- [ ] US-JH-B06-4 Lab QA (optional)
- [ ] US-JH-B13-0 Spike ToS
- [ ] US-JH-B13-1 Adapters + LinkedIn
- [ ] US-JH-B13-2 Fuentes LATAM
- [ ] US-JH-B13-3 Orquestación + UX

## Future
- [ ] B-07 Agent · B-08 Tracking · B-14 Site · B-15 CV · B-09 Generic · B-10 Monetization · B-12 OAuth · B-16 Cloud · B-11 Web3

Ref: projects/qa-job-hunter/BACKLOG-REFINED.md
"@
$epicFile = Join-Path $tmp "epic9.md"
Set-Content -Path $epicFile -Value $epicBody -Encoding UTF8
& $gh issue edit 9 --repo $repo --body-file $epicFile | Out-Null
Write-Host "Updated Epic #9"

Write-Host "`n=== Refinement complete ==="
Write-Host "See projects/qa-job-hunter/SPRINT-1-PLAN.md for Project board setup."
& $gh issue list --repo $repo --label "sprint-1" --limit 40
