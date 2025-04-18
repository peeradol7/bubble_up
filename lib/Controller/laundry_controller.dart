import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thammasat/Controller/position_controller.dart';
import 'package:thammasat/Model/laundrys_model.dart';
import 'package:thammasat/Service/laundry_service.dart';
import 'package:thammasat/Service/map_service.dart';

class LaundryController extends GetxController {
  final LaundryService laundryService = LaundryService();
  final MapService mapService = MapService();
  final PositionController positionController = Get.find<PositionController>();

  var laundryDataById = Rxn<LaundrysModel>();

  var laundryDataList = <LaundrysModel>[].obs;

  var markers = <Marker>[].obs;
  var price = ''.obs;
  var deliveryPrices = <String, int>{}.obs;
  var deliveryType = ''.obs;
  var totalPrice = 0.obs;
  var paymentMethod = 'เงินสด'.obs;
  var status = 'pending'.obs;
  var laundryLatLng = Rxn<LatLng>();
  var laundryType = <LaundrysModel>[].obs;
  final isLoading = true.obs;
  void clearValue() {
    price.value = '';
    deliveryType.value = '';
    paymentMethod.value = '';
    totalPrice.value = 0;
  }

  Future<void> fetchLaundriesByType(String type) async {
    try {
      isLoading.value = true;
      final data = await laundryService.getLaundriesByType(type);
      laundryType.value = data;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLaundryDataList() async {
    try {
      var data = await laundryService.getLaundries();

      laundryDataList.value = data;
    } catch (e) {
      print('Error fetching data :  $e');
    }
  }

  Future<void> fetchLaundryById(String id) async {
    try {
      LaundrysModel? data = await laundryService.getLaundryById(id);

      laundryDataById.value = data;

      laundryLatLng.value = LatLng(
          laundryDataById.value!.latitude, laundryDataById.value!.longitude);
      await calculatePriceForRider();
    } catch (e) {
      print("Error fetching laundry by ID: $e");
    }
  }

  List<Map<String, dynamic>> getLaundryLocations() {
    return laundryDataList.map((laundry) {
      return {
        'latitude': laundry.latitude,
        'longitude': laundry.longitude,
        'launDry': laundry.laundryName,
      };
    }).toList();
  }

  void updateMarkers(BuildContext context) {
    markers.value = laundryDataList.map((laundry) {
      return Marker(
        markerId: MarkerId(laundry.laundryName),
        position: LatLng(laundry.latitude, laundry.longitude),
        infoWindow: InfoWindow(
          title: laundry.laundryName,
          snippet: 'คลิกเพื่อดูรายละเอียด',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        onTap: () {
          final laundryPath = '/create-order/${laundry.laundryId}';
          context.push(laundryPath);
          fetchLaundryById(laundry.laundryId);
        },
      );
    }).toList();
  }

  Future<Map<String, int>> calculatePriceForRider() async {
    final currentLocation = await positionController.currentLatLng.value;
    final laundryData = laundryDataById.value;

    if (currentLocation == null || laundryData == null) {
      deliveryPrices.value = {
        'express': 50,
        'normal': 30,
      };
      return deliveryPrices;
    }

    final laundryLatitude = laundryData.latitude;
    final laundryLongitude = laundryData.longitude;

    if (laundryLatitude == null || laundryLongitude == null) {
      deliveryPrices.value = {
        'express': 50,
        'normal': 30,
      };
      return deliveryPrices;
    }

    try {
      double distanceInMeters = await Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        laundryLatitude,
        laundryLongitude,
      );

      double distanceInKilometers = distanceInMeters / 1000;

      int expressPrice = (distanceInKilometers * 15).round();
      int normalPrice = (distanceInKilometers * 7).round();

      if (expressPrice == 0) expressPrice = 50;
      if (normalPrice == 0) normalPrice = 30;

      deliveryPrices.value = {
        'express': expressPrice,
        'normal': normalPrice,
      };
    } catch (e) {
      deliveryPrices.value = {
        'express': 50,
        'normal': 30,
      };
    }

    return deliveryPrices;
  }
}
