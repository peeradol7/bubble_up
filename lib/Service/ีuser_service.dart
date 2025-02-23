import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/user_collection_model.dart';
import 'shared_preferenes_service.dart';

class UserService {
  static const String usersCollection = 'users';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> addRole(String userId, String role) async {
    try {
      DocumentReference userDocRef =
          _firestore.collection(usersCollection).doc(userId);

      await userDocRef.update({
        'role': role,
      });

      print('Role added successfully!');
    } catch (e) {
      print('Error adding role: $e');
      throw Exception('Error adding role');
    }
  }

  Future<void> editAddress(String userId, String address) async {
    try {
      DocumentReference userDocRef =
          _firestore.collection(usersCollection).doc(userId);

      await userDocRef.update({
        'address': address,
      });

      print('address added successfully!');
    } catch (e) {
      print('Error adding address: $e');
      throw Exception('Error adding role');
    }
  }

  Future<UserCollectionModel> emailLoginService(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) {
        throw Exception("ไม่พบบัญชีผู้ใช้");
      }

      if (!user.emailVerified) {
        throw Exception("กรุณายืนยันอีเมลก่อนเข้าสู่ระบบ");
      }

      DocumentSnapshot userDoc =
          await _firestore.collection(usersCollection).doc(user.uid).get();

      if (!userDoc.exists) {
        throw Exception("ไม่พบข้อมูลผู้ใช้ในระบบ");
      }

      UserCollectionModel userData = UserCollectionModel.fromFirestore(userDoc);

      final prefsService = await SharedPreferencesService.getInstance();
      await prefsService.saveUserData(
        userData.userId,
        userData.email,
        userData.displayName,
        userData.role,
        userData.address,
        userData.phoneNumber,
      );

      return userData;
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาด: ${e.toString()}");
    }
  }
}
