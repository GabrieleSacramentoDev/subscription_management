import 'package:flutter/material.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/enums/subscription_periodicity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/utils/subscription_lifecycle.dart';

String formatRenewalDate(
  DateTime renewalDate, {
  SubscriptionPeriodicity periodicity = SubscriptionPeriodicity.monthly,
  DateTime? today,
}) {
  final lifecycle = calculateSubscriptionLifecycle(
    storedDueDate: renewalDate,
    periodicity: periodicity,
    today: today,
  );

  switch (lifecycle.status) {
    case SubscriptionBillingStatus.grace:
      final days = lifecycle.daysOverdue;
      if (days == 1) {
        return 'Vencida há 1 dia';
      }
      return 'Vencida há $days dias';
    case SubscriptionBillingStatus.overdue:
      return 'Vencida há ${lifecycle.daysOverdue} dias';
    case SubscriptionBillingStatus.active:
      final daysUntil = lifecycle.daysUntilDue;
      if (daysUntil == 0) {
        return 'Renova hoje';
      }
      if (daysUntil == 1) {
        return 'Renova amanhã';
      }
      return 'Renova em $daysUntil dias';
  }
}

Color getRenewalColor(
  DateTime renewalDate, {
  SubscriptionPeriodicity periodicity = SubscriptionPeriodicity.monthly,
  DateTime? today,
}) {
  final lifecycle = calculateSubscriptionLifecycle(
    storedDueDate: renewalDate,
    periodicity: periodicity,
    today: today,
  );

  switch (lifecycle.status) {
    case SubscriptionBillingStatus.grace:
      return const Color.fromARGB(255, 199, 124, 10);
    case SubscriptionBillingStatus.overdue:
      return Colors.red;
    case SubscriptionBillingStatus.active:
      if (lifecycle.daysUntilDue <= 3) {
        return const Color.fromARGB(255, 199, 124, 10);
      }
      if (lifecycle.daysUntilDue <= 7) {
        return const Color.fromARGB(255, 199, 124, 10);
      }
      return const Color.fromRGBO(77, 77, 97, 1);
  }
}

IconData getRenewalIcon(
  DateTime renewalDate, {
  SubscriptionPeriodicity periodicity = SubscriptionPeriodicity.monthly,
  DateTime? today,
}) {
  final lifecycle = calculateSubscriptionLifecycle(
    storedDueDate: renewalDate,
    periodicity: periodicity,
    today: today,
  );

  switch (lifecycle.status) {
    case SubscriptionBillingStatus.grace:
    case SubscriptionBillingStatus.overdue:
      return Icons.warning;
    case SubscriptionBillingStatus.active:
      if (lifecycle.daysUntilDue <= 3) {
        return Icons.warning;
      }
      if (lifecycle.daysUntilDue <= 7) {
        return Icons.schedule;
      }
      return Icons.check_circle_outline;
  }
}

enum RenewalStatus {
  overdue,
  urgent,
  upcoming,
  normal,
}

RenewalStatus getRenewalStatus(
  DateTime renewalDate, {
  SubscriptionPeriodicity periodicity = SubscriptionPeriodicity.monthly,
  DateTime? today,
}) {
  final lifecycle = calculateSubscriptionLifecycle(
    storedDueDate: renewalDate,
    periodicity: periodicity,
    today: today,
  );

  switch (lifecycle.status) {
    case SubscriptionBillingStatus.grace:
    case SubscriptionBillingStatus.overdue:
      return RenewalStatus.overdue;
    case SubscriptionBillingStatus.active:
      if (lifecycle.daysUntilDue <= 3) {
        return RenewalStatus.urgent;
      }
      if (lifecycle.daysUntilDue <= 7) {
        return RenewalStatus.upcoming;
      }
      return RenewalStatus.normal;
  }
}

int getDaysUntilRenewal(
  DateTime renewalDate, {
  SubscriptionPeriodicity periodicity = SubscriptionPeriodicity.monthly,
  DateTime? today,
}) {
  final lifecycle = calculateSubscriptionLifecycle(
    storedDueDate: renewalDate,
    periodicity: periodicity,
    today: today,
  );

  if (lifecycle.status == SubscriptionBillingStatus.active) {
    return lifecycle.daysUntilDue;
  }

  return -lifecycle.daysOverdue;
}
