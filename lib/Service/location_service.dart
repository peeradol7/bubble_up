import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  static const String launDryName = 'laundryName';
  static const String type = 'type';

  final CollectionReference _locationsRef =
      FirebaseFirestore.instance.collection('laundryStore');

  Stream<QuerySnapshot> getLocationsStream() {
    return _locationsRef.snapshots();
  }

  List<DocumentSnapshot> filterLocations(
      QuerySnapshot snapshot, String searchText, String? searchType) {
    return snapshot.docs.where((doc) {
      try {
        var data = doc.data() as Map<String, dynamic>?;
        if (data == null ||
            !data.containsKey(launDryName) ||
            !data.containsKey(type)) {
          return false;
        }

        String locationName = data[launDryName].toString().toLowerCase();
        String locationType = data[type].toString().toLowerCase();
        String searchQuery = searchText.toLowerCase().trim();

        if (searchType != null) {
          return locationType == searchType;
        } else {
          return locationName.contains(searchQuery);
        }
      } catch (e) {
        return false;
      }
    }).toList();
  }

  bool validateLocationData(Map<String, dynamic> doc) {
    return doc.containsKey(launDryName) &&
        doc.containsKey('latitude') &&
        doc.containsKey('longitude') &&
        doc.containsKey(type);
  }
}
