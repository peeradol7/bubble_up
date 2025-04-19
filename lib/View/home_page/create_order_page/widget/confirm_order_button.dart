import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/Controller/notification_controller.dart';
import 'package:thammasat/Controller/order_controller.dart';
import 'package:thammasat/Controller/position_controller.dart';
import 'package:thammasat/constants/app_theme.dart';

import '../../../../Controller/laundry_controller.dart';
import '../../../../Model/order_model.dart';
import '../../../../Service/shared_preferenes_service.dart';

class ConfirmOrderButton extends StatelessWidget {
  ConfirmOrderButton({super.key});
  final PositionController positionController = Get.find<PositionController>();
  final LaundryController laundryController = Get.find<LaundryController>();
  final OrderController orderController = Get.find<OrderController>();
  final AuthController authController = Get.find<AuthController>();
  final NotificationController notificationController =
      Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: GetX<LaundryController>(
        builder: (controller) => ElevatedButton.icon(
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  content: Row(
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 20),
                      const Text("กำลังค้นหาไรเดอร์"),
                    ],
                  ),
                );
              },
            );

            await Future.delayed(const Duration(seconds: 3));

            Navigator.of(context).pop();

            await saveOrder(context);
            notificationController.showOrderSuccessNotification();
            context.pop();
          },
          icon: Icon(Icons.check, color: Colors.white),
          label: Text(
            'ยืนยันออเดอร์ ราคารวม: ${controller.totalPrice.value} บาท',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            disabledBackgroundColor: Colors.grey,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
        ),
      ),
    );
  }

  Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              const Text("กำลังโหลด..."),
            ],
          ),
        );
      },
    );
  }

  Future<void> saveOrder(BuildContext context) async {
    final prefsService = await SharedPreferencesService.getInstance();
    final userData = prefsService.getUserData();

    final userId = userData['userId'];
    final address = userData['address'];
    final phoneNumber = userData['phoneNumber'];
    final laundryId = laundryController.laundryDataById.value?.laundryId;
    final laundryName = laundryController.laundryDataById.value?.laundryName;
    final totalPrice = laundryController.totalPrice.value;
    final paymentMethod = laundryController.paymentMethod.value;
    final deliveryType = laundryController.deliveryType.value;
    final status = 'Pending';
    final customerLatitude = positionController.currentLatLng.value;

    if (userId != null &&
        laundryId != null &&
        address != null &&
        laundryName != null &&
        phoneNumber != null &&
        customerLatitude != null) {
      OrderModel newOrder = OrderModel(
        orderId: null,
        userId: userId,
        laundryId: laundryId,
        laundryName: laundryName,
        totalPrice: totalPrice,
        address: address,
        paymentMethod: paymentMethod,
        deliveryType: deliveryType,
        status: status,
        phoneNumber: phoneNumber,
        deliveryAddress: {
          "latitude": customerLatitude.latitude,
          "longitude": customerLatitude.longitude,
        },
        laundryAddress: LatLng(
          laundryController.laundryDataById.value?.latitude ?? 0,
          laundryController.laundryDataById.value?.longitude ?? 0,
        ),
      );
      await orderController.addOrder(newOrder);
    } else {
      print('ข้อมูลไม่ครบถ้วน กรุณาตรวจสอบอีกครั้ง');
    }
  }
}
