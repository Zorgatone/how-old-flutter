import 'package:flutter_test/flutter_test.dart';
import 'package:how_old/date_tokenizer.dart';

void main() {
  group('Rune helper functions', () {
    test('isSpace', () {
      expect(isSpace(' '.runes.first), true);
      expect(isSpace('\t'.runes.first), false);
      expect(isSpace('\r'.runes.first), false);
      expect(isSpace('\n'.runes.first), false);
      expect(isSpace('a'.runes.first), false);
      expect(isSpace('z'.runes.first), false);
      expect(isSpace('0'.runes.first), false);
      expect(isSpace('1'.runes.first), false);
      expect(isSpace('-'.runes.first), false);
      expect(isSpace('/'.runes.first), false);
      expect(isSpace('.'.runes.first), false);
      expect(isSpace(','.runes.first), false);
      expect(isSpace(';'.runes.first), false);
      expect(isSpace("'".runes.first), false);
      expect(isSpace('"'.runes.first), false);
      expect(isSpace('_'.runes.first), false);
      expect(isSpace('='.runes.first), false);
      expect(isSpace('+'.runes.first), false);
      expect(isSpace('['.runes.first), false);
      expect(isSpace(']'.runes.first), false);
      expect(isSpace('{'.runes.first), false);
      expect(isSpace('}'.runes.first), false);
      expect(isSpace('!'.runes.first), false);
      expect(isSpace('?'.runes.first), false);
      expect(isSpace('@'.runes.first), false);
      expect(isSpace('#'.runes.first), false);
      expect(isSpace(r'$'.runes.first), false);
      expect(isSpace('%'.runes.first), false);
      expect(isSpace('^'.runes.first), false);
      expect(isSpace('&'.runes.first), false);
      expect(isSpace('*'.runes.first), false);
      expect(isSpace('('.runes.first), false);
      expect(isSpace(')'.runes.first), false);
      expect(isSpace('`'.runes.first), false);
      expect(isSpace('~'.runes.first), false);
    });

    test('isDigit', () {
      expect(isDigit('0'.runes.first), true);
      expect(isDigit('1'.runes.first), true);
      expect(isDigit('2'.runes.first), true);
      expect(isDigit('3'.runes.first), true);
      expect(isDigit('4'.runes.first), true);
      expect(isDigit('5'.runes.first), true);
      expect(isDigit('6'.runes.first), true);
      expect(isDigit('7'.runes.first), true);
      expect(isDigit('8'.runes.first), true);
      expect(isDigit('9'.runes.first), true);
      expect(isDigit(' '.runes.first), false);
      expect(isDigit('\t'.runes.first), false);
      expect(isDigit('\r'.runes.first), false);
      expect(isDigit('\n'.runes.first), false);
      expect(isDigit('a'.runes.first), false);
      expect(isDigit('z'.runes.first), false);
      expect(isDigit('-'.runes.first), false);
      expect(isDigit('/'.runes.first), false);
      expect(isDigit('.'.runes.first), false);
      expect(isDigit(','.runes.first), false);
      expect(isDigit(';'.runes.first), false);
      expect(isDigit("'".runes.first), false);
      expect(isDigit('"'.runes.first), false);
      expect(isDigit('_'.runes.first), false);
      expect(isDigit('='.runes.first), false);
      expect(isDigit('+'.runes.first), false);
      expect(isDigit('['.runes.first), false);
      expect(isDigit(']'.runes.first), false);
      expect(isDigit('{'.runes.first), false);
      expect(isDigit('}'.runes.first), false);
      expect(isDigit('!'.runes.first), false);
      expect(isDigit('?'.runes.first), false);
      expect(isDigit('@'.runes.first), false);
      expect(isDigit('#'.runes.first), false);
      expect(isDigit(r'$'.runes.first), false);
      expect(isDigit('%'.runes.first), false);
      expect(isDigit('^'.runes.first), false);
      expect(isDigit('&'.runes.first), false);
      expect(isDigit('*'.runes.first), false);
      expect(isDigit('('.runes.first), false);
      expect(isDigit(')'.runes.first), false);
      expect(isDigit('`'.runes.first), false);
      expect(isDigit('~'.runes.first), false);
    });

    test('isSeparator', () {
      expect(isSeparator('-'.runes.first), true);
      expect(isSeparator('/'.runes.first), true);
      expect(isSeparator('.'.runes.first), true);
      expect(isSeparator(' '.runes.first), false);
      expect(isSeparator('\t'.runes.first), false);
      expect(isSeparator('\r'.runes.first), false);
      expect(isSeparator('\n'.runes.first), false);
      expect(isSeparator('a'.runes.first), false);
      expect(isSeparator('z'.runes.first), false);
      expect(isSeparator('0'.runes.first), false);
      expect(isSeparator('1'.runes.first), false);
      expect(isSeparator(','.runes.first), false);
      expect(isSeparator(';'.runes.first), false);
      expect(isSeparator("'".runes.first), false);
      expect(isSeparator('"'.runes.first), false);
      expect(isSeparator('_'.runes.first), false);
      expect(isSeparator('='.runes.first), false);
      expect(isSeparator('+'.runes.first), false);
      expect(isSeparator('['.runes.first), false);
      expect(isSeparator(']'.runes.first), false);
      expect(isSeparator('{'.runes.first), false);
      expect(isSeparator('}'.runes.first), false);
      expect(isSeparator('!'.runes.first), false);
      expect(isSeparator('?'.runes.first), false);
      expect(isSeparator('@'.runes.first), false);
      expect(isSeparator('#'.runes.first), false);
      expect(isSeparator(r'$'.runes.first), false);
      expect(isSeparator('%'.runes.first), false);
      expect(isSeparator('^'.runes.first), false);
      expect(isSeparator('&'.runes.first), false);
      expect(isSeparator('*'.runes.first), false);
      expect(isSeparator('('.runes.first), false);
      expect(isSeparator(')'.runes.first), false);
      expect(isSeparator('`'.runes.first), false);
      expect(isSeparator('~'.runes.first), false);
    });
  });

  group('Token class', () {
    test('GetSubstring method', () {
      const string = '10/12/2021';
      const token = Token(kind: TokenKind.number, start: 3, end: 5);

      expect(token.getSubstring(string), '12');
    });
  });

  group('Date Tokenizer class', () {
    test('Constructor function', () {
      final tokenizer = Tokenizer();

      expect(0, tokenizer.idx);
    });

    test('Next method', () {
      const string1 = '01/01/1970';
      const string2 = '31-12-1999';
      const string3 = '12.12.2012';
      const expectedTokens = [
        Token(kind: TokenKind.number, start: 0, end: 2),
        Token(kind: TokenKind.separator, start: 2, end: 3),
        Token(kind: TokenKind.number, start: 3, end: 5),
        Token(kind: TokenKind.separator, start: 5, end: 6),
        Token(kind: TokenKind.number, start: 6, end: 10),
      ];
      const expectedSlices1 = ['01', '/', '01', '/', '1970'];
      const expectedSlices2 = ['31', '-', '12', '-', '1999'];
      const expectedSlices3 = ['12', '.', '12', '.', '2012'];
      final tokenizer1 = Tokenizer();
      final tokenizer2 = Tokenizer();
      final tokenizer3 = Tokenizer();

      int i = 0;
      for (var expectedToken in expectedTokens) {
        final actualToken1 = tokenizer1.next(string1);
        final actualToken2 = tokenizer2.next(string2);
        final actualToken3 = tokenizer3.next(string3);

        expect(actualToken1.kind, expectedToken.kind);
        expect(actualToken2.kind, expectedToken.kind);
        expect(actualToken3.kind, expectedToken.kind);

        expect(actualToken1.start, expectedToken.start);
        expect(actualToken2.start, expectedToken.start);
        expect(actualToken3.start, expectedToken.start);

        expect(actualToken1.end, expectedToken.end);
        expect(actualToken2.end, expectedToken.end);
        expect(actualToken3.end, expectedToken.end);

        expect(actualToken1.getSubstring(string1), expectedSlices1[i]);
        expect(actualToken2.getSubstring(string2), expectedSlices2[i]);
        expect(actualToken3.getSubstring(string3), expectedSlices3[i]);

        i++;
      }

      const string4 = ' 1 3 - '; // invalid syntax (digits separated by space)
      final tokenizer4 = Tokenizer();

      var actualToken4 = tokenizer4.next(string4);
      expect(actualToken4.kind, TokenKind.space);
      expect(actualToken4.start, 0);
      expect(actualToken4.end, 1);

      actualToken4 = tokenizer4.next(string4);
      expect(actualToken4.kind, TokenKind.number);
      expect(actualToken4.start, 1);
      expect(actualToken4.end, 2);

      actualToken4 = tokenizer4.next(string4);
      expect(actualToken4.kind, TokenKind.space);
      expect(actualToken4.start, 2);
      expect(actualToken4.end, 3);

      actualToken4 = tokenizer4.next(string4);
      expect(actualToken4.kind, TokenKind.number);
      expect(actualToken4.start, 3);
      expect(actualToken4.end, 4);

      actualToken4 = tokenizer4.next(string4);
      expect(actualToken4.kind, TokenKind.space);
      expect(actualToken4.start, 4);
      expect(actualToken4.end, 5);

      actualToken4 = tokenizer4.next(string4);
      expect(actualToken4.kind, TokenKind.separator);
      expect(actualToken4.start, 5);
      expect(actualToken4.end, 6);

      actualToken4 = tokenizer4.next(string4);
      expect(actualToken4.kind, TokenKind.space);
      expect(actualToken4.start, 6);
      expect(actualToken4.end, 7);

      actualToken4 = tokenizer4.next(string4);
      expect(actualToken4.kind, TokenKind.eof);
      expect(actualToken4.start, 7);
      expect(actualToken4.end, 7);

      actualToken4 = Tokenizer().next('');
      expect(actualToken4.kind, TokenKind.eof);
      expect(actualToken4.start, 0);
      expect(actualToken4.end, 0);
    });

    test('collapse spaces', () {
      const expected = Token(kind: TokenKind.space, start: 0, end: 2);
      final actual = Tokenizer().next('  ');

      expect(actual.kind, expected.kind);
      expect(actual.start, expected.start);
      expect(actual.end, expected.end);
    });

    test('Peek method', () {
      const string = '1-1-2000';
      var tokenizer = Tokenizer();

      var actualToken = tokenizer.peek(string);
      expect(actualToken.kind, TokenKind.number);
      expect(actualToken.start, 0);
      expect(actualToken.end, 1);
      tokenizer.next(string);

      actualToken = tokenizer.peek(string);
      expect(actualToken.kind, TokenKind.separator);
      expect(actualToken.start, 1);
      expect(actualToken.end, 2);
      tokenizer.next(string);

      actualToken = tokenizer.peek(string);
      expect(actualToken.kind, TokenKind.number);
      expect(actualToken.start, 2);
      expect(actualToken.end, 3);
      tokenizer.next(string);

      actualToken = tokenizer.peek(string);
      expect(actualToken.kind, TokenKind.separator);
      expect(actualToken.start, 3);
      expect(actualToken.end, 4);
      tokenizer.next(string);

      actualToken = tokenizer.peek(string);
      expect(actualToken.kind, TokenKind.number);
      expect(actualToken.start, 4);
      expect(actualToken.end, 8);
      tokenizer.next(string);

      actualToken = tokenizer.peek(string);
      expect(actualToken.kind, TokenKind.eof);
      expect(actualToken.start, 8);
      expect(actualToken.end, 8);
      tokenizer.next(string);
    });
  });
}
