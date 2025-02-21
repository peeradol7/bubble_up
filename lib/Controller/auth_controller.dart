import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:thammasat/Model/usersmodel.dart';
import 'package:thammasat/Service/%E0%B8%B5user_service.dart';
import 'package:thammasat/Service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  final UserService userService = UserService();
  var user = Rxn<User>();
  var userModel = Rxn<UsersModel>();
  var isLoading = false.obs;
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString name = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString confirmPassword = ''.obs;
  RxString role = ''.obs;
  var errorMessage = ''.obs;

  Future<void> fetchUserData(String email, String password) async {
    try {
      UsersModel user = await userService.getUserData(email, password);
      userModel.value = user;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> signInWithEmail(
    String email,
    String password,
    String phoneNumber,
    String name,
    String role,
  ) async {
    try {
      this.email.value = email;
      this.password.value = password;
      this.name.value = name;
      this.phoneNumber.value = phoneNumber;

      User? user = await authService.saveUserEmailPassword(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        role: role,
      );

      if (user != null) {
        Get.snackbar('Success', 'User registered successfully');
      } else {
        Get.snackbar('Error', 'User registration failed');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  Future<void> loginController() async {
    try {
      isLoading(true);
      await googleLogin();
    } catch (e) {
      print('Exception : $e');
    }
  }

  Future<void> googleLogin() async {
    final result = await authService.loginWithGoogle();
    if (result != null) {
      user.value = result;
    } else {
      print('Google login failed: user is null');
    }
  }

  Future<void> logoutController() async {
    try {
      await authService.logout();
      user.value = null;
    } catch (e) {
      Get.snackbar('Error', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
