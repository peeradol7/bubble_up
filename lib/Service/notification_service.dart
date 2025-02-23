import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  Future<void> requestNotificationPermission() async {
    try {
      // Request notification permission
      print("Requesting notification permission...");
      final status = await Permission.notification.request();

      if (status.isGranted) {
        print("Notification permission granted!");

        // Initialize FlutterLocalNotificationsPlugin if permission is granted
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();

        print("Initializing notification plugin...");

        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');
        const DarwinInitializationSettings initializationSettingsIOS =
            DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

        const InitializationSettings initializationSettings =
            InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

        print("Initializing settings for notifications...");
        await flutterLocalNotificationsPlugin
            .initialize(initializationSettings);
        print("Notification plugin initialized successfully.");
      } else {
        print("Notification permission denied.");
      }
    } catch (e) {
      // Catch and log any errors
      print("An error occurred while requesting notification permission: $e");
    }
  }
}
