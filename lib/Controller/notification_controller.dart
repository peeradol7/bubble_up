import 'package:get/get.dart';
import 'package:thammasat/Service/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    notificationService.requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    await notificationService.requestNotificationPermission();
  }

  Future<void> showOrderSuccessNotification() async {
    await notificationService.showNotification(
      title: 'สร้างออเดอร์สำเร็จ',
      body: 'กำลังรอไรเดอร์รับออเดอร์',
    );
  }
}
