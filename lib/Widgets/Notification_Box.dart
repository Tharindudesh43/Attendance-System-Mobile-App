import 'dart:ui';
import 'package:attendance_system_flutter_application/Providers/NotificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationBox extends ConsumerStatefulWidget {
  final VoidCallback? onClose;
  WidgetRef ref;
  NotificationBox({super.key, this.onClose, required this.ref});

  @override
  ConsumerState<NotificationBox> createState() => _NotificationBoxState();
}

class _NotificationBoxState extends ConsumerState<NotificationBox> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationProvider);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 400, // Increased width
            constraints: const BoxConstraints(
              maxHeight: 600, // Optional: limit max height
            ),
            color: Colors.white.withOpacity(0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Notifications",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            108,
                            102,
                            102,
                          ), // background color
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(66, 179, 179, 179),
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.close,
                          size: 17,
                          weight: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Scrollable list
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: notifications
                          .map(
                            (n) => ListTile(
                              title: Text(n.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.body),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${n.timestamp.hour.toString().padLeft(2, '0')}:${n.timestamp.minute.toString().padLeft(2, '0')} - ${n.timestamp.day}/${n.timestamp.month}/${n.timestamp.year}",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: n.isViewed
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : const Icon(
                                      Icons.fiber_new,
                                      color: Colors.red,
                                    ),
                              onTap: () {
                                ref
                                    .read(notificationProvider.notifier)
                                    .markAsViewed(n.id);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    ref.read(notificationProvider.notifier).markAllAsViewed();
                    Navigator.pop(context);
                  },
                  child: const Text("Mark All as Viewed"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
