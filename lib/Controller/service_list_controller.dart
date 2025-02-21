import 'package:get/get.dart';
import 'package:thammasat/Model/service_model.dart';
import 'package:thammasat/Service/laundry_service.dart';

class ServiceListController extends GetxController {
  final LaundryService laundryService = LaundryService();
  var laundryDataById = Rxn<ServiceModel>();
  var laundryDataList = <ServiceModel>[].obs;
  @override
  void onInit() {
    fetchServiceListData();
    super.onInit();
  }

  Future<void> fetchServiceListData() async {
    try {
      final data = await laundryService.displayServiceList();

      laundryDataList.value = data;
    } catch (e) {
      throw Exception(e);
    }
  }
}
