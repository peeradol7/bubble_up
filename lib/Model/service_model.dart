import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String serviceName;
  final String imagePath;

  ServiceModel({
    required this.serviceName,
    required this.imagePath,
  });

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ServiceModel(
      serviceName: data['serviceName'] ?? '',
      imagePath: data['imagePath'] ?? '',
    );
  }
}
