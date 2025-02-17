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

        // final usersModel = Usersmodel(
        //   userId: user.uid,
        //   authMethod: 'Google',
        //   name: user.displayName ?? 'Google User',
        //   email: user.email ?? 'email',
        //   phone_number: user.phoneNumber ?? 'phoneNumber',
        //   password: user.password,
        // );
      }

      return user;
    } catch (e) {
      throw Exception('Error ${e.toString()}');
    }
  }

  Future<void> save(Usersmodel user) async {
    await _firestore.collection(userCollection).doc().set(user.toMap());
  }
}
