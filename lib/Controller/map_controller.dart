import 'package:get/get.dart';
import 'package:thammasat/Service/map_service.dart';

class MapController extends GetxController {
  final MapService mapService = MapService();
  var district = ''.obs;

  Future<void> fetchDistrict() async {
    try {
      var result = await mapService.getCurrentLocationAndAddress();

      district.value = result;
    } catch (e) {
      throw Exception(e);
    }
  }
}
