import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
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

  Future<void> fetchLaundryDataList() async {
    try {
      var data = await laundryService.getLaundries();
      laundryDataList.value = data;
      _updateMarkers();
    } catch (e) {
      print('Error fetching data :  $e');
    }
  }

  Future<void> fetchLaundryById(String id) async {
    try {
      LaundrysModel? data = await laundryService.getLaundryById(id);
      laundryDataById.value = data;
      calculatePriceForRider();
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

  void _updateMarkers() {
    markers.value = laundryDataList.map((laundry) {
      return Marker(
        markerId: MarkerId(laundry.laundryName),
        position: LatLng(laundry.latitude, laundry.longitude),
        infoWindow: InfoWindow(
          title: laundry.laundryName,
          snippet: 'คลิกเพื่อดูรายละเอียด',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    }).toList();
  }

  Future<Map<String, int>> calculatePriceForRider() async {
    final currentLocation = positionController.currentLatLng.value;
    final laundryLatitude = laundryDataById.value!.latitude;
    final laundryLongitude = laundryDataById.value!.longitude;

    double distanceInMeters = await Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      laundryLatitude,
      laundryLongitude,
    );

    double distanceInKilometers = distanceInMeters / 1000;

    int expressPrice = (distanceInKilometers * 15).round();
    int normalPrice = (distanceInKilometers * 7).round();

    deliveryPrices.value = {
      'express': expressPrice,
      'normal': normalPrice,
    };

    print("ส่งด่วน: ${deliveryPrices['express']} บาท");
    print("ส่งปกติ: ${deliveryPrices['normal']} บาท");

    return deliveryPrices;
  }
}
