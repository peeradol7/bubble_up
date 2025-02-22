import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Service/map_service.dart';

class PositionController extends GetxController {
  RxString district = ''.obs;
  RxDouble latitude = 0.0.obs;
  GoogleMapController? mapController;
  RxDouble longitude = 0.0.obs;
  Rx<LatLng> currentLatLng = Rx<LatLng>(LatLng(0.0, 0.0));

  final MapService mapService = MapService();

  CameraPosition university = CameraPosition(
    target: LatLng(14.0657714366218, 100.60441486351333),
    zoom: 16,
  );
  StreamSubscription<Position>? _positionStreamSubscription;

  void startTracking() {
    _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 5,
    )).listen((Position position) async {
      latitude.value = position.latitude;
      longitude.value = position.longitude;
    });
  }

  void stopTracking() {
    _positionStreamSubscription?.cancel();
  }

  Future<void> fetchDistrict() async {
    try {
      fetchLatLngData();
      var result = await mapService.getCurrentLocationAndAddress();
      district.value = result;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchLatLngData() async {
    try {
      final data = await mapService.getCurrentLatLng();
      currentLatLng.value = data;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void onClose() {
    stopTracking();
    super.onClose();
  }
}
