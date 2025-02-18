import 'package:flutter/material.dart';

class InputPasswordPage extends StatefulWidget {
  const InputPasswordPage({super.key});

  @override
  State<InputPasswordPage> createState() => _InputPasswordPageState();
}

class _InputPasswordPageState extends State<InputPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Data'),
        backgroundColor: Colors.blue[200],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Container(),
      ),
    );
  }
}
