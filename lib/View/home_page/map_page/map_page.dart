import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thammasat/Controller/laundry_controller.dart';
import 'package:thammasat/Controller/position_controller.dart';

class MapPage extends StatelessWidget {
  MapPage({super.key});

  final PositionController positionController = Get.find<PositionController>();
  final LaundryController laundryController = Get.find<LaundryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => GoogleMap(
            initialCameraPosition: positionController.university,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            markers: laundryController.markers.toSet(),
            onMapCreated: (controller) {
              positionController.mapController = controller;
            },
          )),
    );
  }
}
