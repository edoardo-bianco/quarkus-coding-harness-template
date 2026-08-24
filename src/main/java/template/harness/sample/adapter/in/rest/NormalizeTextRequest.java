package template.harness.sample.adapter.in.rest;

import org.eclipse.microprofile.openapi.annotations.media.Schema;

@Schema(name = "NormalizeTextRequest", requiredProperties = "text")
public record NormalizeTextRequest(
        @Schema(description = "Text to normalize")
        String text) {
}
