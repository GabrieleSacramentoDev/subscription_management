import 'package:equatable/equatable.dart';

class SubscriptionEntity extends Equatable {
  final String? id;
  final String name;
  final num? price;
  final DateTime? dueDate;

  const SubscriptionEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [id, name, price, dueDate];
}
