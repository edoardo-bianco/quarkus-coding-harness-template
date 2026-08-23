package template.harness.sample.application;

import template.harness.sample.domain.NormalizedText;

public final class NormalizeTextUseCase {

    public NormalizedText execute(String text) {
        return new NormalizedText(text);
    }
}
