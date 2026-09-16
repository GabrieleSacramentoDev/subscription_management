import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/enums/subscription_periodicity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/utils/subscription_lifecycle.dart';

void main() {
  group('calculateSubscriptionLifecycle (mensal)', () {
    final dueDate = DateTime(2026, 3, 10);

    test('no dia do vencimento permanece ativa', () {
      final snapshot = calculateSubscriptionLifecycle(
        storedDueDate: dueDate,
        periodicity: SubscriptionPeriodicity.monthly,
        today: DateTime(2026, 3, 10),
      );

      expect(snapshot.status, SubscriptionBillingStatus.active);
      expect(snapshot.daysUntilDue, 0);
      expect(snapshot.daysOverdue, 0);
      expect(snapshot.effectiveDueDate, DateTime(2026, 3, 10));
      expect(snapshot.shouldAdvanceStoredDueDate, isFalse);
    });

    test('1 dia vencido entra em tolerância', () {
      final snapshot = calculateSubscriptionLifecycle(
        storedDueDate: dueDate,
        periodicity: SubscriptionPeriodicity.monthly,
        today: DateTime(2026, 3, 11),
      );

      expect(snapshot.status, SubscriptionBillingStatus.grace);
      expect(snapshot.daysOverdue, 1);
      expect(snapshot.effectiveDueDate, DateTime(2026, 3, 10));
      expect(snapshot.shouldAdvanceStoredDueDate, isFalse);
    });

    test('3 dias vencidos permanece em tolerância', () {
      final snapshot = calculateSubscriptionLifecycle(
        storedDueDate: dueDate,
        periodicity: SubscriptionPeriodicity.monthly,
        today: DateTime(2026, 3, 13),
      );

      expect(snapshot.status, SubscriptionBillingStatus.grace);
      expect(snapshot.daysOverdue, 3);
      expect(snapshot.effectiveDueDate, DateTime(2026, 3, 10));
      expect(snapshot.shouldAdvanceStoredDueDate, isFalse);
    });

    test('4 dias vencidos avança para o próximo ciclo mensal', () {
      final snapshot = calculateSubscriptionLifecycle(
        storedDueDate: dueDate,
        periodicity: SubscriptionPeriodicity.monthly,
        today: DateTime(2026, 3, 14),
      );

      expect(snapshot.status, SubscriptionBillingStatus.active);
      expect(snapshot.effectiveDueDate, DateTime(2026, 4, 10));
      expect(snapshot.shouldAdvanceStoredDueDate, isTrue);
      expect(snapshot.advancedStoredDueDate, DateTime(2026, 4, 10));
      expect(snapshot.daysUntilDue, 27);
    });
  });
}
