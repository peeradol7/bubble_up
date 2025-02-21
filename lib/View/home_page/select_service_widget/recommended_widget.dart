import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/laundry_controller.dart';

class RecommendedWidget extends StatelessWidget {
  const RecommendedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final LaundryController laundryController = Get.put(LaundryController());
    laundryController.fetchLaundryDataList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'ร้านซักรีดที่คุณอาจสนใจ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(
          () {
            if (laundryController.laundryDataList.isEmpty) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: laundryController.laundryDataList.map((laundry) {
                  return Container(
                    width: 150,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            laundry.image,
                            width: 120,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          laundry.laundryName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
