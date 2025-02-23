import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:thammasat/Controller/laundry_controller.dart';

class DisplayLaundryName extends StatelessWidget {
  DisplayLaundryName({super.key});

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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '${data.laundryName}',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            '${data.detail}',
            style: TextStyle(fontSize: 14),
          ),
        ],
      );
    });
  }
}
