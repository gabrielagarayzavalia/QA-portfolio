# GitHub Projects — GGZenLab agile setup

Tool chosen for **B-05 Agile PM**: [GitHub Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects) (no extra account — uses `gabrielagarayzavalia`).

## Quick links (after push)

| Resource | URL |
|----------|-----|
| New Project | https://github.com/users/gabrielagarayzavalia/projects/new |
| Repo Issues | https://github.com/gabrielagarayzavalia/QA-portfolio/issues |
| New Issue (templates) | https://github.com/gabrielagarayzavalia/QA-portfolio/issues/new/choose |

## Step 1 — Create the project board

1. Open https://github.com/users/gabrielagarayzavalia/projects/new
2. **Name:** `GGZenLab QA Portfolio`
3. **Template:** *Team backlog* (or *Board*)
4. Link repository: `gabrielagarayzavalia/QA-portfolio`

## Step 2 — Configure views

### Board view (Kanban)

Add **Status** column values:

| Status | Usage |
|--------|--------|
| Backlog | Not started |
| Ready | Refined, ready for sprint |
| In progress | Active work |
| In review | PR / report review |
| Done | Accepted + evidence |

### Table view

Show fields: **Title**, **Status**, **Labels**, **AC-ID** (custom text field), **Mini-project** (single select).

Optional custom fields (Project → ⚙️ → Fields):

- `AC-ID` (text) — e.g. AC-001
- `Mini-project` (single select) — api-testing, performance-jmeter, docker, cicd
- `Tool` (single select) — Postman, Rest-Assured, etc.

## Step 3 — Labels (create in repo)

Repo → **Issues** → **Labels** → New label:

| Label | Color suggestion | Purpose |
|-------|------------------|---------|
| `epic` | `#7057ff` | Mini-project / skill area |
| `user-story` | `#0e8a16` | Gherkin-aligned story |
| `task` | `#fbca04` | Manual or automation task |
| `type:epic` | `#7057ff` | Issue template default |
| `type:story` | `#0e8a16` | Issue template default |
| `type:task` | `#fbca04` | Issue template default |
| `mini-project:api` | `#1d76db` | API testing |
| `mini-project:perf` | `#d93f0b` | Performance |
| `ac-smoke` | `#bfd4f2` | Smoke / CI scope |

## Step 4 — Seed issues (recommended order)

Use issue templates (`.github/ISSUE_TEMPLATE/`) or copy from [SEED_ISSUES.md](SEED_ISSUES.md).

1. **Epic** → API Testing (`EPIC-API`)
2. **Epic** → Performance (`EPIC-PERF`)
3. **User Story** → `US-API-ABM` (links to `abm-crud.feature`)
4. **User Story** → `US-PERF-JMETER` (links to `performance.feature`)
5. **Tasks** → one per AC or per tool (see seed file)

Add all issues to the project: Project → **Add item** → search issues.

## Step 5 — Sprint practice (1 week simulation)

1. Move `US-API-ABM` + tasks AC-001…AC-003 to **Ready**
2. **In progress:** run Docker lab + Rest-Assured smoke
3. **In review:** attach Actions run link or screenshot to task
4. **Done:** when AC checked in issue + report updated

## Traceability

```
Epic (EPIC-API)
  └── User Story (US-API-ABM) ← gherkin/abm-crud.feature
        ├── Task TC-M-001 (manual Postman) → AC-001
        ├── Task TC-A-001 (Rest-Assured) → AC-001
        └── Task TC-A-001 (Playwright) → AC-001
```

Link issues: use **Development** sidebar or reference `Parent #N` in task body.

## Portfolio evidence

When a story is **Done**, add to Senior report:

- GitHub Project screenshot → `projects/api-testing/report/screenshots/`
- Issue URLs in traceability matrix

See also: [docs/guides/index.html](../../../docs/guides/index.html) Lab 4 (site).
