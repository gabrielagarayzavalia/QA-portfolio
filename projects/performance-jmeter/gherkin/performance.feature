@performance @jmeter @api-abm
Feature: Pruebas de rendimiento sobre API ABM
  Como analista de calidad senior
  Quiero medir el comportamiento de la API bajo carga
  Para validar que cumple los criterios de aceptación de performance

  # AC-PERF-001: GET listado — 50 usuarios concurrentes, p95 referencia < 500 ms
  # AC-PERF-002: POST creación — carga moderada sin errores HTTP (tasa error < 1%)
  # AC-PERF-003: DELETE — tasa de error < 1% bajo carga configurada

  Background:
    Given el SUT Node está disponible en la URL base de performance
    And el plan de pruebas JMeter "ABM-load-test.jmx" está configurado

  @AC-PERF-001
  Scenario: Listado soporta usuarios concurrentes con latencia aceptable
    When ejecuto el Thread Group "TG-List-Items" con 50 hilos durante 30 segundos
    Then el porcentaje de errores es menor al 1%
    And el percentil 95 de GET "/api/items" es menor a 500 ms

  @AC-PERF-002
  Scenario: Creación de ítems bajo carga moderada
    When ejecuto el Thread Group "TG-Create-Items" con 20 hilos y 10 iteraciones
    Then todas las respuestas POST retornan código 201 o 400 de validación esperada
    And la tasa de errores HTTP 5xx es cero

  @AC-PERF-003
  Scenario: Eliminación bajo carga sin degradación catastrófica
    When ejecuto el Thread Group "TG-Delete-Items" tras preparar datos
    Then la tasa de errores es menor al 1%
    And no hay timeouts superiores al umbral configurado en JMeter
