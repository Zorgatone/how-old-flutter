import 'package:flutter/material.dart';
import 'package:how_old/date_mask.dart';

const _inputTextStyle = TextStyle(
  fontFamily: 'RobotoMono',
  fontSize: 15,
  fontWeight: FontWeight.normal,
  wordSpacing: 0,
  letterSpacing: 0,
  color: Colors.black,
);

const dateFormatHint = 'dd/mm/yyyy';

class DateField extends StatefulWidget {
  const DateField({super.key, this.labelText});

  final String? labelText;

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  final _editingController = TextEditingController();
  final _hintTextStyle = _inputTextStyle.copyWith(color: Colors.black45);
  final _focusNode = FocusNode();

  var isValid = true;
  var isFocused = false;
  var textValue = '';

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final regexp = RegExp(r'^\d{2}/\d{2}/\d{4,}$'); // TODO: check this
    isValid = regexp.hasMatch(textValue);

    final labelText = widget.labelText;

    return Stack(
      children: [
        TextField(
          controller: _editingController,
          focusNode: _focusNode,
          onChanged: (text) {
            setState(() {
              textValue = text;
            });
          },
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          // enableInteractiveSelection: false,
          // contextMenuBuilder: null,
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: [DateMask()],
          decoration: InputDecoration(
            labelText: labelText,
            // hintText: dateFormatHint,
            hintStyle: _hintTextStyle,
            errorText: isValid || textValue.isEmpty ? null : 'Invalid date',
          ),
          style: _inputTextStyle,
        ),
        Visibility(
          // visible: !isValid && textValue.isNotEmpty && isFocused,
          visible: !isValid && isFocused,
          child: Positioned(
            left:
                _boundingTextSize(
                  _editingController.text,
                  _inputTextStyle,
                ).width,
            top: labelText != null && labelText.isNotEmpty ? 24 : 12.5,
            child: Text(
              _editingController.text.length >= dateFormatHint.length
                  ? ''
                  : dateFormatHint.substring(_editingController.text.length),
              style: _hintTextStyle,
            ),
          ),
        ),
      ],
    );

    // ignore: dead_code
    @override
    // ignore: unused_element
    void dispose() {
      _editingController.dispose();
      _focusNode.dispose();
      super.dispose();
    }
  }

  static Size _boundingTextSize(
    String text,
    TextStyle style, {
    int maxLines = 2 ^ 31,
    double maxWidth = double.infinity,
  }) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.size;
  }
}
