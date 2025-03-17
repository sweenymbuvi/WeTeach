import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/material.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Define a callback type for when notifications are tapped
  static Function()? onNotificationTap;

  static Future<void> initialize() async {
    debugPrint('Initializing notification service');
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    // Create notification channel explicitly
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      debugPrint('Creating notification channel');
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'we_teach_channel',
        'We Teach Notifications',
        description: 'This channel is for app notifications',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      await androidPlugin.createNotificationChannel(channel);

      // For Android 13+, request permission
      try {
        await androidPlugin.requestNotificationsPermission();
        debugPrint('Requested notification permission');
      } catch (e) {
        debugPrint('Permission request method not available: $e');
      }
    }

    // Initialize with callback for handling notification taps
    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        debugPrint('Notification tapped: ${details.payload}');
        // Call the tap handler if set
        if (onNotificationTap != null) {
          onNotificationTap!();
        }
      },
    );

    debugPrint('Notification service initialized successfully');
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    debugPrint('Attempting to show notification: $title');

    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'we_teach_channel', // Must match channel created above
        'We Teach Notifications',
        channelDescription: 'This channel is for app notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      const NotificationDetails details =
          NotificationDetails(android: androidDetails);

      await _notificationsPlugin.show(id, title, body, details);
      debugPrint('Notification shown successfully');
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }
}
