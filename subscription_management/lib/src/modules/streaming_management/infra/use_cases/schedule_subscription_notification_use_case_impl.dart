import 'package:subscription_management/src/modules/streaming_management/domain/entities/subscriptions_entity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/repositories/notifications_repository.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/schedule_subscription_notification_use_case.dart';

class ScheduleSubscriptionNotificationUseCaseImpl
    implements ScheduleSubscriptionNotificationUseCase {
  final NotificationRepository repository;

  ScheduleSubscriptionNotificationUseCaseImpl({required this.repository});

  @override
  Future<void> call(SubscriptionEntity subscription) async {
    final reminderDate = subscription.dueDate!.subtract(
      const Duration(days: 1),
    );
    final scheduledDateTime = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      9,
    );

    if (scheduledDateTime.isAfter(DateTime.now())) {
      await repository.scheduleNotification(
        id: subscription.id.hashCode,
        title: 'Sua assinatura renova amanhã! 💳',
        body:
            'Sua assinatura do(a) ${subscription.name} no valor de R\$ ${subscription.price!.toStringAsFixed(2)} renova amanhã.',
        scheduledDate: scheduledDateTime,
        payload: subscription.id,
      );
    }
  }
}
