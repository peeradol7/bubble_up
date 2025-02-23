import 'package:get/get.dart';
import 'package:thammasat/Service/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    notificationService.requestNotificationPermission();
  }
}
