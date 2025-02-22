import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/auth_controller.dart';

import '../../app_routes.dart';

class InputPasswordPage extends StatefulWidget {
  const InputPasswordPage({super.key});

  @override
  State<InputPasswordPage> createState() => _InputPasswordPageState();
}

class _InputPasswordPageState extends State<InputPasswordPage> {
  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? passwordValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? confirmPasswordValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != authController.password.value) {
      return 'Passwords do not match';
    }
    return null;
  }

  void saveUser(String email, String password, String phoneNumber, String name,
      String role) async {
    try {
      await authController.signUpWithEmail(
          email, password, phoneNumber, name, role);
      Get.snackbar(
        'Success',
        'Check your email',
        backgroundColor: Color(0xFF01B9E4),
        colorText: Colors.white,
        borderRadius: 10,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        borderRadius: 10,
      );
    }
  }

  Widget buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        hintText: hint,
        prefixIcon: Icon(icon, color: Color(0xFF01B9E4)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF01B9E4)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF01B9E4)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Complete Profile',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Almost There!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF01B9E4),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Please fill in your details to complete registration",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 30),
                  buildTextField(
                    label: "Phone Number",
                    hint: "Enter your phone number",
                    icon: Icons.phone,
                    onChanged: (value) =>
                        authController.phoneNumber.value = value,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your phone number'
                        : null,
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    label: "Name",
                    hint: "Enter your name",
                    icon: Icons.person,
                    onChanged: (value) => authController.name.value = value,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your name'
                        : null,
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    label: "Password",
                    hint: "Enter your password",
                    icon: Icons.lock,
                    obscureText: true,
                    onChanged: (value) => authController.password.value = value,
                    validator: passwordValidate,
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    label: "Confirm Password",
                    hint: "Confirm your password",
                    icon: Icons.lock,
                    obscureText: true,
                    onChanged: (value) =>
                        authController.confirmPassword.value = value,
                    validator: confirmPasswordValidate,
                  ),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                      color: Colors.grey[50],
                    ),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 12),
                            child: Text(
                              "Select Role",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ),
                          RadioListTile<String>(
                            title: Text("Customer"),
                            value: "Customer",
                            groupValue: authController.role.value,
                            activeColor: Color(0xFF01B9E4),
                            onChanged: (value) {
                              authController.role.value = value!;
                            },
                          ),
                          RadioListTile<String>(
                            title: Text("Rider"),
                            value: "Rider",
                            groupValue: authController.role.value,
                            activeColor: Color(0xFF01B9E4),
                            onChanged: (value) {
                              authController.role.value = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          saveUser(
                            authController.email.value,
                            authController.password.value,
                            authController.phoneNumber.value,
                            authController.name.value,
                            authController.role.value,
                          );
                          context.go(AppRoutes.landingPage);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF01B9E4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
