# Seed issues for GitHub Projects

Create these via **Issues → New issue** (templates) after pushing the repo.  
Then add them to project **GGZenLab Portfolio**.

**Product Owner (QA Job Hunter):** see [SEED_ISSUES_JOB_HUNTER.md](SEED_ISSUES_JOB_HUNTER.md).

---

## Epic 1 — API Testing

**Title:** `[Epic] EPIC-API — API Testing mini-project`  
**Labels:** `epic`, `type:epic`, `mini-project:api`

**Body:**
```
Epic ID: EPIC-API
Goal: Contract-first ABM API testing across Node, Spring, .NET SUTs
Repo: projects/api-testing/

Deliverables:
- [x] Gherkin abm-crud.feature
- [x] Manual test cases
- [x] Postman, Rest-Assured, Playwright, Selenium
- [x] Senior report
- [ ] All AC tasks closed in GitHub Projects
```

---

## Epic 2 — Performance

**Title:** `[Epic] EPIC-PERF — Performance JMeter`  
**Labels:** `epic`, `type:epic`, `mini-project:perf`

**Body:**
```
Epic ID: EPIC-PERF
Goal: Load tests on ABM API per AC-PERF-001..003
Repo: projects/performance-jmeter/
```

---

## User Story — API ABM

**Title:** `[Story] US-API-ABM — REST ABM and listing`  
**Labels:** `user-story`, `type:story`, `mini-project:api`

**Body:**
```
Story ID: US-API-ABM
Parent Epic: EPIC-API
Gherkin: projects/api-testing/gherkin/abm-crud.feature

As a senior QA analyst
I want to validate REST ABM and listing per OpenAPI contract
So that each SUT meets acceptance criteria

AC boundary:
- [ ] AC-001 POST valid → 201
- [ ] AC-002 POST invalid → 400
- [ ] AC-003 GET list paged → 200
- [ ] AC-004 GET filter active → 200
- [ ] AC-005 GET by id → 200
- [ ] AC-006 GET not found → 404
- [ ] AC-007 PUT update → 200
- [ ] AC-008 PUT not found → 404
- [ ] AC-009 DELETE → 204
- [ ] AC-010 DELETE not found → 404
```

---

## User Story — Performance

**Title:** `[Story] US-PERF-JMETER — Load on ABM API`  
**Labels:** `user-story`, `type:story`, `mini-project:perf`

**Body:**
```
Story ID: US-PERF-JMETER
Parent Epic: EPIC-PERF
Gherkin: projects/performance-jmeter/gherkin/performance.feature

AC:
- [ ] AC-PERF-001 List under 50 users, p95 target
- [ ] AC-PERF-002 POST under load
- [ ] AC-PERF-003 DELETE error rate < 1%
```

---

## Sample tasks (create 2–3 to start, then expand)

| Title | Labels | AC | Tool |
|-------|--------|-----|------|
| `[Task] TC-M-001 — Manual POST create (Postman)` | `task`, `mini-project:api` | AC-001 | Postman |
| `[Task] TC-A-001 — Automate AC-001 Rest-Assured` | `task`, `mini-project:api` | AC-001 | Rest-Assured |
| `[Task] TC-A-001 — Automate AC-001 Playwright` | `task`, `mini-project:api` | AC-001 | Playwright |
| `[Task] TC-P-M-001 — JMeter list load test` | `task`, `mini-project:perf` | AC-PERF-001 | JMeter |

**Task body template:**
```
Task ID: TC-A-001
Parent Story: US-API-ABM
AC-ID: AC-001

Steps:
cd projects/api-testing/tests/rest-assured-java
mvn test -Dsut.baseUrl=http://localhost:3000 -Dtest=AbmCrudAcTests#ac001_createItem

DoD:
- [ ] Executed and result recorded
- [ ] Screenshot or CI link attached
```
