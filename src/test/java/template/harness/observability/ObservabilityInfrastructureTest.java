package template.harness.observability;

import static io.restassured.RestAssured.given;
import static io.restassured.http.ContentType.JSON;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.empty;
import static org.hamcrest.Matchers.equalTo;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.IOException;
import java.util.Properties;

import org.eclipse.microprofile.config.ConfigProvider;
import org.junit.jupiter.api.Test;

import io.opentelemetry.sdk.testing.exporter.InMemorySpanExporter;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.inject.Produces;
import jakarta.inject.Inject;
import jakarta.inject.Singleton;

@QuarkusTest
class ObservabilityInfrastructureTest {

    @Inject
    InMemorySpanExporter spanExporter;

    @Test
    void configuresStructuredLocalTelemetryWithoutNetworkExporter() throws IOException {
        var properties = loadApplicationProperties();

        assertEquals("quarkus-coding-harness-template", properties.getProperty("quarkus.application.name"));
        assertEquals("true", properties.getProperty("quarkus.log.console.json.enabled"));
        assertEquals("false", properties.getProperty("quarkus.log.console.json.pretty-print"));
        assertEquals("true", properties.getProperty("quarkus.log.console.json.mdc.flat-fields"));
        assertEquals("none", properties.getProperty("quarkus.otel.traces.exporter"));
        assertEquals("false", properties.getProperty("quarkus.otel.logs.enabled"));
        assertEquals("false", properties.getProperty("quarkus.otel.logs.handler.enabled"));
        assertEquals("none", properties.getProperty("quarkus.otel.logs.exporter"));
        assertEquals("cdi", properties.getProperty("%test.quarkus.otel.traces.exporter"));
        assertEquals("true", properties.getProperty("%test.quarkus.otel.simple"));

        var activeConfig = ConfigProvider.getConfig();
        assertEquals("cdi", activeConfig.getValue("quarkus.otel.traces.exporter", String.class));
        assertTrue(activeConfig.getValue("quarkus.otel.simple", Boolean.class));
        assertNotNull(spanExporter);
    }

    @Test
    void exposesLivenessAndReadinessWithoutSyntheticChecks() {
        given()
                .when().get("/q/health/live")
                .then()
                .statusCode(200)
                .body("status", equalTo("UP"))
                .body("checks", empty());

        given()
                .when().get("/q/health/ready")
                .then()
                .statusCode(200)
                .body("status", equalTo("UP"))
                .body("checks", empty());
    }

    @Test
    void exposesAutomaticHttpMetricsInPrometheusFormat() {
        given()
                .contentType(JSON)
                .body("{\"text\":\"observable sample\"}")
                .when().post("/api/sample/normalize")
                .then()
                .statusCode(200);

        given()
                .when().get("/q/metrics")
                .then()
                .statusCode(200)
                .body(containsString("http_server_requests_seconds_count"));
    }

    private static Properties loadApplicationProperties() throws IOException {
        var properties = new Properties();
        try (var stream = Thread.currentThread().getContextClassLoader()
                .getResourceAsStream("application.properties")) {
            assertNotNull(stream);
            properties.load(stream);
        }
        return properties;
    }
}

@ApplicationScoped
class InMemorySpanExporterProducer {

    @Produces
    @Singleton
    InMemorySpanExporter inMemorySpanExporter() {
        return InMemorySpanExporter.create();
    }
}
