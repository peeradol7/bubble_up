import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/app_routes.dart';

class EmailSignUp extends StatelessWidget {
  EmailSignUp({super.key});

  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());

  String? emailValidate(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  Future<void> _sendVerificationEmail(BuildContext context) async {
    try {
      String email = _emailController.text;
      if (email.isEmpty) {
        Get.snackbar('Error', 'Email cannot be empty');
        return;
      }
      authController.email.value = _emailController.text;
      print('email--- ${authController.email.value}');

      if (authController.email.value != null &&
          authController.email.value.isNotEmpty) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: '123456',
        );

        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await user.sendEmailVerification();
          Get.snackbar(
              'Email Verification', 'A verification email has been sent.');
          context.push(AppRoutes.inputPassword);
        } else {
          Get.snackbar('Error', 'Failed to get current user');
        }
      } else {
        Get.snackbar('Error', 'Email is null or empty');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send verification email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email"),
                validator: emailValidate,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _sendVerificationEmail(context);
                  }
                },
                child: Text("Send Verification Email"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
