# Herramientas extensibles

Carpeta reservada para incorporar nuevas herramientas sin modificar la estructura base del mini-proyecto API.

## Plantilla para agregar una herramienta

1. Crear subcarpeta, por ejemplo `karate/` o `k6-api/`
2. Documentar en README local: prerequisitos, comando de ejecución, variable `baseUrl`
3. Mapear tests a tags `@AC-xxx` de `../gherkin/abm-crud.feature`
4. Actualizar matriz en `../report/REPORTE-SENIOR-QA.md`

## Candidatos sugeridos

| Herramienta | Uso | Carpeta sugerida |
|-------------|-----|------------------|
| Karate DSL | API BDD | `karate/` |
| Bruno | Colección Git-friendly | `bruno/` |
| k6 | API + performance ligera | `k6/` |
| Newman | CI Postman | usar colección en `../postman/` |
