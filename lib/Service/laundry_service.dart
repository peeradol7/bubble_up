import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thammasat/Model/service_model.dart';

import '../Model/laundrys_model.dart';

class LaundryService {
  static const String laundry = 'laundryStore';
  static const String serviceList = 'servicelist';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ServiceModel>> displayServiceList() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(serviceList).get();

      return snapshot.docs
          .map((doc) => ServiceModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching serviceList: $e');
    }
  }

  Future<List<LaundrysModel>> getLaundries() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(laundry).get();

      return snapshot.docs
          .map((doc) => LaundrysModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching laundries: $e');
    }
  }

  Future<LaundrysModel?> getLaundryById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(laundry).doc(id).get();
      if (doc.exists) {
        return LaundrysModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching laundry by ID: $e');
    }
  }
}
