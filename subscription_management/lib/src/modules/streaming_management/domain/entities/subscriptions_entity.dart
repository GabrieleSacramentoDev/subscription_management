import 'package:equatable/equatable.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/enums/subscription_periodicity.dart';

class SubscriptionEntity extends Equatable {
  final String? id;
  final String name;
  final num? price;
  final DateTime? dueDate;
  final SubscriptionPeriodicity periodicity;

  const SubscriptionEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.dueDate,
    this.periodicity = SubscriptionPeriodicity.monthly,
  });

  @override
  List<Object?> get props => [id, name, price, dueDate, periodicity];
}
