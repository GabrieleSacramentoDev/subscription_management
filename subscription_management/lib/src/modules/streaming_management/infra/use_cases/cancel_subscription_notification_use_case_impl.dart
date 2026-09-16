import 'package:subscription_management/src/modules/streaming_management/domain/repositories/notifications_repository.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/cancel_subscription_notification_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/utils/subscription_notification_id.dart';

class CancelSubscriptionNotificationUseCaseImpl
    implements CancelSubscriptionNotificationUseCase {
  CancelSubscriptionNotificationUseCaseImpl({required this.repository});

  final NotificationRepository repository;

  @override
  Future<void> call(String subscriptionId) async {
    if (subscriptionId.isEmpty) {
      return;
    }
    await repository.cancelNotification(
      subscriptionNotificationId(subscriptionId),
    );
    await repository.cancelNotification(
      graceSubscriptionNotificationId(subscriptionId),
    );
  }
}
