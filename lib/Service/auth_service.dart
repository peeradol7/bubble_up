import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thammasat/Model/user_collection_model.dart';

import 'shared_preferenes_service.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static final String userCollection = 'users';

  Future<User?> loginWithGoogle() async {
    try {
      final isAvailable = await _googleSignIn.isSignedIn();
      print('Test Google Sign In available: $isAvailable');

      await _googleSignIn.signOut();
      await auth.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Sign in aborted by user');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDoc =
            await _firestore.collection(userCollection).doc(user.uid).get();

        if (userDoc.exists) {
          final existingData = userDoc.data() as Map<String, dynamic>;
          final updatedData = {
            'displayName':
                user.displayName ?? existingData['displayName'] ?? 'user',
            'email': user.email ?? existingData['email'],
            'authMethod': 'google',
            // รักษาข้อมูลเดิมที่มีอยู่
            'phoneNumber': existingData['phoneNumber'] ?? '',
            'address': existingData['address'] ?? '',
            'role': existingData['role'] ??
                'customer', // ถ้า role เป็น null ให้ใช้ customer
          };

          await _firestore
              .collection(userCollection)
              .doc(user.uid)
              .update(updatedData);

          final prefsService = await SharedPreferencesService.getInstance();
          await prefsService.saveUserData(
            user.uid,
            updatedData['email'],
            updatedData['displayName'],
            updatedData['role'],
            updatedData['address'],
            updatedData['phoneNumber'],
          );
        } else {
          final userData = UserCollectionModel(
            userId: user.uid,
            displayName: user.displayName ?? 'user',
            authMethod: 'google',
            phoneNumber: null,
            address: null,
            role: 'customer',
            email: user.email!,
          );

          await _firestore
              .collection(userCollection)
              .doc(user.uid)
              .set(userData.toMap());

          final prefsService = await SharedPreferencesService.getInstance();
          await prefsService.saveUserData(
            userData.userId,
            userData.email,
            userData.displayName,
            userData.role,
            userData.address ?? '',
            userData.phoneNumber ?? '',
          );

          print('Saved new user data to Firestore');
        }
      }

      return userCredential.user;
    } catch (e, stackTrace) {
      print('Detailed error: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<UserCollectionModel?> fetchUserDataByUserId(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(userCollection).doc(userId).get();

      if (doc.exists) {
        return UserCollectionModel.fromFirestore(doc);
      } else {
        print("User not found!");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<UserCollectionModel?> saveUserEmailPassword({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String role,
  }) async {
    try {
      var querySnapshot = await _firestore
          .collection(userCollection)
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception("อีเมลนี้ถูกใช้ไปแล้ว");
      }

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) {
        print('Error: User registration failed, user is null');
        return null;
      }

      await user.sendEmailVerification();

      UserCollectionModel userData = UserCollectionModel(
        userId: user.uid,
        authMethod: 'email',
        displayName: name,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        role: role,
        address: '',
      );

      await _firestore
          .collection(userCollection)
          .doc(user.uid)
          .set(userData.toMap());

      return userData;
    } catch (e) {
      print('Error during registration: $e');
      return null;
    }
  }

  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    try {
      String? userId = auth.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not logged in");
      }

      await _firestore
          .collection(userCollection)
          .doc(userId)
          .update(updatedData);
      print('User data updated successfully');

      final prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      String? name = prefs.getString('name');
      String? role = prefs.getString('role');
      String? address = prefs.getString('address');
      String? phoneNumber = prefs.getString('phoneNumber');

      await prefs.setString('email', updatedData['email'] ?? email ?? '');
      await prefs.setString('name', updatedData['name'] ?? name ?? '');
      await prefs.setString('role', updatedData['role'] ?? role ?? '');
      await prefs.setString('address', updatedData['address'] ?? address ?? '');
      await prefs.setString(
          'phoneNumber', updatedData['phoneNumber'] ?? phoneNumber ?? '');
    } catch (e) {
      throw Exception("Error updating user data: ${e.toString()}");
    }
  }

  Future<void> deleteAccount() async {
    try {
      final User? currentUser = auth.currentUser;
      if (currentUser == null) {
        throw Exception("ไม่พบข้อมูลผู้ใช้");
      }

      final String userId = currentUser.uid;

      await _firestore.collection(userCollection).doc(userId).delete();

      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
      }

      await currentUser.delete();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      print('ลบบัญชีผู้ใช้เรียบร้อยแล้ว');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'requires-recent-login':
          throw Exception(
              "กรุณาเข้าสู่ระบบใหม่อีกครั้งก่อนลบบัญชี เนื่องจากเวลาผ่านไปนานเกินไป");
        case 'user-not-found':
          throw Exception("ไม่พบบัญชีผู้ใช้");
        default:
          throw Exception("เกิดข้อผิดพลาดในการลบบัญชี: ${e.message}");
      }
    } catch (e) {
      throw Exception("เกิดข้อผิดพลาดในการลบบัญชี: $e");
    }
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }
}
