import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    try {
      print("Requesting notification permission...");
      final status = await Permission.notification.request();

      if (status.isGranted) {
        print("Notification permission granted!");

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
      print("An error occurred while requesting notification permission: $e");
    }
  }

  Future<void> showNotification(
      {required String title, required String body}) async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const Color iconColor = Colors.blue;

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'order_channel_id',
      'Order Notifications',
      channelDescription: 'Notifications for order status updates',
      importance: Importance.max,
      priority: Priority.high,
      color: iconColor,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}
