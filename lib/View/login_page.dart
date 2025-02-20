import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: context.canPop(),
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }

        if (context.canPop()) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ),
      ),
    );
  }
}
