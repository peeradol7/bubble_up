import 'package:get/get.dart';
import 'package:thammasat/Model/usersmodel.dart';
import 'package:thammasat/Service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();

  var userModel = <UsersModel>[].obs;

  Future<void> signInWithEmail(
    String email,
    String password,
    String phonNumber,
    String name,
  ) async {
    try {} catch (e) {}
  }
}
