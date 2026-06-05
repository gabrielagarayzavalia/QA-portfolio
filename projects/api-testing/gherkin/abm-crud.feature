@api @abm @contract-first
Feature: ABM y listado de ítems vía API REST
  Como analista de calidad senior
  Quiero validar el ciclo ABM y el listado según el contrato OpenAPI
  Para asegurar que cada implementación del SUT cumple los criterios de aceptación

  # Acceptance Criteria (boundary de pruebas)
  # AC-001: POST válido → 201 + ítem con id
  # AC-002: POST name inválido → 400
  # AC-003: GET listado paginado → 200
  # AC-004: GET listado filtro active → 200 solo activos
  # AC-005: GET por id existente → 200
  # AC-006: GET por id inexistente → 404
  # AC-007: PUT existente → 200
  # AC-008: PUT inexistente → 404
  # AC-009: DELETE existente → 204
  # AC-010: DELETE inexistente → 404

  Background:
    Given el SUT está disponible en la URL base configurada

  @AC-001 @smoke
  Scenario: Crear ítem con datos válidos
    When envío una petición POST a "/api/items" con cuerpo:
      | name        | description   | active |
      | Item QA-001 | Prueba AC-001 | true   |
    Then el código de respuesta es 201
    And el cuerpo JSON contiene el campo "id"
    And el campo "name" del cuerpo es "Item QA-001"

  @AC-002
  Scenario: Rechazar creación sin nombre válido
    When envío una petición POST a "/api/items" con cuerpo:
      | name | description |
      |      | Sin nombre    |
    Then el código de respuesta es 400
    And el cuerpo JSON contiene el campo "message"

  @AC-003
  Scenario: Listar ítems con paginación
    Given existe al menos un ítem en el sistema
    When envío una petición GET a "/api/items?page=0&size=10"
    Then el código de respuesta es 200
    And el cuerpo JSON contiene "content", "page", "size", "totalElements" y "totalPages"

  @AC-004
  Scenario: Filtrar listado por ítems activos
    Given existe un ítem activo y uno inactivo
    When envío una petición GET a "/api/items?active=true"
    Then el código de respuesta es 200
    And todos los ítems en "content" tienen "active" en true

  @AC-005
  Scenario: Obtener ítem por id existente
    Given creé un ítem mediante POST
    When envío una petición GET a "/api/items/{id}" usando el id creado
    Then el código de respuesta es 200
    And el campo "id" del cuerpo coincide con el id solicitado

  @AC-006
  Scenario: Obtener ítem inexistente
    When envío una petición GET a "/api/items/00000000-0000-0000-0000-000000000099"
    Then el código de respuesta es 404

  @AC-007
  Scenario: Actualizar ítem existente
    Given creé un ítem mediante POST
    When envío una petición PUT a "/api/items/{id}" con cuerpo:
      | name           | active |
      | Item QA-007-up | false  |
    Then el código de respuesta es 200
    And el campo "name" del cuerpo es "Item QA-007-up"

  @AC-008
  Scenario: Actualizar ítem inexistente
    When envío una petición PUT a "/api/items/00000000-0000-0000-0000-000000000099" con cuerpo:
      | name | active |
      | X    | true   |
    Then el código de respuesta es 404

  @AC-009
  Scenario: Eliminar ítem existente
    Given creé un ítem mediante POST
    When envío una petición DELETE a "/api/items/{id}"
    Then el código de respuesta es 204

  @AC-010
  Scenario: Eliminar ítem inexistente
    When envío una petición DELETE a "/api/items/00000000-0000-0000-0000-000000000099"
    Then el código de respuesta es 404
