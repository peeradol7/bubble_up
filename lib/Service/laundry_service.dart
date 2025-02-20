import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/laundrys_model.dart';

class LaundryService {
  static const String laundry = 'laundryStore';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
