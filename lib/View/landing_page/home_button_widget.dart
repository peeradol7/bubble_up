import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/View/dialog/sign_up_dialog.dart';
import 'package:thammasat/app_routes.dart';

class HomeButtonWidget extends StatelessWidget {
  const HomeButtonWidget({super.key});

  void handleSignUp(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: SignUpDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          _buildButton(
            text: 'Sign Up',
            color: Colors.blue,
            textColor: Colors.white,
            isOutlined: false,
            onPressed: () {
              handleSignUp(context);
            },
          ),
          const SizedBox(height: 15),
          _buildButton(
            text: 'Log In',
            color: Colors.blue,
            textColor: Colors.blue,
            isOutlined: true,
            onPressed: () {
              context.push(AppRoutes.loginPage);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    required bool isOutlined,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: isOutlined
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: onPressed,
              child:
                  Text(text, style: TextStyle(fontSize: 18, color: textColor)),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: onPressed,
              child:
                  Text(text, style: TextStyle(fontSize: 18, color: textColor)),
            ),
    );
  }
}
