import 'package:flutter_test/flutter_test.dart';
import 'package:how_old/date_mask.dart';

void main() {
  group('DateMask class', () {
    group('formatEditUpdate method', () {
      test('should skip any spaces', () {
        final mask = DateMask();

        var oldValue = const TextEditingValue(text: '');
        var newValue = const TextEditingValue(text: ' ');

        expect(mask.formatEditUpdate(oldValue, newValue), oldValue);

        oldValue = const TextEditingValue(text: '10/07/');
        newValue = const TextEditingValue(text: '10/07/ ');

        expect(mask.formatEditUpdate(oldValue, newValue), oldValue);
      });

      test(
        'fall back to old value with invalid characters at the end of input',
        () {
          final mask = DateMask();

          var oldValue = const TextEditingValue(text: '');
          var newValue = const TextEditingValue(text: 'b');

          expect(mask.formatEditUpdate(oldValue, newValue), oldValue);

          oldValue = const TextEditingValue(text: '10');
          newValue = const TextEditingValue(text: '10b');

          expect(mask.formatEditUpdate(oldValue, newValue), oldValue);
        },
      );

      test('can add single valid character at end of input', () {
        final mask = DateMask();

        var oldValue = const TextEditingValue(text: '');
        var newValue = const TextEditingValue(text: '1');

        expect(mask.formatEditUpdate(oldValue, newValue), newValue);

        oldValue = const TextEditingValue(text: '10/07/19'); // incomplete
        newValue = const TextEditingValue(text: '10/07/199'); // incomplete

        expect(mask.formatEditUpdate(oldValue, newValue), newValue);

        oldValue = const TextEditingValue(text: '10/07');
        newValue = const TextEditingValue(text: '10/07/');

        expect(mask.formatEditUpdate(oldValue, newValue), newValue);
      });

      test('can remove single character at end of input', () {
        final mask = DateMask();

        var oldValue = const TextEditingValue(text: '1');
        var newValue = const TextEditingValue(text: '');

        expect(mask.formatEditUpdate(oldValue, newValue), newValue);

        oldValue = const TextEditingValue(text: '10/07/199'); // incomplete
        newValue = const TextEditingValue(text: '10/07/19'); // incomplete

        expect(mask.formatEditUpdate(oldValue, newValue), newValue);

        oldValue = const TextEditingValue(text: '10/07/');
        newValue = const TextEditingValue(text: '10/07');

        expect(mask.formatEditUpdate(oldValue, newValue), newValue);
      });

      test('cannot remove characters not at the end of input', () {
        final mask = DateMask();

        var oldValue = const TextEditingValue(text: '10/07/199'); // incomplete
        var newValue = const TextEditingValue(text: '0/07/199'); // incomplete

        expect(mask.formatEditUpdate(oldValue, newValue), oldValue);

        oldValue = const TextEditingValue(text: '10/07/');
        newValue = const TextEditingValue(text: '0/07');

        expect(mask.formatEditUpdate(oldValue, newValue), oldValue);

        oldValue = const TextEditingValue(text: '10/07/199');
        newValue = const TextEditingValue(text: '07');

        expect(mask.formatEditUpdate(oldValue, newValue), oldValue);
      });

      test('can clear value', () {
        final mask = DateMask();

        var oldValue = const TextEditingValue(text: '10/07/1992'); // complete
        const newValue = TextEditingValue(text: '');

        expect(mask.formatEditUpdate(oldValue, newValue), newValue);

        oldValue = const TextEditingValue(text: '10/07/'); // incomplete

        expect(mask.formatEditUpdate(oldValue, newValue), newValue);
      });

      test('can paste valid date', () {
        final mask = DateMask();

        var oldValue = const TextEditingValue(text: '');
        const newValue = TextEditingValue(text: '10/07/1992'); // complete

        expect(mask.formatEditUpdate(oldValue, newValue), newValue);

        oldValue = const TextEditingValue(text: '10/07/');

        expect(mask.formatEditUpdate(oldValue, newValue), newValue);
      });

      test('reject multiple characters change', () {
        final mask = DateMask();

        const oldValue = TextEditingValue(text: '10/07/');
        var newValue = const TextEditingValue(text: '10/07/199'); // incomplete

        expect(mask.formatEditUpdate(oldValue, newValue), oldValue);

        newValue = const TextEditingValue(text: '10/');

        expect(mask.formatEditUpdate(oldValue, newValue), oldValue);
      });

      test('three numbers should move from day to month', () {
        final mask = DateMask();

        const oldValue = TextEditingValue(text: '31');
        const newValue = TextEditingValue(text: '311');
        const finalValue = TextEditingValue(text: '31/1');

        expect(mask.formatEditUpdate(oldValue, newValue), finalValue);
      });

      test('three numbers should move from month to year', () {
        final mask = DateMask();

        const oldValue = TextEditingValue(text: '28/02');
        const newValue = TextEditingValue(text: '28/021');
        const finalValue = TextEditingValue(text: '28/02/1'); // incomplete

        expect(mask.formatEditUpdate(oldValue, newValue), finalValue);
      });

      test('two numbers should automatically insert separator', () {
        final mask = DateMask();

        var oldValue = const TextEditingValue(text: '3');
        var newValue = const TextEditingValue(text: '31');
        var finalValue = const TextEditingValue(text: '31/');

        expect(mask.formatEditUpdate(oldValue, newValue), finalValue);

        oldValue = const TextEditingValue(text: '28/0');
        newValue = const TextEditingValue(text: '28/02');
        finalValue = const TextEditingValue(text: '28/02/');

        expect(mask.formatEditUpdate(oldValue, newValue), finalValue);
      });

      test('large initial day digit should skip to month', () {
        final mask = DateMask();

        const oldValue = TextEditingValue(text: '');
        const values = ['4', '5', '6', '7', '8', '9'];
        final newValues =
            values.map((text) => TextEditingValue(text: text)).toList();
        final finalValues =
            values.map((text) => TextEditingValue(text: '0$text/')).toList();

        final len = values.length;
        for (var i = 0; i < len; i++) {
          final newValue = newValues[i];
          final finalValue = finalValues[i];

          expect(mask.formatEditUpdate(oldValue, newValue), finalValue);
        }
      });

      test('large initial month digit should skip to year', () {
        final mask = DateMask();

        const oldValue = TextEditingValue(text: '28/');
        const values = ['2', '3', '4', '5', '6', '7', '8', '9'];
        final newValues =
            values
                .map((text) => TextEditingValue(text: '${oldValue.text}$text'))
                .toList();
        final finalValues =
            values
                .map(
                  (text) => TextEditingValue(text: '${oldValue.text}0$text/'),
                )
                .toList();

        final len = values.length;
        for (var i = 0; i < len; i++) {
          final newValue = newValues[i];
          final finalValue = finalValues[i];

          expect(mask.formatEditUpdate(oldValue, newValue), finalValue);
        }
      });

      test('should remove extra characters after complete valid date', () {
        final mask = DateMask();

        const oldValue = TextEditingValue(text: '10/07/1992');
        const newValue = TextEditingValue(text: '10/07/19923');

        expect(mask.formatEditUpdate(oldValue, newValue), oldValue);
      });
    });
  });
}
