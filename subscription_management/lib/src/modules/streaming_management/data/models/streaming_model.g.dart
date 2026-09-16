// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaming_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamingModel _$StreamingModelFromJson(Map<String, dynamic> json) =>
    StreamingModel(
      streamingId: json['streamingId'] as String?,
      streamingImage: json['streamingImage'] as String?,
      startsAt: const TimestampConverter().fromJson(json['startsAt']),
      paymentMethod: $enumDecodeNullable(
        _$PaymentMethodEnumMap,
        json['paymentMethod'],
      ),
      streamingValue: json['streamingValue'] as num?,
      renewalDate: const TimestampConverter().fromJson(json['renewalDate']),
      streamingName: json['streamingName'] as String,
      periodicity: $enumDecodeNullable(
        _$SubscriptionPeriodicityEnumMap,
        json['periodicity'],
      ),
    );

Map<String, dynamic> _$StreamingModelToJson(StreamingModel instance) =>
    <String, dynamic>{
      'streamingId': instance.streamingId,
      'streamingImage': instance.streamingImage,
      'streamingName': instance.streamingName,
      'streamingValue': instance.streamingValue,
      'renewalDate': const TimestampConverter().toJson(instance.renewalDate),
      'startsAt': const TimestampConverter().toJson(instance.startsAt),
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod],
      'periodicity': _$SubscriptionPeriodicityEnumMap[instance.periodicity],
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.creditCard: 'creditCard',
  PaymentMethod.debitCard: 'debitCard',
  PaymentMethod.pix: 'pix',
};

const _$SubscriptionPeriodicityEnumMap = {
  SubscriptionPeriodicity.monthly: 'mensal',
  SubscriptionPeriodicity.annual: 'anual',
};
