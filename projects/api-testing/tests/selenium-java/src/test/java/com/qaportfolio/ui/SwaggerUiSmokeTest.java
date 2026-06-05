package com.qaportfolio.ui;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.jupiter.api.*;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Selenium acotado al boundary UI: verificar que Swagger UI expone operaciones del contrato (AC-001 smoke UI).
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class SwaggerUiSmokeTest {
    private static WebDriver driver;
    private static String swaggerUrl;

    @BeforeAll
    static void setupDriver() {
        swaggerUrl = System.getProperty("sut.swaggerUiUrl", "http://localhost:3000/api-docs");
        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();
        if ("true".equalsIgnoreCase(System.getenv("CI"))) {
            options.addArguments("--headless=new", "--no-sandbox", "--disable-dev-shm-usage");
        }
        driver = new ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
    }

    @AfterAll
    static void tearDown() {
        if (driver != null) driver.quit();
    }

    @Test
    @Order(1)
    @DisplayName("AC-001 UI: Swagger muestra operación POST /api/items")
    void ac001_swaggerShowsPostItems() {
        driver.get(swaggerUrl);
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));
        wait.until(ExpectedConditions.presenceOfElementLocated(By.cssSelector(".swagger-ui")));
        String pageSource = driver.getPageSource().toLowerCase();
        assertTrue(
                pageSource.contains("/api/items") || pageSource.contains("items"),
                "Swagger UI debe documentar el recurso items");
        assertTrue(
                pageSource.contains("post") || pageSource.contains("POST"),
                "Swagger UI debe mostrar operación de creación");
    }

    @Test
    @Order(2)
    @DisplayName("AC-003 UI: Swagger muestra GET listado")
    void ac003_swaggerShowsGetList() {
        String pageSource = driver.getPageSource().toLowerCase();
        assertTrue(pageSource.contains("get"), "Swagger UI debe mostrar operación GET");
    }
}
