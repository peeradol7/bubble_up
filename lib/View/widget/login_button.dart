import 'package:flutter/material.dart';

class CustomButton {
  ButtonStyle btnStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF818EF4),
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget btnlogin({
    required VoidCallback onPressed,
    required String label,
    required String iconPath,
    double iconWidth = 30,
    double iconHeight = 30,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(
        iconPath,
        width: iconWidth,
        height: iconHeight,
        fit: BoxFit.contain,
      ),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      style: btnStyle(),
    );
  }
}
