# Casos de prueba manuales — Performance JMeter

| ID | AC | Precondición | Pasos | Resultado esperado | Evidencia |
|----|-----|--------------|-------|-------------------|-----------|
| TC-P-M-001 | AC-PERF-001 | SUT Node up, JMeter instalado | Abrir JMX, ejecutar TG-List-Items, revisar Aggregate Report | p95 &lt; 500 ms (referencia), errores &lt; 1% | screenshot dashboard |
| TC-P-M-002 | AC-PERF-002 | Mismo | Ejecutar TG-Create-Items | Sin 5xx, POST mayormente 201 | screenshot |
| TC-P-M-003 | AC-PERF-003 | Ítems precargados vía setup | Ejecutar TG-Delete-Items | Errores &lt; 1% | screenshot |
| TC-P-M-004 | — | — | Calibrar ramp-up y loops antes de comparar SUTs | Documentar en reporte | notas |

## CLI automatizada

Ver `../jmeter/README.md` y reporte Senior.
