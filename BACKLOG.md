# GGZenLab — Skills Backlog

Portfolio monorepo: [gabrielagarayzavalia/QA-portfolio](https://github.com/gabrielagarayzavalia/QA-portfolio)  
Live site (EN default, bilingual): `https://gabrielagarayzavalia.github.io/QA-portfolio/`

## Published (Done)

| ID | Skill | Deliverables |
|----|-------|--------------|
| P-01 | API Testing | 3 SUTs, Gherkin, Postman, Rest-Assured, Playwright C#, Selenium, Senior report |
| P-02 | Performance | JMeter plan, Gherkin AC-PERF, manual + CLI, report |

## In progress

| ID | Skill | Goal | Practice on site |
|----|-------|------|------------------|
| B-01 | **Docker** | Deep-dive lab: images, compose, healthchecks, troubleshooting | [Practice Labs](docs/guides/index.html) Lab 1 |
| B-02 | **CI/CD — GitHub Actions** | Extend workflows: Newman, matrix all SUTs, badges | Lab 3 + `.github/workflows/` |

## Planned

| ID | Skill | Goal | Accounts required |
|----|-------|------|-------------------|
| B-03 | **CI/CD — Azure DevOps** | Mirror pipelines (build SUTs, api-tests, Pages deploy) | **Azure** free account ([azure.microsoft.com](https://azure.microsoft.com/free/)) + **Azure DevOps** org ([dev.azure.com](https://dev.azure.com)) — DevOps basic tier is free, no credit card for pipelines on public repos |
| B-04 | **CI/CD — Jenkins** | `Jenkinsfile`, agent in Docker, same test stages | **No account** if Jenkins runs locally via `docker run jenkins/jenkins:lts`; optional CloudBees / other SaaS later |

## Account checklist

- [x] **GitHub** — `gabrielagarayzavalia` (repo + Actions + Pages)
- [ ] **Azure** — sign up for free tier when starting B-03
- [ ] **Azure DevOps** — create organization (e.g. `ggzenlab`) when starting B-03
- [ ] **Jenkins** — install via Docker only; no signup required for B-04

## Conventions per mini-project

Each backlog item ships with:

1. Gherkin user story + acceptance criteria  
2. Manual test cases  
3. Automated tests (where applicable)  
4. Senior QA report + screenshots  
5. Bilingual subpage under `docs/`  
6. Practice lab section in `docs/guides/`

## Suggested order

1. Finish Docker lab content (B-01) — document compose, logs, rebuild  
2. Harden GitHub Actions (B-02) — PR gates, artifacts  
3. Azure DevOps parallel pipeline (B-03)  
4. Jenkins pipeline as code (B-04)
