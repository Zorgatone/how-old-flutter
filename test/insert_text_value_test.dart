import 'package:flutter_test/flutter_test.dart';
import 'package:how_old/utils/insert_text_value.dart';

void main() {
  group('insertTextValue utility function', () {
    test('insert text at the start', () {
      const initial = TextEditingValue(text: 'example text');
      final modified = insertTextValue(initial, index: 0, text: 'My ');

      expect(modified.text, 'My example text');
    });

    test('insert text in the middle', () {
      const initial = TextEditingValue(text: 'My text');
      final modified = insertTextValue(initial, index: 2, text: ' example');

      expect(modified.text, 'My example text');
    });

    test('insert text at the end', () {
      const initial = TextEditingValue(text: 'My example');
      final modified = insertTextValue(
        initial,
        index: initial.text.length,
        text: ' text',
      );

      expect(modified.text, 'My example text');
    });
  });
}
