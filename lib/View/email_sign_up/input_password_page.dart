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
  ) async {
    try {
      await authController.signInWithEmail(email, password, phoneNumber, name);
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
                    TextFormField(
                      onChanged: (value) {
                        authController.phoneNumber.value = value;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        hintText: "Enter your phone number",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) {
                        authController.name.value = value;
                      },
                      decoration: const InputDecoration(
                        labelText: "Name",
                        hintText: "Enter your name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) {
                        authController.password.value = value;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your password",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: passwordValidate,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) {
                        authController.confirmPassword.value = value;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Confirm your password",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: confirmPasswordValidate,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          String name = authController.name.value;
                          String phoneNumber = authController.phoneNumber.value;
                          String password = authController.password.value;
                          String email = authController.email.value;

                          saveUser(email, password, phoneNumber, name);

                          context.go(AppRoutes.homePage);
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
}
