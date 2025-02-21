import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PositionController extends GetxController {
  RxString district = ''.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

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

  CameraPosition university = CameraPosition(
    target: LatLng(14.0657714366218, 100.60441486351333),
    zoom: 16,
  );
  @override
  void onClose() {
    stopTracking();
    super.onClose();
  }
}
