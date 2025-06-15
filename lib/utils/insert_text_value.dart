import 'package:flutter/services.dart'
    show TextEditingValue, TextSelection, TextRange;

TextEditingValue insertTextValue(
  TextEditingValue value, {
  required int index,
  required String text,
}) {
  String newText;

  if (index == 0) {
    newText = text + value.text;
  } else if (index == value.text.length) {
    newText = value.text + text;
  } else {
    newText =
        value.text.substring(0, index) + text + value.text.substring(index);
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
