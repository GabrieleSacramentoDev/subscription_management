import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_management/src/modules/home/domain/enums/payment_method.dart';

void main() {
  group('PaymentMethod', () {
    test('getStringFromPaymentMethod returns label for each method', () {
      expect(
        PaymentMethod.getStringFromPaymentMethod(PaymentMethod.creditCard),
        'Crédito',
      );
      expect(
        PaymentMethod.getStringFromPaymentMethod(PaymentMethod.debitCard),
        'Débito',
      );
      expect(
        PaymentMethod.getStringFromPaymentMethod(PaymentMethod.pix),
        'Pix',
      );
    });

    test('getPaymentMethodFromString returns enum for each label', () {
      expect(
        PaymentMethod.getPaymentMethodFromString('Crédito'),
        PaymentMethod.creditCard,
      );
      expect(
        PaymentMethod.getPaymentMethodFromString('Débito'),
        PaymentMethod.debitCard,
      );
      expect(
        PaymentMethod.getPaymentMethodFromString('Pix'),
        PaymentMethod.pix,
      );
    });

    test('getPaymentMethodFromString returns null for unknown label', () {
      expect(PaymentMethod.getPaymentMethodFromString('Boleto'), isNull);
    });
  });
}
