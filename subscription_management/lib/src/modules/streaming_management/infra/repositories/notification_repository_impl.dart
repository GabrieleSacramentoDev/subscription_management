import 'package:subscription_management/src/modules/streaming_management/domain/repositories/notifications_repository.dart';
import 'package:subscription_management/src/modules/streaming_management/infra/datasources/notification_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource dataSource;

  NotificationRepositoryImpl({required this.dataSource});

  @override
  Future<void> init() => dataSource.init();

  @override
  Future<bool> requestPermissions() => dataSource.requestPermissions();

  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) {
    return dataSource.schedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      payload: payload,
    );
  }

  @override
  Future<void> cancelNotification(int id) => dataSource.cancel(id);
}
