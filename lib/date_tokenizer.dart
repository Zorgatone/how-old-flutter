enum TokenKind { space, separator, number, invalid, eof }

class Token {
  final TokenKind kind;
  final int start;
  final int end;

  const Token({required this.kind, required this.start, required this.end});

  String getSubstring(String input) {
    return input.substring(start, end);
  }
}

bool isSpace(int codeUnit) {
  return codeUnit == 0x20;
}

bool isDigit(int codeUnit) {
  return 0x30 <= codeUnit && codeUnit <= 0x39;
}

bool isSeparator(int codeUnit) {
  return 0x2F == codeUnit || 0x2D == codeUnit || 0x2E == codeUnit;
}

class Tokenizer {
  int idx = 0;

  Token peek(String input) {
    var old = idx;
    Token token = next(input);
    idx = old;

    return token;
  }

  Token next(String input) {
    var iterator = RuneIterator.at(input, idx); // restore position

    // Move to the first rune
    if (!iterator.moveNext()) {
      return Token(kind: TokenKind.eof, start: idx, end: idx);
    }

    var start = iterator.rawIndex;

    // Skip any starting space
    while (isSpace(iterator.current)) {
      idx = iterator.rawIndex + iterator.currentSize;
      if (!iterator.moveNext()) {
        return Token(kind: TokenKind.space, start: start, end: idx);
      }

      return Token(kind: TokenKind.space, start: start, end: idx);
    }

    if (isDigit(iterator.current)) {
      while (isDigit(iterator.current)) {
        idx = iterator.rawIndex + iterator.currentSize;
        if (!iterator.moveNext()) {
          return Token(kind: TokenKind.number, start: start, end: idx);
        }
      }

      return Token(kind: TokenKind.number, start: start, end: idx);
    }

    if (isSeparator(iterator.current)) {
      idx = iterator.rawIndex + iterator.currentSize;
      return Token(kind: TokenKind.separator, start: start, end: idx);
    }

    idx = iterator.rawIndex + iterator.currentSize;

    return Token(kind: TokenKind.invalid, start: start, end: idx);
  }
}
