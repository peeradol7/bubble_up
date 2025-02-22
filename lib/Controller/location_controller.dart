import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Service/location_service.dart';

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();

  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;
  final Rx<String?> searchType = Rx<String?>(null);
  final Rx<LatLng?> destinationLatLng = Rx<LatLng?>(null);
  final RxString destination = ''.obs;
  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchText.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Stream<QuerySnapshot> getLocationsStream() {
    return _locationService.getLocationsStream();
  }

  List<DocumentSnapshot> getFilteredLocations(QuerySnapshot snapshot) {
    return _locationService.filterLocations(
        snapshot, searchText.value, searchType.value);
  }

  void handleLocationSelection(Map<String, dynamic> doc, int index) {
    var selectedLocation = doc['laundryName'];

    destination.value = selectedLocation;
  }

  bool isValidLocation(Map<String, dynamic> doc) {
    return _locationService.validateLocationData(doc);
  }
}
