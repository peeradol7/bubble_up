import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/app_routes.dart';

import 'widget/sign_up_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final CustomButton btn = CustomButton();

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
              color: Colors.white,
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
                  'Sign In',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600],
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
                  onPressed: () => {
                    print('Login'),
                  },
                  label: 'Continue with Google',
                  iconPath: 'assets/google.png',
                ),
                const SizedBox(height: 10),
                btn.btnSignUp(
                  onPressed: () => {
                    context.go(
                      AppRoutes.emailSignUp,
                    ),
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
