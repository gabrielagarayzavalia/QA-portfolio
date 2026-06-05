package com.qaportfolio.api;

import io.restassured.RestAssured;
import org.junit.jupiter.api.BeforeAll;

public abstract class BaseApiTest {
    @BeforeAll
    static void setup() {
        String base = System.getProperty("sut.baseUrl", "http://localhost:3000");
        RestAssured.baseURI = base;
    }
}
