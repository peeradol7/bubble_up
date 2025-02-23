import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controller/laundry_controller.dart';

class AddOrderWidget extends StatelessWidget {
  AddOrderWidget({super.key});
  final LaundryController laundryController = Get.find<LaundryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = laundryController.laundryDataById.value;
      final deliveryPrices = laundryController.deliveryPrices.value;

      if (data == null) {
        return const Center(child: Text("กำลังโหลด..."));
      }

      final selectedDeliveryPrice =
          deliveryPrices[laundryController.deliveryType.value] ?? 0;
      final selectedLaundryPrice =
          data.price[laundryController.price.value] ?? 0;

      final totalPrice = selectedLaundryPrice + selectedDeliveryPrice;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ราคา:',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                ...data.price.entries.map((entry) {
                  return RadioListTile<String>(
                    title: Text('${entry.key}: ${entry.value} บาท'),
                    hoverColor: Colors.blue,
                    value: entry.key,
                    groupValue: laundryController.price.value,
                    onChanged: (value) {
                      laundryController.price.value = value!;
                      // Calculate and update total price here instead
                      _updateTotalPrice();
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เลือกการส่ง:',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                RadioListTile<String>(
                  title: Text('ส่งด่วน: ${deliveryPrices['express']} บาท'),
                  value: 'express',
                  groupValue: laundryController.deliveryType.value,
                  onChanged: (value) {
                    laundryController.deliveryType.value = value!;
                    _updateTotalPrice();
                  },
                ),
                RadioListTile<String>(
                  title: Text('ส่งปกติ: ${deliveryPrices['normal']} บาท'),
                  value: 'normal',
                  groupValue: laundryController.deliveryType.value,
                  onChanged: (value) {
                    laundryController.deliveryType.value = value!;
                    _updateTotalPrice();
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ชำระเงินโดย',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    RadioListTile<String>(
                      title: Text('เงินสด'),
                      value: 'เงินสด',
                      groupValue: laundryController.paymentMethod.value,
                      onChanged: (value) {
                        laundryController.paymentMethod.value = value!;
                        _updateTotalPrice();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      );
    });
  }

  void _updateTotalPrice() {
    final data = laundryController.laundryDataById.value;
    final deliveryPrices = laundryController.deliveryPrices.value;

    if (data != null) {
      final selectedDeliveryPrice =
          deliveryPrices[laundryController.deliveryType.value] ?? 0;
      final selectedLaundryPrice =
          data.price[laundryController.price.value] ?? 0;

      laundryController.totalPrice.value =
          selectedLaundryPrice + selectedDeliveryPrice;
    }
  }
}
