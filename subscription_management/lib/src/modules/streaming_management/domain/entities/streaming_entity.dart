import 'package:equatable/equatable.dart';
import 'package:subscription_management/src/modules/home/domain/enums/payment_method.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/enums/subscription_periodicity.dart';

class StreamingEntity extends Equatable {
  final String? streamingId;
  final String streamingName;
  final String? streamingImage;
  final num? streamingValue;
  final DateTime? startsAt;
  final DateTime? renewalDate;
  final PaymentMethod? paymentMethod;
  final SubscriptionPeriodicity periodicity;

  const StreamingEntity({
    this.startsAt,
    this.streamingId,
    this.paymentMethod,
    this.streamingValue,
    this.renewalDate,
    this.streamingImage,
    required this.streamingName,
    this.periodicity = SubscriptionPeriodicity.monthly,
  });

  StreamingEntity copyWith({
    String? streamingId,
    String? streamingName,
    String? streamingImage,
    num? streamingValue,
    DateTime? startsAt,
    DateTime? renewalDate,
    PaymentMethod? paymentMethod,
    SubscriptionPeriodicity? periodicity,
  }) {
    return StreamingEntity(
      streamingId: streamingId ?? this.streamingId,
      streamingName: streamingName ?? this.streamingName,
      streamingImage: streamingImage ?? this.streamingImage,
      streamingValue: streamingValue ?? this.streamingValue,
      startsAt: startsAt ?? this.startsAt,
      renewalDate: renewalDate ?? this.renewalDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      periodicity: periodicity ?? this.periodicity,
    );
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
    periodicity,
  ];
}
