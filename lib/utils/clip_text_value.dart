import 'package:flutter/services.dart'
    show TextEditingValue, TextSelection, TextRange;

TextEditingValue clipTextValue(TextEditingValue value, int start, [int? end]) {
  if (start < 0) {
    return TextEditingValue.empty;
  }

  var newText = value.text.substring(0, start);

  if (end != null) {
    newText += value.text.substring(end);
  }

  return TextEditingValue(
    text: newText,
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
