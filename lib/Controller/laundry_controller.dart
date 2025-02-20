import 'package:get/get.dart';
import 'package:thammasat/Model/laundrys_model.dart';
import 'package:thammasat/Service/laundry_service.dart';

class LaundryController extends GetxController {
  final LaundryService laundryService = LaundryService();

  var laundryDataById = Rxn<LaundrysModel>();
  var laundryDataList = <LaundrysModel>[].obs;

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
    } catch (e) {
      print("Error fetching laundry by ID: $e");
    }
  }
}
