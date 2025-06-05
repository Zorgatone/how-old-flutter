import 'package:flutter/services.dart';
import 'package:how_old/date_tokenizer.dart';

class InvalidTokenException implements Exception {
  final String message;
  final Token token;

  InvalidTokenException({required this.token})
    : message =
          'Invalid token: "${token.kind}" from position ${token.start} to position ${token.end}!';
}

class DateMask extends TextInputFormatter {
  final tokenizer = Tokenizer();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    // Tex content didn't change
    if (oldValue.text == newText) {
      return newValue;
    }

    // NOTE: can only paste valid dates
    if (RegExp(r'^\d{2}/\d{2}/\d{4,}$').hasMatch(newText)) {
      return newValue; // keep as-is
    }

    // Can only change 1 character at a time
    if ((oldValue.text.length - newText.length).abs() > 1) {
      return oldValue;
    }

    // var token = tokenizer.next(newText);

    // while (token.kind != TokenKind.eof) {
    //   switch (token.kind) {
    //     case TokenKind.invalid:
    //       return oldValue;
    //   }
    // }

    try {
      return parseDate(newValue);
    } on InvalidTokenException {
      return oldValue;
    }
  }

  TextEditingValue parseDate(TextEditingValue newValue) {
    if (tokenizer.idx == 0) {
      var nextToken = tokenizer.peek(newValue.text);

      while (nextToken.kind == TokenKind.space) {
        newValue = TextEditingValue(
          text: newValue.text.substring(nextToken.end),
          // selection: newValue.selection.baseOffset < 0 ? newValue.selection :
          //   newValue.selection.copyWith(
          //     baseOffset: newValue.selection.baseOffset
          //   )
          // TODO: handle selection
          selection: const TextSelection.collapsed(offset: -1),
          // TODO: handle composing
          composing: TextRange.empty,
        );
      }
    }

    newValue = parseDay(newValue);

    var nextToken = tokenizer.peek(newValue.text);

    while (nextToken.kind == TokenKind.space) {
      newValue = TextEditingValue(
        text: newValue.text.substring(nextToken.end),
        // selection: newValue.selection.baseOffset < 0 ? newValue.selection :
        //   newValue.selection.copyWith(
        //     baseOffset: newValue.selection.baseOffset
        //   )
        // TODO: handle selection
        selection: const TextSelection.collapsed(offset: -1),
        // TODO: handle composing
        composing: TextRange.empty,
      );
    }

    newValue = parseSeparator(newValue);

    while (nextToken.kind == TokenKind.space) {
      newValue = TextEditingValue(
        text: newValue.text.substring(nextToken.end),
        // selection: newValue.selection.baseOffset < 0 ? newValue.selection :
        //   newValue.selection.copyWith(
        //     baseOffset: newValue.selection.baseOffset
        //   )
        // TODO: handle selection
        selection: const TextSelection.collapsed(offset: -1),
        // TODO: handle composing
        composing: TextRange.empty,
      );
    }

    newValue = parseDay(newValue);

    return newValue;
  }

  TextEditingValue parseDay(TextEditingValue newValue) {
    final token = tokenizer.next(newValue.text);

    if (token.kind == TokenKind.eof) {
      return newValue;
    }

    if (token.kind != TokenKind.number) {
      throw InvalidTokenException(token: token);
    }

    return newValue;
  }

  TextEditingValue parseSeparator(TextEditingValue newValue) {
    final token = tokenizer.next(newValue.text);

    if (token.kind == TokenKind.eof) {
      return newValue;
    }

    if (token.kind != TokenKind.separator) {
      throw InvalidTokenException(token: token);
    }

    return newValue;
  }
}
