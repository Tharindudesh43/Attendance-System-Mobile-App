import 'package:attendance_system_flutter_application/Models/Notification_Model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationNotifier extends StateNotifier<List<AppNotification>> {
  NotificationNotifier() : super([]);

  void addNotification(AppNotification notification) {
    state = [...state, notification]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // sort by recent
  }

  void markAsViewed(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isViewed: true) else n
    ];
  }

  void markAllAsViewed() {
    state = [
      for (final n in state) n.copyWith(isViewed: true),
    ];
  }
}

extension on AppNotification {
  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    bool? isViewed,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isViewed: isViewed ?? this.isViewed,
    );
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<AppNotification>>(
  (ref) => NotificationNotifier(),
);
