import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:thammasat/Model/usersmodel.dart';
import 'package:thammasat/Service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  var userModel = <UsersModel>[].obs;

  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString name = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString confirmPassword = ''.obs;

  Future<void> signInWithEmail(
    String email,
    String password,
    String phoneNumber,
    String name,
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
}
