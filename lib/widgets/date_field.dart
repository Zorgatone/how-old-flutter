import 'dart:math';

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
  const DateField({super.key});

  @override
  State<StatefulWidget> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  final _editingController = TextEditingController();
  final _hintTextStyle = _inputTextStyle.copyWith(color: Colors.black45);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: _editingController,
          onChanged: (text) {
            setState(() {});
          },
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: [DateMask()],
          decoration: InputDecoration(
            hintText: dateFormatHint,
            hintStyle: _hintTextStyle,
          ),
          style: _inputTextStyle,
        ),
        Positioned(
          left:
              _boundingTextSize(_editingController.text, _inputTextStyle).width,
          top: 12.5,
          child: Visibility(
            visible: _editingController.text.isNotEmpty,
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
