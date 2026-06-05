# Casos de prueba manuales — API ABM

**User story:** `gherkin/abm-crud.feature`  
**Boundary:** solo AC-001 a AC-010. Fuera de alcance: autenticación, rate limiting, persistencia entre reinicios.

| ID | AC | Precondición | Pasos | Datos | Resultado esperado | SUT | Evidencia |
|----|-----|--------------|-------|-------|-------------------|-----|-----------|
| TC-M-001 | AC-001 | SUT up, Postman env seleccionado | POST /api/items | name: "Manual-001", active: true | 201, body con id | Node/Spring/.NET | screenshot Postman |
| TC-M-002 | AC-002 | SUT up | POST /api/items body `{}` o name vacío | name: "" | 400 + message | Los 3 | screenshot |
| TC-M-003 | AC-003 | ≥1 ítem creado | GET /api/items?page=0&size=5 | — | 200, estructura paginada | Los 3 | screenshot |
| TC-M-004 | AC-004 | 1 activo + 1 inactivo | GET ?active=true | — | Solo active=true en content | Los 3 | screenshot |
| TC-M-005 | AC-005 | Ítem creado (guardar id) | GET /api/items/{id} | id válido | 200, mismos datos | Los 3 | screenshot |
| TC-M-006 | AC-006 | — | GET uuid inexistente | 00000000-0000-0000-0000-000000000099 | 404 | Los 3 | screenshot |
| TC-M-007 | AC-007 | Ítem creado | PUT /api/items/{id} | name actualizado | 200, name nuevo | Los 3 | screenshot |
| TC-M-008 | AC-008 | — | PUT id inexistente | cualquier body | 404 | Los 3 | screenshot |
| TC-M-009 | AC-009 | Ítem creado | DELETE /api/items/{id} | id válido | 204 | Los 3 | screenshot |
| TC-M-010 | AC-010 | — | DELETE id inexistente | uuid falso | 404 | Los 3 | screenshot |

## Smoke manual Swagger

| ID | Herramienta | Pasos | AC cubiertos |
|----|-------------|-------|--------------|
| TC-M-SW-01 | Swagger UI | Abrir UI, ejecutar POST /api/items Try it out | AC-001 |
| TC-M-SW-02 | Swagger UI | GET list + GET by id desde UI | AC-003, AC-005 |

## Notas de ejecución

- Importar colección desde `../postman/ABM-CRUD.postman_collection.json`
- Environments: `env-node.json`, `env-spring.json`, `env-dotnet.json`
