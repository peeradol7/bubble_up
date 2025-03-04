import 'package:cloud_firestore/cloud_firestore.dart';

class UserCollectionModel {
  final String userId;
  final String displayName;
  final String authMethod;
  late final String email;
  final String? password;
  final String? phoneNumber;
  final String role;
  final String? address;

  UserCollectionModel({
    required this.userId,
    required this.displayName,
    required this.authMethod,
    required this.email,
    this.password,
    this.phoneNumber,
    required this.role,
    this.address,
  });

  factory UserCollectionModel.fromFirestore(DocumentSnapshot doc) {
    final docData = doc.data();
    print("MODEL: ตรวจสอบ doc.data() - ${docData.toString()}");

    if (docData == null) {
      print("MODEL: doc.data() เป็น null");
      throw Exception("ข้อมูลเอกสารเป็น null");
    }

    try {
      Map<String, dynamic> data = docData as Map<String, dynamic>;

      UserCollectionModel model = UserCollectionModel(
        userId: data['userId'] ?? '',
        displayName: data['displayName'] ?? data['name'] ?? '',
        authMethod: data['authMethod'] ?? 'email',
        email: data['email'] ?? '',
        password: data.containsKey('password') ? data['password'] : null,
        phoneNumber: data['phoneNumber'] ?? '',
        role: data['role'] ?? '',
        address: data['address'] ?? '',
      );

      return model;
    } catch (e) {
      print(StackTrace.current);

      throw Exception("เกิดข้อผิดพลาดขณะแปลงข้อมูล: ${e.toString()}");
    }
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

  UserCollectionModel copyWith({
    String? userId,
    String? email,
    String? displayName,
    String? role,
    String? address,
    String? phoneNumber,
    String? authMethod,
  }) {
    return UserCollectionModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      authMethod: authMethod ?? this.authMethod,
    );
  }
}
