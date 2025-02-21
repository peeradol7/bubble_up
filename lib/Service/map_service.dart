import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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

      // คืนค่า Thoroughfare (ถนน)
      print("Thoroughfare: ${placemark.locality}");

      return placemark.locality ?? "Unknown Thoroughfare";
    } else {
      return "No address found";
    }
  }
}
