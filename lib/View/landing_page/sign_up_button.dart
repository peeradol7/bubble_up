import 'package:flutter/material.dart';

class CustomButton {
  Widget btnSignUp({
    required VoidCallback? onPressed,
    required String label,
    String? iconPath,
    bool isLoading = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 8),
                Text(label),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconPath != null) ...[
                  Image.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );
  }
}
