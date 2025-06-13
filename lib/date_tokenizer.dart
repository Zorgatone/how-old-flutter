import 'package:flutter/foundation.dart';

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

/// Returns true if the given code unit represents a space character.
@visibleForTesting
bool isSpace(int codeUnit) {
  return codeUnit == 0x20;
}

/// Returns true if the given code unit represents a digit character [0-9].
@visibleForTesting
bool isDigit(int codeUnit) {
  return 0x30 <= codeUnit && codeUnit <= 0x39;
}

/// Returns true if the given code unit represents a separator character [.-/].
@visibleForTesting
bool isSeparator(int codeUnit) {
  return 0x2D <= codeUnit && codeUnit <= 0x2F;
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

    if (isSpace(iterator.current)) {
      do {
        idx = iterator.rawIndex + iterator.currentSize;
        if (!iterator.moveNext()) {
          return Token(kind: TokenKind.space, start: start, end: idx);
        }
      } while (isSpace(iterator.current));

      return Token(kind: TokenKind.space, start: start, end: idx);
    }

    if (isDigit(iterator.current)) {
      do {
        idx = iterator.rawIndex + iterator.currentSize;
        if (!iterator.moveNext()) {
          return Token(kind: TokenKind.number, start: start, end: idx);
        }
      } while (isDigit(iterator.current));

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
