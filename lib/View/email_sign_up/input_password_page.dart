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

  String errorMessage = '';

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

  void saveUser() async {
    try {
      if (authController.role.value.isEmpty) {
        Get.snackbar(
          'Error',
          'Please select a role',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          borderRadius: 10,
        );
        return;
      }

      await authController.signUpWithEmail(
        authController.email.value,
        authController.password.value,
        authController.phoneNumber.value,
        authController.name.value,
        authController.role.value,
      );

      Get.snackbar(
        'Success',
        'Check your email',
        backgroundColor: const Color(0xFF01B9E4),
        colorText: Colors.white,
        borderRadius: 10,
      );

      context.go(AppRoutes.landingPage);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Error',
          e.toString(),
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          borderRadius: 10,
        );
      });
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
        prefixIcon: Icon(icon, color: const Color(0xFF01B9E4)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF01B9E4)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
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
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF01B9E4)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
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
                  const Text(
                    "Almost There!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF01B9E4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Please fill in your details to complete registration",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 20),
                  buildTextField(
                    label: "Name",
                    hint: "Enter your name",
                    icon: Icons.person,
                    onChanged: (value) => authController.name.value = value,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your name'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    label: "Password",
                    hint: "Enter your password",
                    icon: Icons.lock,
                    obscureText: true,
                    onChanged: (value) => authController.password.value = value,
                    validator: passwordValidate,
                  ),
                  const SizedBox(height: 20),
                  buildTextField(
                    label: "Confirm Password",
                    hint: "Confirm your password",
                    icon: Icons.lock,
                    obscureText: true,
                    onChanged: (value) =>
                        authController.confirmPassword.value = value,
                    validator: confirmPasswordValidate,
                  ),
                  const SizedBox(height: 30),
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
                            title: const Text("Customer"),
                            value: "Customer",
                            groupValue: authController.role.value,
                            activeColor: const Color(0xFF01B9E4),
                            onChanged: (value) {
                              authController.role.value = value!;
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text("Rider"),
                            value: "Rider",
                            groupValue: authController.role.value,
                            activeColor: const Color(0xFF01B9E4),
                            onChanged: (value) {
                              authController.role.value = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        final email = authController.email.value;
                        final password = authController.password.value;
                        if (email != null &&
                            email.isNotEmpty &&
                            password != null &&
                            password.isNotEmpty) {
                          saveUser();
                        } else {
                          setState(() {
                            errorMessage = "Please enter email and password";
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF01B9E4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
