import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/Controller/order_controller.dart';
import 'package:thammasat/Controller/position_controller.dart';

import '../../../../Controller/laundry_controller.dart';
import '../../../../Model/order_model.dart';
import '../../../../Service/shared_preferenes_service.dart';

class ConfirmOrderButton extends StatelessWidget {
  ConfirmOrderButton({super.key});
  final PositionController positionController = Get.find<PositionController>();
  final LaundryController laundryController = Get.find<LaundryController>();
  final OrderController orderController = Get.find<OrderController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: GetX<LaundryController>(
        builder: (controller) => ElevatedButton.icon(
          onPressed: () {
            saveOrder();
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

  void saveOrder() async {
    final prefsService = await SharedPreferencesService.getInstance();
    final userData = prefsService.getUserData();

    final userId = userData['userId'];
    final address = userData['address'];

    final laundryId = laundryController.laundryDataById.value?.laundryId;
    final totalPrice = laundryController.totalPrice.value;
    final paymentMethod = laundryController.paymentMethod.value;
    final deliveryType = laundryController.deliveryType.value;
    final status = laundryController.status.value;

    final customerLatitude = positionController.currentLatLng.value;
    if (userId != null &&
        laundryId != null &&
        totalPrice != null &&
        address != null &&
        paymentMethod != null &&
        deliveryType != null &&
        status != null &&
        laundryController.laundryDataById.value!.latitude != null &&
        laundryController.laundryDataById.value!.longitude != null &&
        customerLatitude != null) {
      String orderId = FirebaseFirestore.instance.collection('orders').doc().id;
      OrderModel newOrder = OrderModel(
        orderId: orderId,
        userId: userId,
        laundryId: laundryId,
        totalPrice: totalPrice,
        address: address,
        paymentMethod: paymentMethod,
        deliveryType: deliveryType,
        status: status,
        laundryAddress: LatLng(laundryController.laundryLatLng.value!.latitude,
            laundryController.laundryLatLng.value!.longitude),
        deliveryAddress: {
          "latitude": customerLatitude.latitude,
          "longitude": customerLatitude.longitude,
        },
      );
      print(newOrder.laundryAddress);
      print(newOrder.deliveryAddress);
      orderController.addOrder(newOrder);
    } else {
      print('ข้อมูลไม่ครบถ้วน กรุณาตรวจสอบอีกครั้ง');
    }
  }
}
