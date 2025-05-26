import 'package:flutter_test/flutter_test.dart';
import 'package:how_old/date_tokenizer.dart';

void main() {
  group('Rune helper functions', () {
    test('isSpace', () {
      expect(true, isSpace(' '.runes.first));
      expect(false, isSpace('\t'.runes.first));
      expect(false, isSpace('\r'.runes.first));
      expect(false, isSpace('\n'.runes.first));
      expect(false, isSpace('a'.runes.first));
      expect(false, isSpace('z'.runes.first));
      expect(false, isSpace('0'.runes.first));
      expect(false, isSpace('1'.runes.first));
      expect(false, isSpace('-'.runes.first));
      expect(false, isSpace('/'.runes.first));
      expect(false, isSpace('.'.runes.first));
      expect(false, isSpace(','.runes.first));
      expect(false, isSpace(';'.runes.first));
      expect(false, isSpace("'".runes.first));
      expect(false, isSpace('"'.runes.first));
      expect(false, isSpace('_'.runes.first));
      expect(false, isSpace('='.runes.first));
      expect(false, isSpace('+'.runes.first));
      expect(false, isSpace('['.runes.first));
      expect(false, isSpace(']'.runes.first));
      expect(false, isSpace('{'.runes.first));
      expect(false, isSpace('}'.runes.first));
      expect(false, isSpace('!'.runes.first));
      expect(false, isSpace('?'.runes.first));
      expect(false, isSpace('@'.runes.first));
      expect(false, isSpace('#'.runes.first));
      expect(false, isSpace(r'$'.runes.first));
      expect(false, isSpace('%'.runes.first));
      expect(false, isSpace('^'.runes.first));
      expect(false, isSpace('&'.runes.first));
      expect(false, isSpace('*'.runes.first));
      expect(false, isSpace('('.runes.first));
      expect(false, isSpace(')'.runes.first));
      expect(false, isSpace('`'.runes.first));
      expect(false, isSpace('~'.runes.first));
    });

    test('isDigit', () {
      expect(true, isDigit('0'.runes.first));
      expect(true, isDigit('1'.runes.first));
      expect(true, isDigit('2'.runes.first));
      expect(true, isDigit('3'.runes.first));
      expect(true, isDigit('4'.runes.first));
      expect(true, isDigit('5'.runes.first));
      expect(true, isDigit('6'.runes.first));
      expect(true, isDigit('7'.runes.first));
      expect(true, isDigit('8'.runes.first));
      expect(true, isDigit('9'.runes.first));
      expect(false, isDigit(' '.runes.first));
      expect(false, isDigit('\t'.runes.first));
      expect(false, isDigit('\r'.runes.first));
      expect(false, isDigit('\n'.runes.first));
      expect(false, isDigit('a'.runes.first));
      expect(false, isDigit('z'.runes.first));
      expect(false, isDigit('-'.runes.first));
      expect(false, isDigit('/'.runes.first));
      expect(false, isDigit('.'.runes.first));
      expect(false, isDigit(','.runes.first));
      expect(false, isDigit(';'.runes.first));
      expect(false, isDigit("'".runes.first));
      expect(false, isDigit('"'.runes.first));
      expect(false, isDigit('_'.runes.first));
      expect(false, isDigit('='.runes.first));
      expect(false, isDigit('+'.runes.first));
      expect(false, isDigit('['.runes.first));
      expect(false, isDigit(']'.runes.first));
      expect(false, isDigit('{'.runes.first));
      expect(false, isDigit('}'.runes.first));
      expect(false, isDigit('!'.runes.first));
      expect(false, isDigit('?'.runes.first));
      expect(false, isDigit('@'.runes.first));
      expect(false, isDigit('#'.runes.first));
      expect(false, isDigit(r'$'.runes.first));
      expect(false, isDigit('%'.runes.first));
      expect(false, isDigit('^'.runes.first));
      expect(false, isDigit('&'.runes.first));
      expect(false, isDigit('*'.runes.first));
      expect(false, isDigit('('.runes.first));
      expect(false, isDigit(')'.runes.first));
      expect(false, isDigit('`'.runes.first));
      expect(false, isDigit('~'.runes.first));
    });

    test('isSeparator', () {
      expect(true, isSeparator('-'.runes.first));
      expect(true, isSeparator('/'.runes.first));
      expect(true, isSeparator('.'.runes.first));
      expect(false, isSeparator(' '.runes.first));
      expect(false, isSeparator('\t'.runes.first));
      expect(false, isSeparator('\r'.runes.first));
      expect(false, isSeparator('\n'.runes.first));
      expect(false, isSeparator('a'.runes.first));
      expect(false, isSeparator('z'.runes.first));
      expect(false, isSeparator('0'.runes.first));
      expect(false, isSeparator('1'.runes.first));
      expect(false, isSeparator(','.runes.first));
      expect(false, isSeparator(';'.runes.first));
      expect(false, isSeparator("'".runes.first));
      expect(false, isSeparator('"'.runes.first));
      expect(false, isSeparator('_'.runes.first));
      expect(false, isSeparator('='.runes.first));
      expect(false, isSeparator('+'.runes.first));
      expect(false, isSeparator('['.runes.first));
      expect(false, isSeparator(']'.runes.first));
      expect(false, isSeparator('{'.runes.first));
      expect(false, isSeparator('}'.runes.first));
      expect(false, isSeparator('!'.runes.first));
      expect(false, isSeparator('?'.runes.first));
      expect(false, isSeparator('@'.runes.first));
      expect(false, isSeparator('#'.runes.first));
      expect(false, isSeparator(r'$'.runes.first));
      expect(false, isSeparator('%'.runes.first));
      expect(false, isSeparator('^'.runes.first));
      expect(false, isSeparator('&'.runes.first));
      expect(false, isSeparator('*'.runes.first));
      expect(false, isSeparator('('.runes.first));
      expect(false, isSeparator(')'.runes.first));
      expect(false, isSeparator('`'.runes.first));
      expect(false, isSeparator('~'.runes.first));
    });
  });

  group('Token class', () {
    test('GetSubstring method', () {
      const string = '10/12/2021';
      const token = Token(kind: TokenKind.number, start: 3, end: 5);

      expect('12', token.getSubstring(string));
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

        expect(expectedSlices1[i], actualToken1.getSubstring(string1));
        expect(expectedSlices2[i], actualToken2.getSubstring(string2));
        expect(expectedSlices3[i], actualToken3.getSubstring(string3));

        i++;
      }

      const string4 = ' 1 3 - '; // invalid syntax (digits separated by space)
      final tokenizer4 = Tokenizer();

      var actualToken4 = tokenizer4.next(string4);
      expect(TokenKind.space, actualToken4.kind);
      expect(0, actualToken4.start);
      expect(1, actualToken4.end);

      actualToken4 = tokenizer4.next(string4);
      expect(TokenKind.number, actualToken4.kind);
      expect(1, actualToken4.start);
      expect(2, actualToken4.end);

      actualToken4 = tokenizer4.next(string4);
      expect(TokenKind.space, actualToken4.kind);
      expect(2, actualToken4.start);
      expect(3, actualToken4.end);

      actualToken4 = tokenizer4.next(string4);
      expect(TokenKind.number, actualToken4.kind);
      expect(3, actualToken4.start);
      expect(4, actualToken4.end);

      actualToken4 = tokenizer4.next(string4);
      expect(TokenKind.space, actualToken4.kind);
      expect(4, actualToken4.start);
      expect(5, actualToken4.end);

      actualToken4 = tokenizer4.next(string4);
      expect(TokenKind.separator, actualToken4.kind);
      expect(5, actualToken4.start);
      expect(6, actualToken4.end);

      actualToken4 = tokenizer4.next(string4);
      expect(TokenKind.space, actualToken4.kind);
      expect(6, actualToken4.start);
      expect(7, actualToken4.end);

      actualToken4 = tokenizer4.next(string4);
      expect(TokenKind.eof, actualToken4.kind);
      expect(7, actualToken4.start);
      expect(7, actualToken4.end);

      actualToken4 = Tokenizer().next('');
      expect(TokenKind.eof, actualToken4.kind);
      expect(0, actualToken4.start);
      expect(0, actualToken4.end);
    });

    test('Peek method', () {
      const string = '1-1-2000';
      var tokenizer = Tokenizer();

      var actualToken = tokenizer.peek(string);
      expect(TokenKind.number, actualToken.kind);
      expect(0, actualToken.start);
      expect(1, actualToken.end);
      tokenizer.next(string);

      actualToken = tokenizer.peek(string);
      expect(TokenKind.separator, actualToken.kind);
      expect(1, actualToken.start);
      expect(2, actualToken.end);
      tokenizer.next(string);

      actualToken = tokenizer.peek(string);
      expect(TokenKind.number, actualToken.kind);
      expect(2, actualToken.start);
      expect(3, actualToken.end);
      tokenizer.next(string);

      actualToken = tokenizer.peek(string);
      expect(TokenKind.separator, actualToken.kind);
      expect(3, actualToken.start);
      expect(4, actualToken.end);
      tokenizer.next(string);

      actualToken = tokenizer.peek(string);
      expect(TokenKind.number, actualToken.kind);
      expect(4, actualToken.start);
      expect(8, actualToken.end);
      tokenizer.next(string);

      actualToken = tokenizer.peek(string);
      expect(TokenKind.eof, actualToken.kind);
      expect(8, actualToken.start);
      expect(8, actualToken.end);
      tokenizer.next(string);
    });
  });
}
