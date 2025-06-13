import 'package:flutter_test/flutter_test.dart';
import 'package:how_old/date_mask.dart';

void main() {
  group('DateMask class', () {
    group('formatEditUpdate method', () {
      test(
        'fall back to old value with invalid characters at the end of input',
        () {
          var mask = DateMask();

          var oldValue = const TextEditingValue(text: '');
          var newValue = const TextEditingValue(text: 'b');

          expect(oldValue, mask.formatEditUpdate(oldValue, newValue));

          oldValue = const TextEditingValue(text: '10');
          newValue = const TextEditingValue(text: '10b');

          expect(oldValue, mask.formatEditUpdate(oldValue, newValue));
        },
      );

      test('can add single valid character at end of input', () {
        var mask = DateMask();

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
        var mask = DateMask();

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
        var mask = DateMask();

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
        var mask = DateMask();

        var oldValue = const TextEditingValue(text: '10/07/1992'); // complete
        const newValue = TextEditingValue(text: '');

        expect(newValue, mask.formatEditUpdate(oldValue, newValue));

        oldValue = const TextEditingValue(text: '10/07/'); // incomplete

        expect(newValue, mask.formatEditUpdate(oldValue, newValue));
      });

      test('can paste valid date', () {
        var mask = DateMask();

        var oldValue = const TextEditingValue(text: '');
        const newValue = TextEditingValue(text: '10/07/1992'); // complete

        expect(newValue, mask.formatEditUpdate(oldValue, newValue));

        oldValue = const TextEditingValue(text: '10/07/');

        expect(newValue, mask.formatEditUpdate(oldValue, newValue));
      });

      test('reject multiple characters change', () {
        var mask = DateMask();

        const oldValue = TextEditingValue(text: '10/07/');
        var newValue = const TextEditingValue(text: '10/07/199'); // incomplete

        expect(mask.formatEditUpdate(oldValue, newValue), oldValue);

        newValue = const TextEditingValue(text: '10/');

        expect(mask.formatEditUpdate(oldValue, newValue), oldValue);
      });
    });
  });
}
