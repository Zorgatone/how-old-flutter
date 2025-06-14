import 'package:flutter_test/flutter_test.dart';
import 'package:how_old/utils/clip_text_value.dart';

void main() {
  group('clipTextValue utility function', () {
    test('remove text at the start', () {
      const initial = TextEditingValue(text: 'My example text');
      final modified = clipTextValue(initial, 0, 3);

      expect(modified.text, 'example text');
    });

    test('remove text in the middle', () {
      const initial = TextEditingValue(text: 'My example text');
      final modified = clipTextValue(initial, 3, 11);

      expect(modified.text, 'My text');
    });

    test('remove text at the end', () {
      const initial = TextEditingValue(text: 'My example text');
      final modified = clipTextValue(initial, 10);

      expect(modified.text, 'My example');
    });
  });
}
