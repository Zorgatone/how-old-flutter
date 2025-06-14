import 'package:flutter/material.dart';
import 'package:how_old/constants.dart';
import 'package:how_old/date_mask.dart' show DateMask;
import 'package:intl/intl.dart' show DateFormat;

const _inputTextStyle = TextStyle(
  fontFamily: 'RobotoMono',
  fontSize: 15,
  fontWeight: FontWeight.normal,
  wordSpacing: 0,
  letterSpacing: 0,
  color: Colors.black,
);

class DateField extends StatefulWidget {
  const DateField({super.key, this.labelText, this.initialDate});

  final String? labelText;
  final DateTime? initialDate;

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  final TextEditingController _editingController;
  final TextStyle _hintTextStyle;
  final FocusNode _focusNode;

  bool isValid;
  bool isFocused;
  String textValue;

  _DateFieldState()
    : textValue = '',
      _editingController = TextEditingController(text: ''),
      _hintTextStyle = _inputTextStyle.copyWith(color: Colors.black45),
      _focusNode = FocusNode(),
      isValid = true,
      isFocused = false,
      super();

  @override
  void initState() {
    super.initState();

    final initialDate = widget.initialDate;
    if (initialDate != null) {
      final formatter = DateFormat('dd/MM/yyyy');
      textValue = formatter.format(initialDate);
      _editingController.text = textValue;
    }

    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final regexp = RegExp(validDateRegexp);
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
              _editingController.text.length >= dateFormat.length
                  ? ''
                  : dateFormat.substring(_editingController.text.length),
              style: _hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _editingController.dispose();
    _focusNode.dispose();
    super.dispose();
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
