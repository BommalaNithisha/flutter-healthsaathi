import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// A utility class for handling local notifications.
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification service.
  /// This should be called once, preferably in `main()`.
  Future<void> init() async {
    // Initialize timezone database, required for zonedSchedule.
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS/macOS initialization settings
    const DarwinInitializationSettings darwinInitSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings for all platforms
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: darwinInitSettings,
      macOS: darwinInitSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  void _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      debugPrint('Notification payload: $payload');
      // You can handle navigation or logic based on payload here
    }
  }

  /// Requests notification permissions for Android and iOS.
  Future<void> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  /// Shows an immediate notification.
  Future<void> showReminder(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Immediate reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  /// Schedules a notification after a delay (used for testing).
  Future<void> scheduleReminder({
    required String title,
    required String body,
    int delaySeconds = 10,
  }) async {
    final scheduledTime =
        tz.TZDateTime.now(tz.local).add(Duration(seconds: delaySeconds));

    const androidDetails = AndroidNotificationDetails(
      'medicine_channel',
      'Medicine Reminders',
      channelDescription: 'Reminder notifications for medicine',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      scheduledTime.millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Schedules a reminder at a specific `DateTime`.
  Future<void> scheduleReminderAt({
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    final scheduledTime = tz.TZDateTime.from(dateTime, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'medicine_channel',
      'Medicine Reminders',
      channelDescription: 'Reminder notifications for medicine',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      scheduledTime.millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation:
      // UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Daily repetition
    );
  }
}
