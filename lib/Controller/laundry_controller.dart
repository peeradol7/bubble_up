import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thammasat/Model/laundrys_model.dart';
import 'package:thammasat/Service/laundry_service.dart';

class LaundryController extends GetxController {
  final LaundryService laundryService = LaundryService();

  var laundryDataById = Rxn<LaundrysModel>();
  var laundryDataList = <LaundrysModel>[].obs;
  var markers = <Marker>[].obs;
  @override
  void onInit() {
    super.onInit();
  }

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
}
