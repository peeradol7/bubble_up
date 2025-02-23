import 'package:get/get.dart';
import 'package:thammasat/Model/user_collection_model.dart';
import 'package:thammasat/Service/%E0%B8%B5user_service.dart';
import 'package:thammasat/Service/auth_service.dart';

import '../Service/shared_preferenes_service.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  final UserService userService = UserService();

  var userModel = Rxn<UserCollectionModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final phoneNumber = ''.obs;
  final name = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final role = ''.obs;
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

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
        displayName:
            updatedData['displayName'] ?? userModel.value?.displayName ?? '',
        role: updatedData['role'] ?? userModel.value?.role ?? '',
        address: updatedData['address'] ?? userModel.value?.address ?? '',
        phoneNumber:
            updatedData['phoneNumber'] ?? userModel.value?.phoneNumber ?? '',
        authMethod: '',
      );

      update();
      print("User data updated in GetX");
    } catch (e) {
      print("Error updating user data in GetX: $e");
    }
  }

  Future<bool> loadUserDataInitState() async {
    final prefsService = await SharedPreferencesService.getInstance();
    Map<String, String?> userData = prefsService.getUserData();
    if (userData.isNotEmpty) {
      return true;
    }
    return false;
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
      UserCollectionModel? user = await authService.saveUserEmailPassword(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        role: role,
      );

      if (user != null) {
        userModel.value = user;
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
    } finally {
      isLoading(false);
    }
  }

  Future<void> googleLogin() async {
    final result = await authService.loginWithGoogle();
    if (result != null) {
      final userData = await authService.fetchUserDataByUserId(result.uid);
      userModel.value = userData;
    } else {
      print('Google login failed: user is null');
    }
  }

  Future<void> fetchDataById(String userId) async {
    try {
      final data = await authService.fetchUserDataByUserId(userId);
      userModel.value = data;
    } catch (e) {
      print(e);
    }
  }

  Future<void> logoutController() async {
    try {
      await authService.logout();
      userModel.value = null;
      final prefsService = await SharedPreferencesService.getInstance();
      prefsService.clearUserData();
    } catch (e) {
      Get.snackbar('Error', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteAccountController() async {
    try {
      await authService.deleteAccount();
      userModel.value = null;
      Get.snackbar("Success", "บัญชีผู้ใช้ถูกลบเรียบร้อยแล้ว");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> editAddress(String userId, String address) async {
    try {
      await userService.editAddress(userId, address);
      if (userModel.value != null) {
        userModel.value = userModel.value!.copyWith(address: address);
      }
    } catch (e) {
      print(e);
    }
  }
}
