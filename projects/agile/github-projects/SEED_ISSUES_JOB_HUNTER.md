# Seed issues — QA Job Hunter (refined PO track)

**Refinement:** [`BACKLOG-REFINED.md`](../../qa-job-hunter/BACKLOG-REFINED.md) · **Migrate:** `scripts/refine-job-hunter-issues.ps1` · **Sprint 1:** [`SPRINT-1-PLAN.md`](../../qa-job-hunter/SPRINT-1-PLAN.md)

**GitHub (post-migrate):** stories **#35–#42** · tasks **#43–#67** · superseded **#14, #15, #25–#29, #33, #34** · epic **#9**

Templates: **Epic (PO)**, **User Story (PO)**, **PO Task**, **PO Sub-task**

Labels: `track:po`, `mini-project:job-hunter`, `backlog:B-06|B-13`, `layer:*`, `priority:high`

---

## Epic (unchanged)

**Title:** `[Epic] EPIC-JH — QA Job Hunter (Product Owner)` · Issue **#9**

Checklist actualizado por script de refinement con stories US-JH-B06-* y US-JH-B13-*.

---

## Stories — Sprint 1 refined

### US-JH-B06-1 — Persistencia local Mongo

**Title:** `[Story] US-JH-B06-1 — Persistencia local Mongo`  
**Labels:** `user-story`, `type:story`, `track:po`, `mini-project:job-hunter`, `backlog:B-06`, `priority:high`

```
Story ID: US-JH-B06-1
Backlog ID: B-06
Parent Epic: EPIC-JH
Supersedes: #14 (partial)

As a job seeker
I want MongoDB running locally with seed from existing JSON
So that I can persist data without losing history

AC (tasks):
- [ ] JH-T-B06-1-01 — mongo:7 in compose + healthcheck
- [ ] JH-T-B06-1-02 — src/db/client.ts + MONGODB_URI
- [ ] JH-T-B06-1-03 — npm run db:seed
- [ ] JH-T-B06-1-04 — README Mongo setup
```

### US-JH-B06-2 — Write path post-análisis

**Title:** `[Story] US-JH-B06-2 — Write path post-análisis`  
**Labels:** `user-story`, `type:story`, `track:po`, `mini-project:job-hunter`, `backlog:B-06`, `priority:high`

```
Story ID: US-JH-B06-2
Backlog ID: B-06
Parent Epic: EPIC-JH
Depends on: US-JH-B06-1
Supersedes: #14 (partial), #26 (partial)

As a job seeker
I want each analysis run saved to Mongo with job dedup
So that re-runs do not duplicate offers

AC (tasks):
- [ ] JH-T-B06-2-01 — collections + indexes
- [ ] JH-T-B06-2-02 — saveRun()
- [ ] JH-T-B06-2-03 — upsertJobs() dedup by url/id
- [ ] JH-T-B06-2-04 — hook in 3-analyze-match.ts
```

### US-JH-B06-3 — Read path dashboard

**Title:** `[Story] US-JH-B06-3 — Read path dashboard`  
**Labels:** `user-story`, `type:story`, `track:po`, `mini-project:job-hunter`, `backlog:B-06`, `priority:high`

```
Story ID: US-JH-B06-3
Backlog ID: B-06
Parent Epic: EPIC-JH
Depends on: US-JH-B06-2
Supersedes: #14 (partial)

As a job seeker
I want the dashboard to load jobs from Mongo via API
So that I query history without reading JSON files

AC (tasks):
- [ ] JH-T-B06-3-01 — GET /api/jobs?sort=&order=
- [ ] JH-T-B06-3-02 — dashboard app.js uses /api/jobs
- [ ] JH-T-B06-3-03 — feedback API works with Mongo job ids
```

### US-JH-B06-4 — Lab QA Mongo (optional Sprint 1 / Sprint 2)

**Title:** `[Story] US-JH-B06-4 — Lab QA Mongo`  
**Labels:** `user-story`, `type:story`, `track:po`, `mini-project:job-hunter`, `backlog:B-06`

```
Story ID: US-JH-B06-4
Backlog ID: B-06
Parent Epic: EPIC-JH
Depends on: US-JH-B06-3

As a portfolio QA practitioner
I want Gherkin, API tests, and docs for the Mongo lab
So that B-06 is publishable on GGZenLab Portfolio

AC (tasks):
- [ ] JH-T-B06-4-01 — Gherkin feature
- [ ] JH-T-B06-4-02 — API tests GET /api/jobs
- [ ] JH-T-B06-4-03 — docs/projects/qa-job-hunter EN/ES
```

### US-JH-B13-0 — Spike ToS multi-fuente

**Title:** `[Story] US-JH-B13-0 — Spike ToS multi-fuente`  
**Labels:** `user-story`, `type:story`, `track:po`, `mini-project:job-hunter`, `backlog:B-13`, `priority:high`

```
Story ID: US-JH-B13-0
Backlog ID: B-13
Parent Epic: EPIC-JH
Supersedes: #27

As product owner
I want a research doc on ToS and rate limits per job board
So that we know legal/technical risk before scraping

AC (tasks):
- [ ] JH-T-B13-0-01 — projects/qa-job-hunter/docs/sources-research.md
```

### US-JH-B13-1 — Contrato adapters + LinkedIn

**Title:** `[Story] US-JH-B13-1 — Contrato adapters + LinkedIn`  
**Labels:** `user-story`, `type:story`, `track:po`, `mini-project:job-hunter`, `backlog:B-13`, `priority:high`

