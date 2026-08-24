package template.harness.sample.adapter.in.rest;

import org.eclipse.microprofile.openapi.annotations.Operation;
import org.eclipse.microprofile.openapi.annotations.media.Content;
import org.eclipse.microprofile.openapi.annotations.media.Schema;
import org.eclipse.microprofile.openapi.annotations.parameters.RequestBody;
import org.eclipse.microprofile.openapi.annotations.responses.APIResponse;
import org.eclipse.microprofile.openapi.annotations.responses.APIResponses;

import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import template.harness.sample.application.NormalizeTextUseCase;

@Path("/api/sample/normalize")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public final class NormalizeTextResource {

    private static final String INVALID_TEXT_CODE = "INVALID_TEXT";
    private static final String INVALID_TEXT_MESSAGE = "text must contain non-whitespace content";

    private final NormalizeTextUseCase useCase = new NormalizeTextUseCase();

    @POST
    @Operation(operationId = "normalizeSampleText", summary = "Normalize sample text")
    @RequestBody(required = true, content = @Content(
            mediaType = MediaType.APPLICATION_JSON,
            schema = @Schema(implementation = NormalizeTextRequest.class)))
    @APIResponses({
            @APIResponse(responseCode = "200", description = "Normalized text", content = @Content(
                    mediaType = MediaType.APPLICATION_JSON,
                    schema = @Schema(implementation = NormalizeTextResponse.class))),
            @APIResponse(responseCode = "400", description = "Invalid text", content = @Content(
                    mediaType = MediaType.APPLICATION_JSON,
                    schema = @Schema(implementation = NormalizeTextError.class)))
    })
    public Response normalize(NormalizeTextRequest request) {
        if (request == null || request.text() == null) {
            return invalidText();
        }

        try {
            var normalized = useCase.execute(request.text());
            var response = new NormalizeTextResponse(normalized.value(), normalized.length());
            return Response.ok(response).build();
        } catch (IllegalArgumentException ignored) {
            return invalidText();
        }
    }

    private static Response invalidText() {
        return Response.status(Response.Status.BAD_REQUEST)
                .entity(new NormalizeTextError(INVALID_TEXT_CODE, INVALID_TEXT_MESSAGE))
                .build();
    }

    @Schema(name = "NormalizeTextError")
    public record NormalizeTextError(String code, String message) {
    }
}
