import 'package:subscription_management/src/modules/streaming_management/domain/enums/subscription_periodicity.dart';

const subscriptionGracePeriodDays = 3;

enum SubscriptionBillingStatus {
  active,
  grace,
  overdue,
}

class SubscriptionLifecycleSnapshot {
  const SubscriptionLifecycleSnapshot({
    required this.effectiveDueDate,
    required this.status,
    required this.daysUntilDue,
    required this.daysOverdue,
    required this.shouldAdvanceStoredDueDate,
    required this.advancedStoredDueDate,
  });

  final DateTime effectiveDueDate;
  final SubscriptionBillingStatus status;
  final int daysUntilDue;
  final int daysOverdue;
  final bool shouldAdvanceStoredDueDate;
  final DateTime? advancedStoredDueDate;
}

DateTime dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

DateTime addMonths(DateTime date, int months) {
  final yearOffset = (date.month - 1 + months) ~/ 12;
  final month = (date.month - 1 + months) % 12 + 1;
  final year = date.year + yearOffset;
  final lastDayOfMonth = DateTime(year, month + 1, 0).day;
  final day = date.day > lastDayOfMonth ? lastDayOfMonth : date.day;
  return DateTime(year, month, day);
}

DateTime resolveMonthlyEffectiveDueDate({
  required DateTime storedDueDate,
  required DateTime today,
}) {
  var due = dateOnly(storedDueDate);
  final current = dateOnly(today);

  while (current.isAfter(due.add(const Duration(days: subscriptionGracePeriodDays)))) {
    due = addMonths(due, 1);
  }

  return due;
}

SubscriptionLifecycleSnapshot calculateSubscriptionLifecycle({
  required DateTime storedDueDate,
  required SubscriptionPeriodicity periodicity,
  DateTime? today,
}) {
  final referenceDay = dateOnly(today ?? DateTime.now());
  final storedDue = dateOnly(storedDueDate);

  if (periodicity == SubscriptionPeriodicity.annual) {
    if (!referenceDay.isAfter(storedDue)) {
      return SubscriptionLifecycleSnapshot(
        effectiveDueDate: storedDue,
        status: SubscriptionBillingStatus.active,
        daysUntilDue: storedDue.difference(referenceDay).inDays,
        daysOverdue: 0,
        shouldAdvanceStoredDueDate: false,
        advancedStoredDueDate: null,
      );
    }

    return SubscriptionLifecycleSnapshot(
      effectiveDueDate: storedDue,
      status: SubscriptionBillingStatus.overdue,
      daysUntilDue: 0,
      daysOverdue: referenceDay.difference(storedDue).inDays,
      shouldAdvanceStoredDueDate: false,
      advancedStoredDueDate: null,
    );
  }

  final effectiveDue = resolveMonthlyEffectiveDueDate(
    storedDueDate: storedDue,
    today: referenceDay,
  );
  final shouldAdvance = !effectiveDue.isAtSameMomentAs(storedDue);

  if (referenceDay.isAfter(effectiveDue)) {
    final daysOverdue = referenceDay.difference(effectiveDue).inDays;
    return SubscriptionLifecycleSnapshot(
      effectiveDueDate: effectiveDue,
      status: SubscriptionBillingStatus.grace,
      daysUntilDue: 0,
      daysOverdue: daysOverdue,
      shouldAdvanceStoredDueDate: shouldAdvance,
      advancedStoredDueDate: shouldAdvance ? effectiveDue : null,
    );
  }

  return SubscriptionLifecycleSnapshot(
    effectiveDueDate: effectiveDue,
    status: SubscriptionBillingStatus.active,
    daysUntilDue: effectiveDue.difference(referenceDay).inDays,
    daysOverdue: 0,
    shouldAdvanceStoredDueDate: shouldAdvance,
    advancedStoredDueDate: shouldAdvance ? effectiveDue : null,
  );
}
