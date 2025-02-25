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
    print("=== MODEL: UserCollectionModel.fromFirestore เริ่มทำงาน ===");
    print("MODEL: ตรวจสอบ doc - ${doc.toString()}");
    print("MODEL: ตรวจสอบ doc.exists - ${doc.exists}");
    print("MODEL: ตรวจสอบ doc.id - ${doc.id}");

    final docData = doc.data();
    print("MODEL: ตรวจสอบ doc.data() - ${docData.toString()}");

    if (docData == null) {
      print("MODEL: doc.data() เป็น null");
      throw Exception("ข้อมูลเอกสารเป็น null");
    }

    try {
      print("MODEL: กำลังแปลง doc.data() เป็น Map<String, dynamic>");
      Map<String, dynamic> data = docData as Map<String, dynamic>;

      print("MODEL: แปลงข้อมูลสำเร็จ");
      print("MODEL: ตรวจสอบฟิลด์ userId - ${data['userId']}");
      print("MODEL: ตรวจสอบฟิลด์ displayName - ${data['displayName']}");
      print("MODEL: ตรวจสอบฟิลด์ name - ${data['name']}");
      print("MODEL: ตรวจสอบฟิลด์ authMethod - ${data['authMethod']}");
      print("MODEL: ตรวจสอบฟิลด์ email - ${data['email']}");
      print("MODEL: ตรวจสอบฟิลด์ role - ${data['role']}");
      print("MODEL: ตรวจสอบฟิลด์ address - ${data['address']}");
      print("MODEL: ตรวจสอบฟิลด์ phoneNumber - ${data['phoneNumber']}");

      print("MODEL: กำลังสร้าง UserCollectionModel");
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

      print("MODEL: สร้าง UserCollectionModel สำเร็จ");
      print("MODEL: ตรวจสอบค่า userId - ${model.userId}");
      print("MODEL: ตรวจสอบค่า email - ${model.email}");
      print("MODEL: ตรวจสอบค่า role - ${model.role}");

      print("=== MODEL: UserCollectionModel.fromFirestore ทำงานเสร็จสิ้น ===");
      return model;
    } catch (e) {
      print("MODEL: เกิดข้อผิดพลาดขณะแปลงข้อมูล: ${e.toString()}");
      print("MODEL: สแตคเทรซ:");
      print(StackTrace.current);

      print("=== MODEL: UserCollectionModel.fromFirestore เกิดข้อผิดพลาด ===");
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
