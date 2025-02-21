import 'package:cloud_firestore/cloud_firestore.dart';

class UserCollectionModel {
  final String userId;
  final String displayName;
  final String authMethod;
  final String email;
  final String? password;
  final String phoneNumber;
  final String role;
  final String address;

  UserCollectionModel({
    required this.userId,
    required this.displayName,
    required this.authMethod,
    required this.email,
    this.password,
    required this.phoneNumber,
    required this.role,
    required this.address,
  });

  factory UserCollectionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserCollectionModel(
      userId: data['userId'] ?? '',
      displayName: data['displayName'] ?? data['name'] ?? '',
      authMethod: data['authMethod'] ?? 'email',
      email: data['email'] ?? '',
      password: data.containsKey('password')
          ? data['password']
          : null, // อนุญาตให้ null ได้
      phoneNumber: data['phoneNumber'] ?? '',
      role: data['role'] ?? '',
      address: data['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'displayName': displayName,
      'authMethod': authMethod,
      'email': email,
      if (password != null) 'password': password,
      'phoneNumber': phoneNumber,
      'role': role,
      'address': address,
    };
  }
}
