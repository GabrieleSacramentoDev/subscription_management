// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      price: json['price'] as num?,
      dueDate:
          json['dueDate'] == null
              ? null
              : DateTime.parse(json['dueDate'] as String),
    );
