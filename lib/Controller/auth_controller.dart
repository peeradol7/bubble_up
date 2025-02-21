import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:thammasat/Model/usersmodel.dart';
import 'package:thammasat/Service/%E0%B8%B5user_service.dart';
import 'package:thammasat/Service/auth_service.dart';

import '../Service/shared_preferenes_service.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  final UserService userService = UserService();

  var user = Rxn<User>();
  var userModel = Rxn<UserCollectionModel>();
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
      UserCollectionModel user =
          await userService.emailLoginService(email, password);
      userModel.value = user;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    try {
      await authService.updateUserData(updatedData);

      userModel.value = UserCollectionModel(
        userId: userModel.value?.userId ?? '',
        email: updatedData['email'] ?? userModel.value?.email ?? '',
        displayName: updatedData['name'] ?? userModel.value?.displayName ?? '',
        role: updatedData['role'] ?? userModel.value?.role ?? '',
        address: updatedData['address'] ?? userModel.value?.address ?? '',
        phoneNumber:
            updatedData['phoneNumber'] ?? userModel.value?.phoneNumber ?? '',
        authMethod: '',
      );

      update(); // อัปเดต UI
      print("User data updated in GetX");
    } catch (e) {
      print("Error updating user data in GetX: $e");
    }
  }

  Future<bool> loadUserDataInitState() async {
    final prefsService = await SharedPreferencesService.getInstance();
    Map<String, String?> userData = prefsService.getUserData();

    return userData.isNotEmpty;
  }

  Future<Map<String, String>?> loadUserData() async {
    final prefsService = await SharedPreferencesService.getInstance();
    Map<String, String?> userData = prefsService.getUserData();

    if (userData.isNotEmpty) {
      final cleanedUserData = userData.map((key, value) {
        return MapEntry(key, value ?? '');
      });

      return cleanedUserData;
    }
    return null;
  }

  Future<void> signUpWithEmail(
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
      userModel.value = null;
      final prefsService = await SharedPreferencesService.getInstance();
      prefsService.clearUserData();
    } catch (e) {
      Get.snackbar('Error', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
