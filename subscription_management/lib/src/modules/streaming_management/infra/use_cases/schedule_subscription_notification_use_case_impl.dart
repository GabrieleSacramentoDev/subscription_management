import 'package:subscription_management/src/modules/streaming_management/domain/entities/subscriptions_entity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/enums/subscription_periodicity.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/repositories/notifications_repository.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/use_cases/schedule_subscription_notification_use_case.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/utils/subscription_lifecycle.dart';
import 'package:subscription_management/src/modules/streaming_management/domain/utils/subscription_notification_id.dart';

class ScheduleSubscriptionNotificationUseCaseImpl
    implements ScheduleSubscriptionNotificationUseCase {
  ScheduleSubscriptionNotificationUseCaseImpl({required this.repository});

  final NotificationRepository repository;

  static const _reminderLeadTime = Duration(days: 1);
  static const _reminderHour = 9;

  @override
  Future<void> call(SubscriptionEntity subscription) async {
    final subscriptionId = subscription.id;
    final dueDate = subscription.dueDate;
    if (subscriptionId == null ||
        subscriptionId.isEmpty ||
        dueDate == null) {
      return;
    }

    await repository.requestPermissions();

    final reminderNotificationId = subscriptionNotificationId(subscriptionId);
    final graceNotificationId = graceSubscriptionNotificationId(subscriptionId);

    await repository.cancelNotification(reminderNotificationId);
    await repository.cancelNotification(graceNotificationId);

    final lifecycle = calculateSubscriptionLifecycle(
      storedDueDate: dueDate,
      periodicity: subscription.periodicity,
    );
    final effectiveDueDate = lifecycle.effectiveDueDate;

    final reminderDate = effectiveDueDate.subtract(_reminderLeadTime);
    final reminderDateTime = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      _reminderHour,
    );

    if (reminderDateTime.isAfter(DateTime.now())) {
      final price = subscription.price;
      final priceLabel = price != null
          ? 'R\$ ${price.toStringAsFixed(2)}'
          : 'valor não informado';

      await repository.scheduleNotification(
        id: reminderNotificationId,
        title: 'Sua assinatura renova amanhã! 💳',
        body:
            'Sua assinatura do(a) ${subscription.name} no valor de $priceLabel renova amanhã.',
        scheduledDate: reminderDateTime,
        payload: subscriptionId,
      );
    }

    if (subscription.periodicity != SubscriptionPeriodicity.monthly) {
      return;
    }

    final graceStart = effectiveDueDate.add(const Duration(days: 1));
    final graceNotificationDateTime = DateTime(
      graceStart.year,
      graceStart.month,
      graceStart.day,
      _reminderHour,
    );

    if (graceNotificationDateTime.isAfter(DateTime.now())) {
      await repository.scheduleNotification(
        id: graceNotificationId,
        title: 'Assinatura vencida — tolerância ativa',
        body:
            'A assinatura ${subscription.name} está vencida. Você tem até $subscriptionGracePeriodDays dias de tolerância antes do próximo ciclo.',
        scheduledDate: graceNotificationDateTime,
        payload: subscriptionId,
      );
    }
  }
}
