import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/View/home_page/widget/service_list_widget.dart';
import 'package:thammasat/app_routes.dart';

import '../../../Controller/service_list_controller.dart';
import 'location_reslut_list_widget.dart';

class DisplayServiceWidget extends StatelessWidget {
  const DisplayServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceListController serviceController =
        Get.find<ServiceListController>();
    final ServiceListWidget serviceListWidget = ServiceListWidget();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'บริการของเรา',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (serviceController.laundryDataList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: serviceController.laundryDataList.length,
                  itemBuilder: (context, index) {
                    final service = serviceController.laundryDataList[index];

                    return serviceListWidget.buildServiceItem(
                      service.serviceName,
                      service.imagePath,
                      () {
                        final path = AppRoutes.displayTypeLaundryPage;
                        final type = service.serviceName;
                        context.push('$path/$type');
                      },
                    );
                  },
                );
              }),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LocationResultListWidget(),
          ),
        ],
      ),
    );
  }
}
