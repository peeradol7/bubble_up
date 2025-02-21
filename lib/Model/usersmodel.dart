import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  final String userId;
  final String email;
  final String authMethod;
  final String password;
  final String phoneNumber;
  final String name;
  final String role;

  UsersModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.password,
    required this.authMethod,
    required this.role,
  });

  factory UsersModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return UsersModel(
      userId: data['userId'],
      email: data['email'],
      name: data['name'],
      phoneNumber: data['phoneNumber'],
      password: data['password'],
      authMethod: data['authMethod'],
      role: data['role'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'password': password,
      'authMethod': authMethod,
      'role': role,
    };
  }
}
