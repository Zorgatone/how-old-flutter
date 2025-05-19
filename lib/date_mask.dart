import 'package:flutter/services.dart';

enum TokenKind { separator, number, invalid, eof }

class Token {
  TokenKind kind;
  int start;
  int end;

  Token(this.kind, this.start, this.end);
}

bool isSpace(int codeUnit) {
  return codeUnit == 0x20;
}

bool isDigit(int codeUnit) {
  return 0x30 <= codeUnit && codeUnit <= 0x39;
}

bool isSeparator(int codeUnit) {
  return 0x2F == codeUnit || 0x2D == codeUnit;
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
      return Token(TokenKind.eof, 0, 0);
    }

    // Skip any starting space
    while (isSpace(iterator.current)) {
      idx = iterator.rawIndex + iterator.currentSize;
      if (!iterator.moveNext()) {
        return Token(TokenKind.eof, idx, idx);
      }
    }

    if (isDigit(iterator.current)) {
      var start = iterator.rawIndex;
      while (isDigit(iterator.current)) {
        idx = iterator.rawIndex + iterator.currentSize;
        if (!iterator.moveNext()) {
          return Token(TokenKind.number, start, idx);
        }
      }

      return Token(TokenKind.number, start, idx);
    }

    if (isSeparator(iterator.current)) {
      var start = iterator.rawIndex;
      idx = iterator.rawIndex + iterator.currentSize;
      return Token(TokenKind.separator, start, idx);
    }

    var start = iterator.rawIndex;
    idx = iterator.rawIndex + iterator.currentSize;

    return Token(TokenKind.invalid, start, idx);
  }
}

class DateMask extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var regexp = RegExp(r'^[0-9]{2}/[0-9]{2}/[0-9]+$');

    var tokenizer = Tokenizer();
    var token = tokenizer.next(newValue.text);
    while (token.kind != TokenKind.eof) {
      token = tokenizer.next(newValue.text);
    }

    if (regexp.hasMatch(newValue.text)) {
      return newValue;
    } // 10/07/1992

    return newValue;
  }
}
