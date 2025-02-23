import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/app_routes.dart';

import '../landing_page/sign_up_button.dart';

class SignUpDialog extends StatefulWidget {
  const SignUpDialog({super.key});

  @override
  State<SignUpDialog> createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<SignUpDialog> {
  final CustomButton btn = CustomButton();

  final AuthController authController = Get.find<AuthController>();

  Future<void> handleLogin(BuildContext context) async {
    try {
      await authController.loginController();

      await Future.delayed(Duration(milliseconds: 500));

      if (authController.userModel.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      } else {
        print('Login successful, navigating to selectServicePage');
        if (context.mounted) {
          context.go(AppRoutes.homePage);
        }
      }
    } catch (e) {
      print('Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 300,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.lightBlue,
                width: 8,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sign Un',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Select a login channel.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600],
                  ),
                ),
                const SizedBox(height: 20),
                btn.btnSignUp(
                  onPressed: () => {handleLogin(context)},
                  label: 'Continue with Google',
                  iconPath: 'assets/google.png',
                ),
                const SizedBox(height: 10),
                btn.btnSignUp(
                  onPressed: () => {
                    context.pop(),
                    context.push(AppRoutes.emailSignUp),
                  },
                  label: 'Continue with Email',
                  iconPath: 'assets/email.png',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
