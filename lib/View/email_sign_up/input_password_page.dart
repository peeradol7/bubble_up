import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/auth_controller.dart';

import '../../app_routes.dart';

class InputPasswordPage extends StatefulWidget {
  const InputPasswordPage({
    super.key,
  });

  @override
  State<InputPasswordPage> createState() => _InputPasswordPageState();
}

class _InputPasswordPageState extends State<InputPasswordPage> {
  final AuthController authController = Get.put(AuthController());
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

  void saveUser(
    String email,
    String password,
    String phoneNumber,
    String name,
    String role,
  ) async {
    try {
      await authController.signInWithEmail(
          email, password, phoneNumber, name, role);
      Get.snackbar('Success', 'Check your email');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Data'),
        backgroundColor: Colors.blue[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
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
                      onChanged: (value) =>
                          authController.password.value = value,
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
                    const SizedBox(height: 20),
                    Obx(
                      () => Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text("Customer"),
                            value: "Customer",
                            groupValue: authController.role.value,
                            onChanged: (value) {
                              authController.role.value = value!;
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text("Rider"),
                            value: "Rider",
                            groupValue: authController.role.value,
                            onChanged: (value) {
                              authController.role.value = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
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
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        hintText: hint,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }
}
