import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  Future<String> getCurrentLocationAndAddress() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return "Permission denied";
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;

      return placemark.locality ?? "Unknown Thoroughfare";
    } else {
      return "No address found";
    }
  }

  Stream<LatLng> trackCurrentLatLng() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
      timeLimit: Duration(seconds: 5),
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (Position position) => LatLng(position.latitude, position.longitude),
    );
  }
}
