import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thammasat/Model/usersmodel.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static final String userCollection = 'users';

  Future<User?> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in aborted');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        print('Google login successful: ${user.uid}');
      }

      return user;
    } catch (e) {
      throw Exception('Error ${e.toString()}');
    }
  }

  Future<void> save(UsersModel user) async {
    await _firestore.collection(userCollection).doc().set(user.toMap());
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

  Stream<User?> get userStream => auth.authStateChanges();
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

      if (user != null) {
        await user.sendEmailVerification();

        UsersModel userData = UsersModel(
          userId: user.uid,
          authMethod: 'email',
          name: name,
          phone_number: phoneNumber,
          password: password,
          email: email,
        );

        await save(userData);

        return user;
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
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
}
