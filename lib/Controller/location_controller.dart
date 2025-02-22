import 'package:get/get.dart';
import 'package:thammasat/Service/laundry_service.dart';

class LocationController extends GetxController {
  final LaundryService _locationService = LaundryService();

  var locations = <Map<String, dynamic>>[].obs;

  var searchText = ''.obs;

  var searchType = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _loadLocations();
  }

  void _loadLocations() {
    _locationService.getLocationsStream().listen((data) {
      locations.value = data;
    });
  }

  List<Map<String, dynamic>> get filteredLocations {
    if (searchText.isEmpty && searchType.value == null) return locations;

    return locations.where((doc) {
      if (!doc.containsKey('laundryName') || !doc.containsKey('type')) {
        return false;
      }

      String locationName = doc['laundryName'].toString().toLowerCase();
      String locationType = doc['type'].toString().toLowerCase();
      String searchQuery = searchText.value.toLowerCase().trim();

      if (searchType.value != null) {
        return locationType == searchType.value;
      } else {
        return locationName.contains(searchQuery);
      }
    }).toList();
  }
}
