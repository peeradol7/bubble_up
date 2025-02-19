import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thammasat/Model/google_user_model.dart';
import 'package:thammasat/Model/usersmodel.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static final String userCollection = 'users';

  Future<User?> loginWithGoogle() async {
    try {
      print('Starting Google Sign In process...');

      final isAvailable = await _googleSignIn.isSignedIn();
      print('Google Sign In available: $isAvailable');

      await _googleSignIn.signOut();
      await auth.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Sign in aborted by user');
        return null;
      }

      print('Google Sign In successful: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('Got authentication tokens');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // สร้าง user model
        final userData = GoogleUserModel(
          userId: user.uid,
          displayName: user.displayName ?? 'user',
          authMethod: 'google',
          phoneNumber: '',
          address: '',
        );

        final userDoc =
            await _firestore.collection(userCollection).doc(user.uid).get();

        if (!userDoc.exists) {
          await _firestore
              .collection(userCollection)
              .doc(user.uid)
              .set(userData.toMap());
          print('Saved new user data to Firestore');
        } else {
          print('User data already exists in Firestore');
        }
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
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) {
        print('Error: User registration failed, user is null');
        return null;
      }

      UsersModel userData = UsersModel(
        userId: user.uid,
        authMethod: 'email',
        name: name,
        phone_number: phoneNumber,
        email: email,
        password: password,
      );

      // Log ข้อมูลที่กำลังบันทึก

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

  Future<bool> isEmailVerified() async {
    User? user = auth.currentUser;
    if (user != null) {
      await user.reload();
      return user.emailVerified;
    }
    return false;
  }

  Future<void> signOutIfNotVerified() async {
    if (!await isEmailVerified()) {
      await auth.signOut();
    }
  }

  Future<void> checkEmailVerified(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    await user.reload();

    if (user.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your email is verified!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please verify your email first.')),
      );
    }
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }
}
