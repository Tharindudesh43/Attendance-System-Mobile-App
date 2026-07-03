// lib/Services/NotificationPermissionService.dart

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionService {
  
  static Future<void> requestNotificationPermission(BuildContext context) async {
    final status = await Permission.notification.status;

    if (status.isDenied) {
      await _showPermissionDialog(context);
    } else if (status.isPermanentlyDenied) {
      await _showSettingsDialog(context);
    }
  }

  static Future<void> _showPermissionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.notifications_active, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text("Enable Notifications"),
          ],
        ),
        content: const Text(
          "Marky needs notification permission to alert you about:\n\n"
          "• Attendance reminders\n"
          "• Class schedule updates\n"
          "• Important announcements",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Not Now", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final result = await Permission.notification.request();
              debugPrint("🔔 Notification permission: $result");
            },
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }

  static Future<void> _showSettingsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.notifications_off, color: Colors.orange),
            SizedBox(width: 8),
            Text("Notifications Blocked"),
          ],
        ),
        content: const Text(
          "Notifications are blocked. Please enable them in Settings to receive important updates.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              openAppSettings(); // Opens phone settings
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}