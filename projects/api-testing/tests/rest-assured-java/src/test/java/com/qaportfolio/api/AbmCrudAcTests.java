package com.qaportfolio.api;

import io.restassured.http.ContentType;
import org.junit.jupiter.api.*;

import java.util.Map;
import java.util.UUID;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class AbmCrudAcTests extends BaseApiTest {
    private static String createdId;

    @Test
    @Order(1)
    @DisplayName("AC-001 Create valid item")
    void ac001_createItem() {
        createdId = given()
                .contentType(ContentType.JSON)
                .body(Map.of(
                        "name", "Item QA-001",
                        "description", "Rest-Assured",
                        "active", true))
                .when()
                .post("/api/items")
                .then()
                .statusCode(201)
                .body("id", notNullValue())
                .body("name", equalTo("Item QA-001"))
                .extract()
                .path("id");
    }

    @Test
    @Order(2)
    @DisplayName("AC-002 Create invalid name")
    void ac002_createInvalid() {
        given()
                .contentType(ContentType.JSON)
                .body(Map.of("name", ""))
                .when()
                .post("/api/items")
                .then()
                .statusCode(400)
                .body("message", notNullValue());
    }

    @Test
    @Order(3)
    @DisplayName("AC-003 List paged")
    void ac003_listPaged() {
        given()
                .queryParam("page", 0)
                .queryParam("size", 10)
                .when()
                .get("/api/items")
                .then()
                .statusCode(200)
                .body("content", notNullValue())
                .body("totalElements", greaterThanOrEqualTo(0));
    }

    @Test
    @Order(4)
    @DisplayName("AC-004 Filter active")
    void ac004_filterActive() {
        createFreshItem();
        given()
                .queryParam("active", true)
                .when()
                .get("/api/items")
                .then()
                .statusCode(200)
                .body("content", notNullValue());
    }

    @Test
    @Order(5)
    @DisplayName("AC-005 Get by id")
    void ac005_getById() {
        Assumptions.assumeTrue(createdId != null);
        given()
                .when()
                .get("/api/items/" + createdId)
                .then()
                .statusCode(200)
                .body("id", equalTo(createdId));
    }

    @Test
    @Order(6)
    @DisplayName("AC-006 Get not found")
    void ac006_getNotFound() {
        given()
                .when()
                .get("/api/items/00000000-0000-0000-0000-000000000099")
                .then()
                .statusCode(404);
    }

    @Test
    @Order(7)
    @DisplayName("AC-007 Update item")
    void ac007_update() {
        String id = createFreshItem();
        given()
                .contentType(ContentType.JSON)
                .body(Map.of("name", "Item QA-007-up", "active", false))
                .when()
                .put("/api/items/" + id)
                .then()
                .statusCode(200)
                .body("name", equalTo("Item QA-007-up"));
    }

    @Test
    @Order(8)
    @DisplayName("AC-008 Update not found")
    void ac008_updateNotFound() {
        given()
                .contentType(ContentType.JSON)
                .body(Map.of("name", "X"))
                .when()
                .put("/api/items/00000000-0000-0000-0000-000000000099")
                .then()
                .statusCode(404);
    }

    @Test
    @Order(9)
    @DisplayName("AC-009 Delete item")
    void ac009_delete() {
        String id = createFreshItem();
        given().when().delete("/api/items/" + id).then().statusCode(204);
    }

    @Test
    @Order(10)
    @DisplayName("AC-010 Delete not found")
    void ac010_deleteNotFound() {
        given()
                .when()
                .delete("/api/items/00000000-0000-0000-0000-000000000099")
                .then()
                .statusCode(404);
    }

    private static String createFreshItem() {
        return given()
                .contentType(ContentType.JSON)
                .body(Map.of("name", "Temp-" + UUID.randomUUID(), "active", true))
                .when()
                .post("/api/items")
                .then()
                .statusCode(201)
                .extract()
                .path("id");
    }
}
