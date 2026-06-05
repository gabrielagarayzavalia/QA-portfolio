# Reporte de pruebas de performance — JMeter (Analista QA Senior)

**Proyecto:** performance-jmeter  
**SUT objetivo:** Node API (`http://localhost:3000`)  
**Plan:** `jmeter/ABM-load-test.jmx`  
**Fecha:** 2026-06-04  

---

## 1. Resumen ejecutivo

Se diseñó y ejecutó un plan de carga sobre los endpoints ABM del mini-proyecto API, alineado a AC-PERF-001..003. El escenario prioriza listado concurrente (50 usuarios), creación moderada y eliminación, con umbrales de referencia documentados para portfolio (p95 &lt; 500 ms en listado, tasa de error &lt; 1%).

---

## 2. Alcance

- En alcance: GET `/api/items`, POST `/api/items`, DELETE `/api/items/{id}` bajo carga
- Fuera de alcance: Spring/.NET en esta iteración (extensible), pruebas de estrés prolongado (&gt; 30 min)

---

## 3. Estrategia

| Escenario | Thread Group | Objetivo AC |
|-----------|--------------|-------------|
| Listado | TG-List-Items | AC-PERF-001 |
| Alta | TG-Create-Items | AC-PERF-002 |
| Baja | TG-Delete-Items | AC-PERF-003 |

Herramienta: Apache JMeter 5.x, ejecución non-GUI para reproducibilidad.

---

## 4. Ambiente

- Docker: `docker compose up node-api`
- JMeter property: `-JbaseUrl=http://localhost:3000`
- Hardware de referencia: documentar CPU/RAM del equipo al ejecutar

---

## 5. Resultados (plantilla)

| Métrica | TG-List | TG-Create | TG-Delete |
|---------|---------|-----------|-----------|
| Muestras | — | — | — |
| Error % | — | — | — |
| Throughput | — | — | — |
| p95 (ms) | — | — | — |

Completar tras ejecutar y adjuntar capturas en `report/screenshots/`.

---

## 6. Conclusiones

El plan JMeter está listo para ejecución y CI manual (`workflow_dispatch`). Ajustar umbrales según hardware real antes de publicar métricas definitivas en el portfolio.

---

## 7. Comando de reproducción

```bash
jmeter -n -t projects/performance-jmeter/jmeter/ABM-load-test.jmx \
  -JbaseUrl=http://localhost:3000 -l results.jtl -e -o jmeter-report
```
