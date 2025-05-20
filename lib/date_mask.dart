import 'package:flutter/services.dart';
import 'package:how_old/date_tokenizer.dart';

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
