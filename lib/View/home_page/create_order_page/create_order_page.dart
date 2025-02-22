import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thammasat/Controller/laundry_controller.dart';
import 'package:thammasat/View/home_page/create_order_page/widget/add_order_widget.dart';
import 'package:thammasat/View/home_page/create_order_page/widget/confirm_order_button.dart';
import 'package:thammasat/View/home_page/create_order_page/widget/display_laundry_name.dart';

import 'widget/display_image_laundry_widget.dart';

class CreateOrderPage extends StatelessWidget {
  final String laundryId;
  CreateOrderPage({super.key, required this.laundryId});

  final LaundryController laundryController = Get.find<LaundryController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      laundryController.fetchLaundryById(laundryId);
    });

    return Scaffold(
      body: Obx(() {
        final data = laundryController.laundryDataById.value;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: DisplayImageLaundryWidget()),
              SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(
                  child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: DisplayLaundryName())),
              SliverToBoxAdapter(
                  child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: AddOrderWidget())),
              SliverToBoxAdapter(
                  child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: ConfirmOrderButton())),
            ],
          ),
        );
      }),
    );
  }
}
