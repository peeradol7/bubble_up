import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/Controller/order_controller.dart';
import 'package:thammasat/Service/notification_service.dart';

import '../Model/order_model.dart';

class NotificationController extends GetxController {
  final NotificationService notificationService = NotificationService();
  final OrderController orderController = Get.find<OrderController>();
  StreamSubscription? _orderSubscription;

  final isListening = false.obs;
  final lastProcessedOrder = Rxn<OrderModel>();
  final _notificationQueue = <_NotificationMessage>[].obs;

  final Set<String> _processedNotifications = {};

  @override
  void onInit() {
    super.onInit();
    notificationService.requestNotificationPermission();
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      await requestNotificationPermission();
      await _setupOrderListener();
    } catch (e) {}
  }

  Future<void> requestNotificationPermission() async {
    try {
      await notificationService.requestNotificationPermission();
    } catch (e) {}
  }

  Future<void> _setupOrderListener() async {
    try {
      final authController = Get.find<AuthController>();
      final userData = await authController.loadUserData();

      if (userData != null) {
        final userId = userData['userId'] as String;

        await _orderSubscription?.cancel();

        _orderSubscription = FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .snapshots()
            .listen(
          (snapshot) {
            _handleSnapshotChanges(snapshot);
          },
          onError: (error) {},
          cancelOnError: false,
        );

        isListening.value = true;
      } else {}
    } catch (e, stack) {
      print('Stack trace: $stack');
    }
  }

  void _handleSnapshotChanges(QuerySnapshot snapshot) {
    try {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          final order = OrderModel.fromFirestore(change.doc);
          if (order.orderId != null && order.status != null) {
            _processStatusChange(order);
          } else {}
        }
      }
    } catch (e) {}
  }

  void _processStatusChange(OrderModel order) {
    try {
      if (order.orderId == null || order.status == null) {
        return;
      }

      final notificationId = '${order.orderId}-${order.status}';

      if (!_processedNotifications.contains(notificationId)) {
        _processedNotifications.add(notificationId);
        lastProcessedOrder.value = order;

        final laundryName = order.laundryName ?? 'Unknown';

        String title = '';
        String message = '';

        switch (order.status?.toLowerCase()) {
          case 'in progress':
            title = 'คำสั่งซื้อปรับปรุง';
            message = 'คำสั่งซื้อของคุณที่ $laundryName กำลังดำเนินการ';
            break;
          case 'completed':
            title = 'คำสั่งซื้อเสร็จสมบูรณ์';
            message = 'คำสั่งซื้อของคุณที่ $laundryName พร้อมรับแล้ว';
            break;
          case 'cancelled':
            title = 'คำสั่งซื้อถูกยกเลิก';
            message = 'คำสั่งซื้อของคุณที่ $laundryName ถูกยกเลิก';
            break;
          default:
            print('NotificationController: Unhandled status: ${order.status}');
            return;
        }

        _queueNotification(title, message);
      } else {
        print(
            'NotificationController: Notification already processed for ID: $notificationId');
      }
    } catch (e) {
      print('NotificationController: Error processing status change: $e');
    }
  }

  void _queueNotification(String title, String message) {
    _notificationQueue.add(_NotificationMessage(title, message));
    _processNotificationQueue();
  }

  void _processNotificationQueue() {
    if (!Get.isRegistered<NotificationController>()) return;

    try {
      while (_notificationQueue.isNotEmpty) {
        final notification = _notificationQueue.first;
        _showNotification(notification.title, notification.message);
        _notificationQueue.removeAt(0);
      }
    } catch (e) {
      print('NotificationController: Error processing notification queue: $e');
    }
  }

  void _showNotification(String title, String message) {
    try {
      print('NotificationController: Attempting to show notification');

      // ใช้ Local Notification แทน Snackbar
      notificationService.showNotification(
        title: title,
        body: message,
      );

      // ถ้ายังต้องการแสดง Snackbar ด้วย ให้ใช้ Future.delayed
      Future.delayed(Duration.zero, () {
        if (Get.context != null) {
          Get.snackbar(
            title,
            message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white,
            colorText: Colors.black87,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(8),
            borderRadius: 8,
            icon: const Icon(Icons.notifications_active, color: Colors.blue),
          );
        }
      });
    } catch (e) {
      print('NotificationController: Error showing notification: $e');
    }
  }

  Future<void> refreshListener() async {
    await _setupOrderListener();
  }

  @override
  void onClose() {
    print('NotificationController: Closing controller');
    _orderSubscription?.cancel();
    super.onClose();
  }

  Future<void> showOrderSuccessNotification() async {
    await notificationService.showNotification(
      title: 'สร้างออเดอร์สำเร็จ',
      body: 'กำลังค้นหาไรเดอร์',
    );
  }
}

class _NotificationMessage {
  final String title;
  final String message;
  _NotificationMessage(this.title, this.message);
}
