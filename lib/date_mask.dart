import 'package:flutter/foundation.dart' show visibleForTesting; //, debugPrint;
import 'package:flutter/services.dart'
    show TextInputFormatter, TextEditingValue, TextSelection, TextRange;
import 'package:how_old/constants.dart';
import 'package:how_old/date_tokenizer.dart';
import 'package:how_old/utils/clip_text_value.dart';

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

    if (newText.length < oldText.length &&
        oldText.substring(0, newText.length) != newText) {
      return oldValue;
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

    newValue = skipAnySpaces(newValue);
    newValue = parseSeparator(newValue);

    newValue = skipAnySpaces(newValue);
    newValue = parseDay(newValue);

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
    return parseDigits(newValue, limit: 2);
  }

  @visibleForTesting
  TextEditingValue parseYear(TextEditingValue newValue) {
    return parseDigits(newValue, limit: 4);
  }

  @visibleForTesting
  TextEditingValue parseDigits(TextEditingValue newValue, {int? limit}) {
    var token = tokenizer.next(newValue.text);

    if (token.kind == TokenKind.eof) {
      return newValue;
    }

    if (token.kind != TokenKind.number) {
      throw InvalidTokenException(token: token);
    }

    var len = token.end - token.start;
    if (limit != null && len > limit) {
      final newPosition = token.start + limit;

      tokenizer.idx = newPosition;

      newValue = clipTextValue(newValue, newPosition);

      return newValue;
    }

    return newValue;
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
}
