package template.harness.observability;

import static io.restassured.RestAssured.given;
import static io.restassured.http.ContentType.JSON;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.TimeUnit;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;
import java.util.stream.Collectors;

import org.jboss.logmanager.ExtLogRecord;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import io.micrometer.core.instrument.Meter;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import io.opentelemetry.api.OpenTelemetry;
import io.opentelemetry.api.common.AttributeKey;
import io.opentelemetry.api.trace.SpanKind;
import io.opentelemetry.sdk.OpenTelemetrySdk;
import io.opentelemetry.sdk.testing.exporter.InMemorySpanExporter;
import io.opentelemetry.sdk.trace.data.SpanData;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;

@QuarkusTest
class ObservabilityContractTest {

    private static final String ENDPOINT = "/api/sample/normalize";
    private static final String EVENT = "sample.normalize.completed";
    private static final String SPAN_NAME = "sample.normalize";
    private static final String OUTCOME_ATTRIBUTE = "sample.normalize.outcome";
    private static final String METRIC_NAME = "sample.normalize.duration";
    private static final String PAYLOAD_MARKER = "sensitive-marker-8b";

    @Inject
    InMemorySpanExporter spanExporter;

    @Inject
    OpenTelemetry openTelemetry;

    @Inject
    MeterRegistry meterRegistry;

    private final CapturingHandler logHandler = new CapturingHandler();
    private Logger rootLogger;

    @BeforeEach
    void resetSignals() {
        forceFlushSpans();
        spanExporter.reset();
        meterRegistry.getMeters().stream()
                .filter(meter -> METRIC_NAME.equals(meter.getId().getName()))
                .toList()
                .forEach(meterRegistry::remove);

        rootLogger = Logger.getLogger("");
        logHandler.setLevel(Level.ALL);
        rootLogger.addHandler(logHandler);
    }

    @AfterEach
    void stopCapturingLogs() {
        rootLogger.removeHandler(logHandler);
        logHandler.close();
    }

    @Test
    void emitsBoundedCorrelatedSignalsForSuccessAndInvalidOutcome() {
        given()
                .contentType(JSON)
                .body("{\"text\":\"  " + PAYLOAD_MARKER + "  \"}")
                .when().post(ENDPOINT)
                .then()
                .statusCode(200);

        given()
                .contentType(JSON)
                .body("{\"text\":\"\\t  \"}")
                .when().post(ENDPOINT)
                .then()
                .statusCode(400);

        var spans = finishedSpans();
        var useCaseSpans = spans.stream()
                .filter(span -> SPAN_NAME.equals(span.getName()))
                .collect(Collectors.toMap(this::outcome, span -> span));
        assertEquals(Set.of("success", "invalid"), useCaseSpans.keySet());
        useCaseSpans.forEach((outcome, span) -> assertInternalChildSpan(spans, outcome, span));

        var observedLogs = logHandler.logs().stream()
                .filter(log -> EVENT.equals(log.message()))
                .collect(Collectors.toMap(log -> log.mdc().get("outcome"), log -> log));
        assertEquals(Set.of("success", "invalid"), observedLogs.keySet());
        observedLogs.forEach((outcome, log) -> assertCorrelatedLog(outcome, log, useCaseSpans.get(outcome)));

        var timers = meters(METRIC_NAME).stream()
                .map(Timer.class::cast)
                .collect(Collectors.toMap(timer -> timer.getId().getTag("outcome"), timer -> timer));
        assertEquals(Set.of("success", "invalid"), timers.keySet());
        timers.forEach(this::assertBoundedTimer);

        var prometheus = given()
                .when().get("/q/metrics")
                .then()
                .statusCode(200)
                .extract().asString();
        assertTrue(prometheus.contains("sample_normalize_duration_seconds_bucket"));
        assertTrue(prometheus.contains("outcome=\"success\""));
        assertTrue(prometheus.contains("outcome=\"invalid\""));

        var observedSignals = observedLogs + "\n" + useCaseSpans + "\n" + timers + "\n" + prometheus;
        assertFalse(observedSignals.contains(PAYLOAD_MARKER));
    }

    @Test
    void malformedJsonCreatesOnlyAutomaticHttpSignals() {
        given()
                .contentType(JSON)
                .body("{\"text\":")
                .when().post(ENDPOINT)
                .then()
                .statusCode(400);

        var spans = finishedSpans();
        assertTrue(spans.stream().anyMatch(span -> span.getKind() == SpanKind.SERVER));
        assertFalse(spans.stream().anyMatch(span -> SPAN_NAME.equals(span.getName())));
        assertFalse(logHandler.logs().stream().anyMatch(log -> EVENT.equals(log.message())));
        assertTrue(meters(METRIC_NAME).isEmpty());

        var prometheus = given()
                .when().get("/q/metrics")
                .then()
                .statusCode(200)
                .extract().asString();
        assertTrue(prometheus.contains("http_server_requests_seconds_count"));
    }

    private void assertInternalChildSpan(List<SpanData> allSpans, String expectedOutcome, SpanData span) {
        assertEquals(SpanKind.INTERNAL, span.getKind());
        assertEquals(expectedOutcome, outcome(span));

        var parent = allSpans.stream()
                .filter(candidate -> candidate.getSpanId().equals(span.getParentSpanId()))
                .findFirst()
                .orElseThrow();
        assertEquals(SpanKind.SERVER, parent.getKind());
        assertEquals(parent.getTraceId(), span.getTraceId());
    }

    private static void assertCorrelatedLog(String outcome, ObservedLog log, SpanData span) {
        assertEquals(Level.INFO, log.level());
        assertEquals(EVENT, log.mdc().get("event"));
        assertEquals(outcome, log.mdc().get("outcome"));
        assertEquals(span.getTraceId(), log.mdc().get("traceId"));
        assertEquals(span.getSpanId(), log.mdc().get("spanId"));
        assertNull(log.thrown());
    }

    private void assertBoundedTimer(String outcome, Timer timer) {
        assertNotNull(timer);
        assertEquals(outcome, timer.getId().getTag("outcome"));
        assertEquals(1, timer.getId().getTags().size());
        assertEquals(1, timer.count());
    }

    private List<Meter> meters(String name) {
        return meterRegistry.getMeters().stream()
                .filter(meter -> name.equals(meter.getId().getName()))
                .toList();
    }

    private List<SpanData> finishedSpans() {
        forceFlushSpans();
        return spanExporter.getFinishedSpanItems();
    }

    private void forceFlushSpans() {
        ((OpenTelemetrySdk) openTelemetry).getSdkTracerProvider().forceFlush().join(10, TimeUnit.SECONDS);
    }

    private String outcome(SpanData span) {
        return span.getAttributes().get(AttributeKey.stringKey(OUTCOME_ATTRIBUTE));
    }

    private static final class CapturingHandler extends Handler {

        private final List<ObservedLog> logs = new CopyOnWriteArrayList<>();

        @Override
        public void publish(LogRecord record) {
            if (record instanceof ExtLogRecord extLogRecord && record.getMessage() != null) {
                logs.add(new ObservedLog(
                        record.getMessage(),
                        extLogRecord.getMdcCopy(),
                        record.getThrown(),
                        record.getLevel()));
            }
        }

        @Override
        public void flush() {
            // No pending state: records are copied synchronously.
        }

        @Override
        public void close() {
            logs.clear();
        }

        List<ObservedLog> logs() {
            return new ArrayList<>(logs);
        }
    }

    private record ObservedLog(String message, Map<String, String> mdc, Throwable thrown, Level level) {
    }
}
