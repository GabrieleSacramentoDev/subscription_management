abstract class NotificationRepository {
  Future<void> init();
  Future<bool> requestPermissions();
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  });
  Future<void> cancelNotification(int id);
}
