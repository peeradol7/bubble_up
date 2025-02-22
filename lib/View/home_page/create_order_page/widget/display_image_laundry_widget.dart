import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/laundry_controller.dart';

class DisplayImageLaundryWidget extends StatelessWidget {
  DisplayImageLaundryWidget({
    super.key,
  });

  final LaundryController laundryController = Get.find<LaundryController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Obx(() {
            final data = laundryController.laundryDataById.value;
            if (data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Image.asset(
              data.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          }),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.close, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
