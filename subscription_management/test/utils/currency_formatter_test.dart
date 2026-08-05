import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_management/src/utils/formatters.dart';

void main() {
  group('CurrencyFormatter', () {
    test('format returns BRL currency string', () {
      final result = CurrencyFormatter.format(10.5);

      expect(result, contains('10,50'));
      expect(result.replaceAll(RegExp(r'\s'), ''), 'R\$10,50');
    });

    test('formatInput converts cents to formatted currency', () {
      final result = CurrencyFormatter.formatInput('1050');

      expect(result, contains('10,50'));
      expect(result.replaceAll(RegExp(r'\s'), ''), 'R\$10,50');
    });

    test('formatInput returns empty string for empty input', () {
      expect(CurrencyFormatter.formatInput(''), '');
    });

    test('parse converts formatted currency to double', () {
      final formatted = CurrencyFormatter.format(10.5);

      expect(CurrencyFormatter.parse(formatted), 10.5);
    });

    test('parse returns null for empty input', () {
      expect(CurrencyFormatter.parse(''), isNull);
    });
  });
}
