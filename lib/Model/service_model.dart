import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String serviceName;
  final String servicePic;

  ServiceModel({
    required this.serviceName,
    required this.servicePic,
  });

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    return ServiceModel(
      serviceName: 'serviceName',
      servicePic: 'servicePic',
    );
  }
}
