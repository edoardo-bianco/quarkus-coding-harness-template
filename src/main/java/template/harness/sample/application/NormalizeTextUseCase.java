package template.harness.sample.application;

import org.jboss.logging.Logger;
import org.jboss.logging.MDC;

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import io.opentelemetry.api.trace.Span;
import io.opentelemetry.api.trace.SpanKind;
import io.opentelemetry.instrumentation.annotations.WithSpan;
import jakarta.enterprise.context.ApplicationScoped;
import template.harness.sample.domain.NormalizedText;

@ApplicationScoped
public class NormalizeTextUseCase {

    private static final Logger LOG = Logger.getLogger(NormalizeTextUseCase.class);
    private static final String EVENT = "sample.normalize.completed";
    private static final String SPAN_NAME = "sample.normalize";
    private static final String OUTCOME_ATTRIBUTE = "sample.normalize.outcome";
    private static final String METRIC_NAME = "sample.normalize.duration";
    private static final String SUCCESS = "success";
    private static final String INVALID = "invalid";

    private final MeterRegistry meterRegistry;

    public NormalizeTextUseCase(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
    }

    @WithSpan(value = SPAN_NAME, kind = SpanKind.INTERNAL)
    public NormalizedText execute(String text) {
        var sample = Timer.start(meterRegistry);
        var outcome = SUCCESS;
        try {
            return new NormalizedText(text);
        } catch (IllegalArgumentException exception) {
            outcome = INVALID;
            throw exception;
        } finally {
            Span.current().setAttribute(OUTCOME_ATTRIBUTE, outcome);
            sample.stop(Timer.builder(METRIC_NAME)
                    .description("Duration of sample text normalization")
                    .tag("outcome", outcome)
                    .publishPercentileHistogram()
                    .register(meterRegistry));
            logCompletion(outcome);
        }
    }

    private static void logCompletion(String outcome) {
        try {
            MDC.put("event", EVENT);
            MDC.put("outcome", outcome);
            LOG.info(EVENT);
        } finally {
            MDC.remove("outcome");
            MDC.remove("event");
        }
    }
}
