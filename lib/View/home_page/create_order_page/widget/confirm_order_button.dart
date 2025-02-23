import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controller/laundry_controller.dart';

class ConfirmOrderButton extends StatelessWidget {
  ConfirmOrderButton({super.key});
  final LaundryController laundryController = Get.find<LaundryController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: GetX<LaundryController>(
        builder: (controller) => ElevatedButton.icon(
          onPressed: controller.totalPrice.value > 0
              ? () => handleConfirmOrder()
              : null,
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

  void handleConfirmOrder() {
    print(
      'Confirming order with total price: ${laundryController.totalPrice.value}',
    );
  }
}
