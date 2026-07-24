import 'package:subscription_management/src/modules/streaming_management/domain/entities/subscriptions_entity.dart';

abstract class ScheduleSubscriptionNotificationUseCase {
  Future<void> call(SubscriptionEntity subscription);
}
