# Reporte de pruebas — API ABM REST (Analista QA Senior)

**Proyecto:** api-testing  
**Versión contrato:** OpenAPI 1.0.0 (`openapi/abm-crud.yaml`)  
**Fecha:** 2026-06-04  
**Autor:** Portfolio QA  

---

## 1. Resumen ejecutivo

Se ejecutó la estrategia de pruebas contract-first sobre tres implementaciones del SUT (Node, Spring Boot, ASP.NET Core) para validar el ciclo ABM y listado de ítems. La cobertura se limitó a los **10 criterios de aceptación** definidos en la user story Gherkin. Las herramientas Postman, Rest-Assured, Playwright C# (API) y Selenium (Swagger UI) aportaron evidencia automatizada trazable a cada AC.

**Conclusión:** los tres SUTs cumplen el contrato en regresión de humo; la suite completa es reproducible con `docker compose up` y los comandos documentados en el README.

---

## 2. Alcance

### En alcance

- AC-001 a AC-010 (crear, validar, listar, filtrar, CRUD por id, errores 400/404)
- Pruebas manuales (Postman, Swagger) y automatizadas (Rest-Assured, Playwright, Selenium)
- Tres stacks: `sut/node-api`, `sut/spring-api`, `sut/dotnet-api`

### Fuera de alcance

- Seguridad (OWASP), concurrencia extrema (ver mini-proyecto Performance)
- Persistencia tras reinicio del proceso
- Contratos distintos al OpenAPI publicado

---

## 3. Estrategia de pruebas

| Nivel | Enfoque | Herramientas |
|-------|---------|--------------|
| Contrato | Fuente única OpenAPI | yaml + revisión en PR |
| API automatizada | Regresión por AC | Rest-Assured, Playwright C# |
| API manual | Exploración / evidencia | Postman, Swagger |
| UI acotada | Smoke Swagger (boundary UI) | Selenium Java |

**Riesgos mitigados:** divergencia entre SUTs → mismos casos parametrizados por `baseUrl`; falsos positivos en UI → Selenium solo valida presencia de operaciones en Swagger, no lógica duplicada.

---

## 4. Ambiente y datos

| Componente | Valor |
|------------|-------|
| Orquestación | Docker Compose |
| Node | http://localhost:3000 |
| Spring | http://localhost:8080 |
| .NET | http://localhost:5000 (host) → 8080 (contenedor) |
| Datos | Generados en runtime (in-memory); nombres prefijo `Item QA-*` / `Manual-*` |

---

## 5. Matriz de trazabilidad

| AC | TC Manual | TC Automatizado | Rest-Assured | Playwright | Selenium |
|----|-----------|-----------------|--------------|------------|----------|
| AC-001 | TC-M-001 | Ac001CreateItemTest | ✓ | ✓ | ✓ (UI) |
| AC-002 | TC-M-002 | Ac002CreateInvalidTest | ✓ | ✓ | — |
| AC-003 | TC-M-003 | Ac003ListPagedTest | ✓ | ✓ | — |
| AC-004 | TC-M-004 | Ac004FilterActiveTest | ✓ | ✓ | — |
| AC-005 | TC-M-005 | Ac005GetByIdTest | ✓ | ✓ | — |
| AC-006 | TC-M-006 | Ac006GetNotFoundTest | ✓ | ✓ | — |
| AC-007 | TC-M-007 | Ac007UpdateTest | ✓ | ✓ | — |
| AC-008 | TC-M-008 | Ac008UpdateNotFoundTest | ✓ | ✓ | — |
| AC-009 | TC-M-009 | Ac009DeleteTest | ✓ | ✓ | — |
| AC-010 | TC-M-010 | Ac010DeleteNotFoundTest | ✓ | ✓ | — |

---

## 6. Resultados

| SUT | Smoke API | Observaciones |
|-----|-----------|---------------|
| Node | PASS | Target por defecto en CI |
| Spring | PASS | UUID path alineado |
| .NET | PASS | Swagger en `/swagger` |

| Herramienta | Tests | Pass rate |
|-------------|-------|-----------|
| Rest-Assured | 10 | 100% (vs Node en CI) |
| Playwright C# | 10 | 100% (vs Node en CI) |
| Selenium | 1 smoke UI | PASS |

---

## 7. Defectos / observaciones

No se registraron defectos funcionales bloqueantes contra el contrato v1.0.0 en la última ejecución documentada.

**Observación:** GitHub Pages sirve solo documentación; los SUTs deben ejecutarse localmente o en pipeline con Docker.

---

## 8. Métricas y conclusiones

- **Cobertura AC:** 10/10 (100%)
- **Automatización API:** 10 casos × 2 frameworks (+ Selenium smoke UI)
- **Recomendación:** mantener OpenAPI como gate en PR; extender herramientas en `tools/README.md` (Karate, k6)

---

## 9. Anexos

Capturas de evidencia: `report/screenshots/` (Postman, Swagger, reportes de test).

Instrucciones de reproducción: ver [README.md](../../../README.md) en la raíz del monorepo.
