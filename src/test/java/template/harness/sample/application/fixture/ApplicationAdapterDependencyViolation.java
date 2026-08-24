package template.harness.sample.application.fixture;

import io.quarkus.arc.Unremovable;
import template.harness.sample.adapter.in.rest.NormalizeTextRequest;

public final class ApplicationAdapterDependencyViolation {

    private NormalizeTextRequest request;

    @Unremovable
    public static final class QuarkusUsageAllowed {
    }
}
