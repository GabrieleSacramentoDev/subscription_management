import 'package:subscription_management/src/modules/streaming_management/domain/entities/streaming_entity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/entities/subscriptions_entity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/schedule_subscription_notification_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/sync_subscription_notifications_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/utils/subscription_lifecycle.dart';

class SyncSubscriptionNotificationsUseCaseImpl
    implements SyncSubscriptionNotificationsUseCase {
  SyncSubscriptionNotificationsUseCaseImpl({
    required this.scheduleSubscriptionNotificationUseCase,
  });

  final ScheduleSubscriptionNotificationUseCase
  scheduleSubscriptionNotificationUseCase;

  @override
  Future<void> call(List<StreamingEntity> streamings) async {
    for (final streaming in streamings) {
      final subscriptionId = streaming.streamingId;
      if (subscriptionId == null || subscriptionId.isEmpty) {
        continue;
      }
      final renewalDate = streaming.renewalDate;
      if (renewalDate == null) {
        continue;
      }

      final lifecycle = calculateSubscriptionLifecycle(
        storedDueDate: renewalDate,
        periodicity: streaming.periodicity,
      );

      await scheduleSubscriptionNotificationUseCase.call(
        SubscriptionEntity(
          id: subscriptionId,
          name: streaming.streamingName,
          price: streaming.streamingValue,
          dueDate: lifecycle.effectiveDueDate,
          periodicity: streaming.periodicity,
        ),
      );
    }
  }
}
