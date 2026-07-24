abstract class NotificationLocalDataSource {
  Future<void> init();
  Future<bool> requestPermissions();
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  });
  Future<void> cancel(int id);
}
