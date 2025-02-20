import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  final String userId;
  final String email;
  final String authMethod;
  final String password;
  final String phone_number;
  final String name;
  final String role;

  UsersModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.phone_number,
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
      phone_number: data['phone_number'],
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
      'phone_number': phone_number,
      'password': password,
      'authMethod': authMethod,
      'role': role,
    };
  }
}
