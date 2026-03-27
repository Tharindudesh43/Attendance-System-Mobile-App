import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handle background messages
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📩 Background message received');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Data: ${message.data}');
}

/// Notification Service Class
class NotificationServices {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // Optional callback to handle incoming notifications
  static void Function(RemoteMessage message)? onNotificationReceived;

  /// Initialize local notifications
  static Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(initSettings);

    // Android 13+ permission
    await _requestNotificationPermission();
  }

  /// Request notification permission (Android 13+)
  static Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  /// Show a local notification
  static Future<void> showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'attendance_channel', // channel id
          'Attendance Notifications', // channel name
          channelDescription: 'Notifications for attendance app',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    try {
      await _localNotifications.show(
        message.hashCode, // unique id for each notification
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
        platformDetails,
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  /// Initialize Firebase Messaging and listeners
  static Future<void> initFirebaseMessaging() async {
    // Print FCM token
    final token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground message: ${message.notification?.title}');
      showLocalNotification(message);

      // Call the Riverpod callback if provided
      onNotificationReceived?.call(message);
    });

    // Handle messages when app opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📩 Opened app via notification: ${message.notification?.title}');
      showLocalNotification(message);

      onNotificationReceived?.call(message);
    });

    // Handle background/terminated messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}
