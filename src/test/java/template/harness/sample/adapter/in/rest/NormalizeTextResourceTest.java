package template.harness.sample.adapter.in.rest;

import static io.restassured.RestAssured.given;
import static io.restassured.http.ContentType.JSON;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.hasItem;
import static org.hamcrest.Matchers.hasKey;
import static org.junit.jupiter.api.Assertions.assertFalse;

import java.util.Locale;

import org.junit.jupiter.api.Test;

import io.quarkus.test.junit.QuarkusTest;

@QuarkusTest
class NormalizeTextResourceTest {

    private static final String ENDPOINT = "/api/sample/normalize";

    @Test
    void normalizesTextAndIgnoresAdditionalProperties() {
        given()
                .contentType(JSON)
                .body("{\"text\":\"  Olá\\t Mundo  \",\"futureField\":true}")
                .when().post(ENDPOINT)
                .then()
                .statusCode(200)
                .contentType(JSON)
                .body("value", equalTo("Olá Mundo"))
                .body("length", equalTo(9));
    }

    @Test
    void rejectsMissingBodyWithPublicError() {
        given()
                .contentType(JSON)
                .when().post(ENDPOINT)
                .then()
                .statusCode(400)
                .contentType(JSON)
                .body("code", equalTo("INVALID_TEXT"))
                .body("message", equalTo("text must contain non-whitespace content"));
    }

    @Test
    void rejectsMissingTextWithPublicError() {
        assertInvalidText("{}");
    }

    @Test
    void rejectsNullTextWithPublicError() {
        assertInvalidText("{\"text\":null}");
    }

    @Test
    void rejectsEmptyTextWithPublicError() {
        assertInvalidText("{\"text\":\"\"}");
    }

    @Test
    void rejectsUnicodeWhitespaceWithPublicError() {
        assertInvalidText("{\"text\":\"\\t   \"}");
    }

    @Test
    void rejectsMalformedJsonWithoutInternalDetails() {
        var body = given()
                .contentType(JSON)
                .body("{\"text\":")
                .when().post(ENDPOINT)
                .then()
                .statusCode(400)
                .extract().asString()
                .toLowerCase(Locale.ROOT);

        assertFalse(body.contains("stacktrace"));
        assertFalse(body.contains("jsonparseexception"));
        assertFalse(body.contains("com.fasterxml.jackson"));
    }

    @Test
    void publishesApprovedOpenApiContract() {
        given()
                .accept(JSON)
                .when().get("/q/openapi?format=json")
                .then()
                .statusCode(200)
                .body("paths.'/api/sample/normalize'.post.operationId", equalTo("normalizeSampleText"))
                .body("paths.'/api/sample/normalize'.post.requestBody.required", equalTo(true))
                .body("paths.'/api/sample/normalize'.post.requestBody.content", hasKey("application/json"))
                .body("paths.'/api/sample/normalize'.post.responses", hasKey("200"))
                .body("paths.'/api/sample/normalize'.post.responses", hasKey("400"))
                .body("paths.'/api/sample/normalize'.post.responses.'200'.content", hasKey("application/json"))
                .body("paths.'/api/sample/normalize'.post.responses.'400'.content", hasKey("application/json"))
                .body("components.schemas", hasKey("NormalizeTextRequest"))
                .body("components.schemas", hasKey("NormalizeTextResponse"))
                .body("components.schemas", hasKey("NormalizeTextError"))
                .body("components.schemas.NormalizeTextRequest.required", hasItem("text"));
    }

    private static void assertInvalidText(String body) {
        given()
                .contentType(JSON)
                .body(body)
                .when().post(ENDPOINT)
                .then()
                .statusCode(400)
                .contentType(JSON)
                .body("code", equalTo("INVALID_TEXT"))
                .body("message", equalTo("text must contain non-whitespace content"));
    }
}
