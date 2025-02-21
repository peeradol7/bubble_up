import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleUserModel {
  final String userId;
  final String displayName;
  final String authMethod;
  final String email;
  final String phoneNumber;
  final String address;
  final String role;

  GoogleUserModel({
    required this.userId,
    required this.displayName,
    required this.authMethod,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.role,
  });
  factory GoogleUserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return GoogleUserModel(
      userId: data['userId'] ?? '',
      authMethod: data['authMethod'] ?? 'google',
      displayName: data['displayName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      role: data['role'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'displayName': displayName,
      'authMethod': authMethod,
      'phoneNumber': phoneNumber,
      'address': address,
      'role': role,
    };
  }
}
