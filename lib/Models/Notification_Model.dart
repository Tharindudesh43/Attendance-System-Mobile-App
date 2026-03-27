class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isViewed;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isViewed = false,
  });
}
