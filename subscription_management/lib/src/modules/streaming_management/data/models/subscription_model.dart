import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/subscriptions_entity.dart';
part 'subscription_model.g.dart';

@JsonSerializable()
class SubscriptionModel extends Equatable {
  final String? id;
  final String name;
  final num? price;
  final DateTime? dueDate;

  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.price,
    required this.dueDate,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  factory SubscriptionModel.fromMap(Map<String, dynamic> data) {
    return SubscriptionModel(
      id: data['id'] as String,
      name: data['name'] as String,
      price: data['price'] as double,
      dueDate: DateTime.parse(data['dueDate'] as String),
    );
  }

  SubscriptionEntity toEntity() {
    return SubscriptionEntity(
      id: id,
      name: name,
      price: price,
      dueDate: dueDate,
    );
  }

  @override
  List<Object?> get props => [id, name, price, dueDate];
}
