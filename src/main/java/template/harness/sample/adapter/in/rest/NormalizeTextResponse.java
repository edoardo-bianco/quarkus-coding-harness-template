package template.harness.sample.adapter.in.rest;

import org.eclipse.microprofile.openapi.annotations.media.Schema;

@Schema(name = "NormalizeTextResponse")
public record NormalizeTextResponse(
        @Schema(description = "Normalized text")
        String value,
        @Schema(description = "Number of Unicode code points in the normalized text")
        int length) {
}
