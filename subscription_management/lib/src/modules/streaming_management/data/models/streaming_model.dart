import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:subscription_management/src/modules/home/domain/enums/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/streaming_entity.dart';
import 'package:subscription_management/src/utils/timestamp_converter.dart';
part 'streaming_model.g.dart';

@JsonSerializable()
class StreamingModel extends Equatable {
  final String? streamingId;
  final String? streamingImage;
  final String streamingName;
  final num? streamingValue;
  @TimestampConverter()
  final DateTime? renewalDate;
  @TimestampConverter()
  final DateTime? startsAt;
  final PaymentMethod? paymentMethod;

  const StreamingModel({
    this.streamingId,
    this.streamingImage,
    this.startsAt,
    this.paymentMethod,
    this.streamingValue,
    this.renewalDate,
    required this.streamingName,
  });

  factory StreamingModel.fromJson(Map<String, dynamic> json) =>
      _$StreamingModelFromJson(json);

  Map<String, dynamic> toJson() => _$StreamingModelToJson(this);

  factory StreamingModel.fromMap(Map<String, dynamic> data) {
    return StreamingModel(
      streamingId: data['streamingId'] as String?,
      streamingName: data['streamingName'] as String,
      streamingImage: data['streamingImage'] as String?,
      streamingValue: (data['streamingValue'] as num?)?.toDouble(),
      renewalDate: _convertTimestamp(data['renewalDate']),
      startsAt: _convertTimestamp(data['startsAt']),
      paymentMethod: data['paymentMethod'] != null
          ? PaymentMethod.values.firstWhere(
              (e) => e.name == data['paymentMethod'],
              orElse: () => PaymentMethod.creditCard,
            )
          : null,
    );
  }

  StreamingEntity toEntity() {
    return StreamingEntity(
      streamingId: streamingId,
      streamingName: streamingName,
      streamingImage: streamingImage,
      streamingValue: streamingValue,
      renewalDate: renewalDate,
      startsAt: startsAt,
      paymentMethod: paymentMethod,
    );
  }

  factory StreamingModel.fromEntity(StreamingEntity entity) {
    return StreamingModel(
      streamingId: entity.streamingId,
      streamingName: entity.streamingName,
      streamingImage: entity.streamingImage,
      streamingValue: entity.streamingValue,
      renewalDate: entity.renewalDate,
      startsAt: entity.startsAt,
      paymentMethod: entity.paymentMethod,
    );
  }
  static DateTime? _convertTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.tryParse(timestamp);
    }
    return null;
  }

  @override
  List<Object?> get props => [
    streamingId,
    streamingName,
    streamingImage,
    streamingValue,
    renewalDate,
    startsAt,
    paymentMethod,
  ];
}
