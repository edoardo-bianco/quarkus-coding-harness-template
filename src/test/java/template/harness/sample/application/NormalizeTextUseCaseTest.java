package template.harness.sample.application;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.Test;

class NormalizeTextUseCaseTest {

    private final NormalizeTextUseCase useCase = new NormalizeTextUseCase();

    @Test
    void returnsNormalizedText() {
        var result = useCase.execute("  Olá\t mundo 😀  ");

        assertEquals("Olá mundo 😀", result.value());
        assertEquals(11, result.length());
    }

    @Test
    void preservesDomainValidation() {
        assertThrows(IllegalArgumentException.class, () -> useCase.execute("\t\u2003"));
    }
}
