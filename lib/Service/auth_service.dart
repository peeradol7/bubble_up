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

      final String? email = googleUser.email;

      if (email == null) {
        throw Exception('Google account does not have an email.');
      }

      // Sign in with credential first
      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Check if user already exists in Firestore
        final userDoc =
            await _firestore.collection(userCollection).doc(user.uid).get();

        if (!userDoc.exists) {
          // Only create a new record if user doesn't exist
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

          print('Saved new user data to Firestore');
        } else {
          print('Existing user logged in successfully');
        }

        final userData =
            await _firestore.collection(userCollection).doc(user.uid).get();

        if (userData.exists) {
          final userModel = UserCollectionModel.fromMap(userData.data()!);

          // Save to shared preferences
          final prefsService = await SharedPreferencesService.getInstance();
          await prefsService.saveUserData(
            userModel.userId,
            userModel.email,
            userModel.displayName,
            userModel.role,
            userModel.address ?? '',
            userModel.phoneNumber ?? '',
          );
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
      print('Attempting to create user with email: $email');

      var querySnapshot = await _firestore
          .collection(userCollection)
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('Email is already in use');
        throw Exception("อีเมลนี้ถูกใช้ไปแล้ว");
      }

      print('Creating user with Firebase Authentication...');
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print(
          'User created with Firebase Auth. UID: ${userCredential.user?.uid}');
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
      print('User data saved to Firestore successfully');

      return userData;
    } catch (e) {
      print('Error during registration: $e');
      print('Error stack trace: ${StackTrace.current}');
      throw e; // ส่งข้อผิดพลาดต่อเพื่อให้ดักจับในระดับที่สูงขึ้น
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
