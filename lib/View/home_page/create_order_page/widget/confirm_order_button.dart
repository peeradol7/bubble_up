import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/Controller/order_controller.dart';
import 'package:thammasat/Controller/position_controller.dart';

import '../../../../Controller/laundry_controller.dart';
import '../../../../Model/order_model.dart';

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
          onPressed: controller.totalPrice.value > 0 ? () => saveOrder() : null,
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

  void saveOrder() {
    final userId = authController.userModel.value!.userId;
    final laundryId = laundryController.laundryDataById.value!.laundryId;
    final totalPrice = laundryController.totalPrice.value;
    final address = authController.userModel.value!.address;
    final paymentMethod = laundryController.paymentMethod.value;
    final deliveryType = laundryController.deliveryType.value;
    final status = laundryController.status.value;
    final laundryLatitude = laundryController.laundryDataById.value!.latitude;
    final laundryLongitude = laundryController.laundryDataById.value!.longitude;
    final customerLatitude = positionController.currentLatLng.value;

    if (userId == null || userId.isEmpty) print('User ID is empty');
    if (laundryId == null || laundryId.isEmpty) print('Laundry ID is empty');
    if (totalPrice == null || totalPrice == 0) print('Total price is empty');
    if (address == null || address.isEmpty) print('Address is empty');
    if (paymentMethod == null || paymentMethod.isEmpty) {
      print('Payment method is empty');
    }
    if (deliveryType == null || deliveryType.isEmpty) {
      print('Delivery type is empty');
    }
    if (status == null || status.isEmpty) print('Status is empty');
    if (laundryLatitude == null) print('Laundry latitude is empty');
    if (laundryLongitude == null) print('Laundry longitude is empty');
    if (customerLatitude == null) print('Customer latitude is empty');

    if (userId != null &&
        laundryId != null &&
        totalPrice != null &&
        address != null &&
        paymentMethod != null &&
        deliveryType != null &&
        status != null &&
        laundryLatitude != null &&
        laundryLongitude != null &&
        customerLatitude != null) {
      OrderModel newOrder = OrderModel(
        orderId: FirebaseFirestore.instance.collection('orders').doc().id,
        userId: userId,
        laundryId: laundryId,
        totalPrice: totalPrice,
        address: address,
        paymentMethod: paymentMethod,
        deliveryType: deliveryType,
        status: status,
        deliveryAddress: {
          "latitude": customerLatitude.latitude,
          "longitude": customerLatitude.longitude,
        },
        laundryAddress: {
          'latitude': laundryLatitude,
          'longitude': laundryLongitude,
        },
      );

      orderController.addOrder(newOrder);
      Get.snackbar(
        'บันทึกออเดอร์',
        'บันทึกออเดอร์สมบูรณ์',
        backgroundColor: Colors.green,
      );
    } else {
      print('ข้อมูลไม่ครบถ้วน กรุณาตรวจสอบอีกครั้ง');
    }
  }
}
