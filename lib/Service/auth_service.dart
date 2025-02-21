import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thammasat/Model/google_user_model.dart';
import 'package:thammasat/Model/usersmodel.dart';

import 'shared_preferenes_service.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static final String userCollection = 'users';

  Future<User?> loginWithGoogle() async {
    try {
      final isAvailable = await _googleSignIn.isSignedIn();
      print('Google Sign In available: $isAvailable');

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
        final userData = GoogleUserModel(
          userId: user.uid,
          displayName: user.displayName ?? 'user',
          authMethod: 'google',
          phoneNumber: '',
          address: '',
          role: '',
          email: user.email!,
        );

        final prefsService = await SharedPreferencesService.getInstance();
        await prefsService.saveUserData(
          userData.userId,
          userData.email,
          userData.displayName,
          userData.role,
          userData.address,
          userData.phoneNumber,
        );

        final userDoc =
            await _firestore.collection(userCollection).doc(user.uid).get();

        if (!userDoc.exists) {
          await _firestore
              .collection(userCollection)
              .doc(user.uid)
              .set(userData.toMap());
          print('Saved new user data to Firestore');
        } else {}
      }

      return userCredential.user;
    } catch (e, stackTrace) {
      print('Detailed error: $e');
      print('Stack trace: $stackTrace');

      return null;
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<User?> saveUserEmailPassword({
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

      UsersModel userData = UsersModel(
        userId: user.uid,
        authMethod: 'email',
        name: name,
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

      return user;
    } catch (e) {
      print('Error during registration: $e');
      return null;
    }
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }
}
