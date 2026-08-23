package template.harness.sample.domain;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.Test;

class NormalizedTextTest {

    @Test
    void normalizesUnicodeWhitespaceWithoutChangingContentOrCase() {
        var normalized = new NormalizedText("\u2003  Olá\t\n Mundo  \u2007");

        assertEquals("Olá Mundo", normalized.value());
    }

    @Test
    void countsSupplementaryUnicodeAsOneCodePoint() {
        var normalized = new NormalizedText("A 😀");

        assertEquals(3, normalized.length());
    }

    @Test
    void rejectsNull() {
        assertThrows(IllegalArgumentException.class, () -> new NormalizedText(null));
    }

    @Test
    void rejectsEmptyText() {
        assertThrows(IllegalArgumentException.class, () -> new NormalizedText(""));
    }

    @Test
    void rejectsTextContainingOnlyUnicodeWhitespace() {
        assertThrows(IllegalArgumentException.class, () -> new NormalizedText("\t \u2003\u2007"));
    }
}
