package template.harness.sample.domain;

public record NormalizedText(String value) {

    public NormalizedText {
        value = normalize(value);
    }

    public int length() {
        return value.codePointCount(0, value.length());
    }

    private static String normalize(String input) {
        if (input == null) {
            throw new IllegalArgumentException("text must not be null");
        }

        var normalized = new StringBuilder(input.length());
        var pendingWhitespace = false;

        for (var offset = 0; offset < input.length();) {
            var codePoint = input.codePointAt(offset);
            offset += Character.charCount(codePoint);

            if (isWhitespace(codePoint)) {
                pendingWhitespace = !normalized.isEmpty();
                continue;
            }

            if (pendingWhitespace) {
                normalized.append(' ');
                pendingWhitespace = false;
            }
            normalized.appendCodePoint(codePoint);
        }

        if (normalized.isEmpty()) {
            throw new IllegalArgumentException("text must not be blank");
        }
        return normalized.toString();
    }

    private static boolean isWhitespace(int codePoint) {
        return Character.isWhitespace(codePoint) || Character.isSpaceChar(codePoint);
    }
}
