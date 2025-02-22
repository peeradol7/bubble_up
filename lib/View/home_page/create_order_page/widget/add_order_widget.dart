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

      if (data == null) {
        return const Center(child: Text("กำลังโหลด..."));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ราคา:',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          ...data.price.entries.map((entry) {
            return RadioListTile<String>(
              title: Text('${entry.key}: ${entry.value} บาท'),
              value: entry.key, // เก็บคีย์เป็นค่าของ Radio
              groupValue: laundryController.price.value,
              onChanged: (value) {
                laundryController.price.value = value!;
              },
            );
          }).toList(),
        ],
      );
    });
  }
}
