import 'package:get/get.dart';
import 'package:thammasat/Controller/order_controller.dart';
import 'package:thammasat/Service/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService notificationService = NotificationService();
  final OrderController orderController = Get.find<OrderController>();
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
      body: 'กำลังค้นหาไรเดอร์',
    );
  }

  Future<void> showOrderCompleteNotification() async {
    await notificationService.showNotification(
      title: 'สำเร็จ',
      body: 'ออเดอร์เสร็จสิ้น',
    );
  }
}
