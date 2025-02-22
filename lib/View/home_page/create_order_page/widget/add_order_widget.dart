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
      int selectedDeliveryPrice =
          deliveryPrices[laundryController.deliveryType.value] ?? 0;
      int selectedLaundryPrice = data.price[laundryController.price.value] ?? 0;

      int totalPrice = selectedLaundryPrice + selectedDeliveryPrice;

      laundryController.totalPrice.value = totalPrice;
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
                  },
                ),
                RadioListTile<String>(
                  title: Text('ส่งปกติ: ${deliveryPrices['normal']} บาท'),
                  value: 'normal',
                  groupValue: laundryController.deliveryType.value,
                  onChanged: (value) {
                    laundryController.deliveryType.value = value!;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      );
    });
  }
}
