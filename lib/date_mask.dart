import 'package:flutter/services.dart';

class DateMask extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // TODO: automatically fix input text
    return newValue;
  }
}
