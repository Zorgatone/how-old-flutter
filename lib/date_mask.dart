import 'package:flutter/foundation.dart' show visibleForTesting; //, debugPrint;
import 'package:flutter/services.dart'
    show TextInputFormatter, TextEditingValue, TextSelection, TextRange;
import 'package:how_old/constants.dart';
import 'package:how_old/date_tokenizer.dart';
import 'package:how_old/utils/clip_text_value.dart';
import 'package:how_old/utils/insert_text_value.dart';

class InvalidTokenException implements Exception {
  final String message;
  final Token token;

  InvalidTokenException({required this.token})
    : message =
          'Invalid token: "${token.kind}" from position ${token.start} to position ${token.end}!';
}

class DateMask extends TextInputFormatter {
  final tokenizer = Tokenizer();
  // final watch = Stopwatch();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // watch.reset();
    // watch.start();

    // try {
    final newText = newValue.text;
    final oldText = oldValue.text;

    // Text content didn't change
    if (oldText == newText) {
      return newValue;
    }

    // clear field
    if (oldText.isNotEmpty && newText.isEmpty) {
      return newValue;
    }

    // NOTE: can only paste valid dates
    if (RegExp(validDateRegexp).hasMatch(newText)) {
      return newValue; // keep as-is
    }

    // Can only change 1 character (rune) at a time
    if ((oldText.runes.length - newText.runes.length).abs() > 1) {
      return oldValue;
    }

    if (newText.length < oldText.length) {
      return oldText.substring(0, newText.length) == newText
          ? newValue
          : oldValue;
    }

    try {
      tokenizer.idx = 0;
      final parsed = parseDate(newValue);

      // debugPrint('returned parsed text: "${parsed.text}"');
      return parsed;
    } on InvalidTokenException catch (exception) {
      // debugPrint('old: "${oldValue.text}" new: "$newText"');
      if (exception.token.end == newText.runes.indexed.last.$1) {
        // if (exception.token.start >= newText.length) {
        //   debugPrint(
        //     'token.start ${exception.token.start} is greater the text.length ${newText.length}',
        //   );
        // }

        final result = TextEditingValue(
          text: newValue.text.substring(0, exception.token.start),
          // selection: newValue.selection.baseOffset < 0 ? newValue.selection :
          //   newValue.selection.copyWith(
          //     baseOffset: newValue.selection.baseOffset
          //   )
          // TODO: handle selection
          selection: const TextSelection.collapsed(offset: -1),
          // TODO: handle composing
          composing: TextRange.empty,
        );

        // debugPrint('returned modified new text: "${result.text}"');
        return result;
      }
    }

    // debugPrint('returned old text: "${oldValue.text}"');
    return oldValue;
    // } finally {
    //   watch.stop();
    //   debugPrint(
    //     'DateMask.formatEditUpdate executed in ${watch.elapsedMicroseconds} microseconds  ',
    //   );
    // }
  }

  @visibleForTesting
  TextEditingValue parseDate(TextEditingValue newValue) {
    newValue = skipAnySpaces(newValue);
    newValue = parseDay(newValue);

    var token = tokenizer.peek(newValue.text);

    if (token.kind == TokenKind.number && token.end == newValue.text.length) {
      newValue = insertTextValue(newValue, index: token.start, text: separator);
    }

    newValue = skipAnySpaces(newValue);
    newValue = parseSeparator(newValue);

    newValue = skipAnySpaces(newValue);
    newValue = parseMonth(newValue);

    token = tokenizer.peek(newValue.text);

    if (token.kind == TokenKind.number && token.end == newValue.text.length) {
      newValue = insertTextValue(newValue, index: token.start, text: separator);
    }

    newValue = skipAnySpaces(newValue);
    newValue = parseSeparator(newValue);

    newValue = skipAnySpaces(newValue);
    newValue = parseYear(newValue);

    newValue = skipAnySpaces(newValue);

    var nextToken = tokenizer.next(newValue.text);

    if (nextToken.kind != TokenKind.eof) {
      throw InvalidTokenException(token: nextToken);
    }

    return newValue;
  }

  @visibleForTesting
  TextEditingValue skipAnySpaces(TextEditingValue newValue) {
    var nextToken = tokenizer.peek(newValue.text);

    while (nextToken.kind == TokenKind.space) {
      newValue = clipTextValue(newValue, nextToken.start, nextToken.end);
      nextToken = tokenizer.peek(newValue.text);
    }

    return newValue;
  }

  @visibleForTesting
  TextEditingValue parseDay(TextEditingValue newValue) {
    final token = parseDigits(newValue, limit: 2);
    assert(token.start == 0);

    var len = token.end - token.start;

    if (len == 1 && token.end == newValue.text.length) {
      var num = int.parse(newValue.text.substring(token.start, token.end));
      assert(num < 10);

      if (num > 3) {
        newValue = insertTextValue(newValue, index: token.start, text: '0');
        newValue = insertTextValue(
          newValue,
          index: newValue.text.length,
          text: separator,
        );

        tokenizer.idx = newValue.text.length;

        return newValue;
      }
    }

    return addSeparatorToEnd(newValue, token: token, requiredLength: 2);
  }

  @visibleForTesting
  TextEditingValue parseMonth(TextEditingValue newValue) {
    final token = parseDigits(newValue, limit: 2);
    var len = token.end - token.start;

    if (len == 1 && token.end == newValue.text.length) {
      var num = int.parse(newValue.text.substring(token.start, token.end));
      assert(num < 10);

      if (num > 1) {
        newValue = insertTextValue(newValue, index: token.start, text: '0');
        newValue = insertTextValue(
          newValue,
          index: newValue.text.length,
          text: separator,
        );

        tokenizer.idx = newValue.text.length;

        return newValue;
      }
    }

    return addSeparatorToEnd(newValue, token: token, requiredLength: 2);
  }

  @visibleForTesting
  TextEditingValue parseYear(TextEditingValue newValue) {
    parseDigits(newValue, limit: 4);

    return newValue;
  }

  @visibleForTesting
  Token parseDigits(TextEditingValue newValue, {int? limit}) {
    var token = tokenizer.next(newValue.text);

    if (token.kind == TokenKind.eof) {
      return token;
    }

    if (token.kind != TokenKind.number) {
      throw InvalidTokenException(token: token);
    }

    var len = token.end - token.start;
    if (limit != null && len > limit) {
      final newPosition = token.start + limit;

      tokenizer.idx = newPosition;

      return token;
    }

    return token;
  }

  @visibleForTesting
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

  @visibleForTesting
  TextEditingValue addSeparatorToEnd(
    TextEditingValue newValue, {
    required Token token,
    required int requiredLength,
  }) {
    assert(requiredLength == 2);
    assert(token.kind == TokenKind.number || token.kind == TokenKind.eof);
    assert(
      token.kind == TokenKind.eof ||
          (0 <= token.start && token.start < newValue.text.length),
    );
    assert(
      token.kind == TokenKind.eof ||
          (token.start < token.end && token.end <= newValue.text.length),
    );

    if (token.end < newValue.text.length) {
      // don't add separator if we're not at the end of the input string
      return newValue;
    }

    final len = token.end - token.start;
    if (len == requiredLength) {
      return insertTextValue(
        newValue,
        index: newValue.text.length,
        text: separator,
      );
    }

    return newValue;
  }
}
