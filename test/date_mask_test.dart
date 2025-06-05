import 'package:flutter_test/flutter_test.dart';
import 'package:how_old/date_mask.dart';

void main() {
  group('DateMask class formatEditUpdate', () {
    test('unchanged', () {
      var mask = DateMask();

      const oldValue = TextEditingValue(text: '');
      const newValue = TextEditingValue(text: '1');

      expect(newValue, mask.formatEditUpdate(oldValue, newValue));
    });

    test('remove invalid characters', () {
      var mask = DateMask();

      const oldValue = TextEditingValue(text: '');
      const newValue = TextEditingValue(text: 'b');

      expect(oldValue, mask.formatEditUpdate(oldValue, newValue));
    });
  });
}
