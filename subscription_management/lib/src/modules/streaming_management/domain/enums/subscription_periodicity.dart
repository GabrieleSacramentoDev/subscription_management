import 'package:json_annotation/json_annotation.dart';

enum SubscriptionPeriodicity {
  @JsonValue('mensal')
  monthly,
  @JsonValue('anual')
  annual;

  static SubscriptionPeriodicity fromStorage(String? value) {
    switch (value) {
      case 'anual':
        return SubscriptionPeriodicity.annual;
      case 'mensal':
      default:
        return SubscriptionPeriodicity.monthly;
    }
  }

  static String label(SubscriptionPeriodicity periodicity) {
    switch (periodicity) {
      case SubscriptionPeriodicity.monthly:
        return 'Mensal';
      case SubscriptionPeriodicity.annual:
        return 'Anual';
    }
  }

  static SubscriptionPeriodicity? fromLabel(String? label) {
    switch (label) {
      case 'Mensal':
        return SubscriptionPeriodicity.monthly;
      case 'Anual':
        return SubscriptionPeriodicity.annual;
      default:
        return null;
    }
  }
}
