import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ✅ FIX 1 — Add @pragma and Firebase.initializeApp() in background handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // ❌ was missing — causes background notifications to fail
  print('📩 Background message received');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');

  // ✅ FIX 2 — Show notification in background too (was missing)
  await NotificationServices.showLocalNotification(message);
}

class NotificationServices {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static void Function(RemoteMessage message)? onNotificationReceived;

  static Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(initSettings);

    // ✅ FIX 3 — Create notification channel (was missing — required for Android 8+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'attendance_channel',
      'Attendance Notifications',
      description: 'Notifications for attendance app',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print("✅ Notification channel created");

    await _requestNotificationPermission();
  }

  static Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('🔔 Permission: ${settings.authorizationStatus}');
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'attendance_channel',
          'Attendance Notifications',
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
        message.hashCode,
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
        platformDetails,
      );
    } catch (e) {
      print('❌ Error showing notification: $e');
    }
  }

  static Future<void> initFirebaseMessaging() async {
    // ✅ FIX 4 — Register background handler FIRST before anything else
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final token = await _firebaseMessaging.getToken();
    print('📱 FCM Token: $token');

    // ✅ FIX 5 — Show foreground notifications as popups
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground: ${message.notification?.title}');
      showLocalNotification(message);
      onNotificationReceived?.call(message);
    });

    // Background → tapped
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 Opened from background: ${message.notification?.title}');
      onNotificationReceived?.call(message);
    });

    // ✅ FIX 6 — Handle terminated state (app was fully closed)
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('🚀 Opened from terminated: ${initialMessage.notification?.title}');
      onNotificationReceived?.call(initialMessage);
    }
  }
}