```
Story ID: US-JH-B13-1
Backlog ID: B-13
Parent Epic: EPIC-JH
Depends on: US-JH-B06-2
Supersedes: #28

As a job seeker
I want LinkedIn scrape behind JobSourceAdapter
So that adding sources does not duplicate scrape logic

AC (tasks):
- [ ] JH-T-B13-1-01 — JobSourceAdapter + JobListing.source/externalId
- [ ] JH-T-B13-1-02 — LinkedInAdapter from 2-scrape-jobs.ts
- [ ] JH-T-B13-1-03 — fixture tests LinkedIn (no network)
```

### US-JH-B13-2 — Fuentes LATAM MVP

**Title:** `[Story] US-JH-B13-2 — Fuentes LATAM MVP`  
**Labels:** `user-story`, `type:story`, `track:po`, `mini-project:job-hunter`, `backlog:B-13`, `priority:high`

```
Story ID: US-JH-B13-2
Backlog ID: B-13
Parent Epic: EPIC-JH
Depends on: US-JH-B13-1
Supersedes: #29, #33 (partial)

As a job seeker
I want GetOnBoard and Indeed AR as job sources
So that I see offers beyond LinkedIn

AC (tasks):
- [ ] JH-T-B13-2-01 — GetOnBoardAdapter MVP
- [ ] JH-T-B13-2-02 — IndeedAdapter AR MVP
- [ ] JH-T-B13-2-03 — contract test all adapters → JobListing
```

### US-JH-B13-3 — Orquestación + UX fuente

**Title:** `[Story] US-JH-B13-3 — Orquestación + UX fuente`  
**Labels:** `user-story`, `type:story`, `track:po`, `mini-project:job-hunter`, `backlog:B-13`, `priority:high`

```
Story ID: US-JH-B13-3
Backlog ID: B-13
Parent Epic: EPIC-JH
Depends on: US-JH-B13-2, US-JH-B06-3
Supersedes: #33 (partial), #34

As a job seeker
I want one run to scrape all enabled sources and filter by site in the dashboard
So that multi-source search feels unified

AC (tasks):
- [ ] JH-T-B13-3-01 — scrape-orchestrator.ts + config
- [ ] JH-T-B13-3-02 — run-all.ts uses orchestrator
- [ ] JH-T-B13-3-03 — source badge in list + detail
- [ ] JH-T-B13-3-04 — filter by source + GET /api/jobs?source=
```

---

## Tasks — bodies (template applied)

Use **PO Task** template fields. Full bodies generated by `refine-job-hunter-issues.ps1`.

| ID | Title | Layer | Depends |
|----|-------|-------|---------|
| JH-T-B06-1-01 | Docker mongo:7 in compose + healthcheck | infra | — |
| JH-T-B06-1-02 | src/db/client.ts + MONGODB_URI | db | 1-01 |
| JH-T-B06-1-03 | npm run db:seed from jobs-result.json | pipeline | 1-02 |
| JH-T-B06-1-04 | README Mongo local setup | docs | 1-01 |
| JH-T-B06-2-01 | Collections + indexes analysis_runs, jobs, skipped_jobs | db | 1-02 |
| JH-T-B06-2-02 | Repo saveRun() | db | 2-01 |
| JH-T-B06-2-03 | Repo upsertJobs() dedup url/id | db | 2-01 |
| JH-T-B06-2-04 | Hook 3-analyze-match.ts persist after analyze | pipeline | 2-02, 2-03 |
| JH-T-B06-3-01 | GET /api/jobs in serve-dashboard.ts | api | 2-04 |
| JH-T-B06-3-02 | dashboard app.js → /api/jobs | ui | 3-01 |
| JH-T-B06-3-03 | Feedback API compatible Mongo jobs | api | 3-01 |
| JH-T-B13-0-01 | Doc ToS/rate limits per source | docs | — |
| JH-T-B13-1-01 | JobSourceAdapter + extend JobListing types | adapter | 2-01 |
| JH-T-B13-1-02 | LinkedInAdapter refactor | adapter | 1-01 |
| JH-T-B13-1-03 | Fixture tests LinkedIn adapter | qa | 1-02 |
| JH-T-B13-2-01 | GetOnBoardAdapter MVP | adapter | 1-01 |
| JH-T-B13-2-02 | IndeedAdapter AR MVP | adapter | 1-01 |
| JH-T-B13-2-03 | Contract test JobListing from all adapters | qa | 2-01, 2-02 |
| JH-T-B13-3-01 | scrape-orchestrator.ts + sources config | pipeline | 1-02, 2-01, 2-02 |
| JH-T-B13-3-02 | Integrate orchestrator in run-all.ts | pipeline | 3-01 |
| JH-T-B13-3-03 | Source badge list + detail UI | ui | 3-02 |
| JH-T-B13-3-04 | Source filter + GET /api/jobs?source= | api | 3-03, 3-01 |
| JH-T-B06-4-01 | Gherkin feature Mongo persistence | docs | 3-01 |
| JH-T-B06-4-02 | API tests GET /api/jobs | qa | 3-01 |
| JH-T-B06-4-03 | Subpage docs/projects/qa-job-hunter | docs | 3-02 |

---

## Sprint 1 board setup

See [`SPRINT-1-PLAN.md`](../../qa-job-hunter/SPRINT-1-PLAN.md) for WIP order and GitHub Project steps. Script: `scripts/add-sprint-1-to-project.ps1` (issues **#35–#64** → Sprint 1 iteration).

**Superseded issues (closed):** #14, #15, #25–#29, #33, #34 (B-06/B-13 tasks only; #30–#32 remain for future sprints)

**Refined issues live:** #35–#67

**New issue link:** https://github.com/gabrielagarayzavalia/GGZenLab-Portfolio/issues/new/choose
