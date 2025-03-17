import 'package:flutter/material.dart';

import 'constant_status.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1A73E8);
  static const Color secondaryColor = Color(0xFF4285F4);
  static const Color accentColor = Color(0xFF8AB4F8);
  static const Color lightBlue = Color(0xFFD2E3FC);
  static const Color darkBlue = Color(0xFF174EA6);
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color accentBlue = Color(0xFF42A5F5);

  static const Color pendingColor = Color(0xFFFFE0B2);
  static const Color acceptedColor = Color(0xFFBBDEFB);
  static const Color pickupColor = Color(0xFFE1BEE7);
  static const Color atShopColor = Color(0xFFB2EBF2);
  static const Color processingColor = Color(0xFFFFF9C4);
  static const Color deliveryColor = Color(0xFFB2DFDB);
  static const Color completedColor = Color(0xFFC8E6C9);
  static const Color cancelledColor = Color(0xFFFFCDD2);
  static const TextStyle headingStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkBlue);

  static const TextStyle subtitleStyle =
      TextStyle(fontSize: 14, color: Colors.black87);

  static const TextStyle priceStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: primaryColor);
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  static const TextStyle statusStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 5,
        offset: Offset(0, 2),
      ),
    ],
  );
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case ConstantStatus.pending:
        return pendingColor;
      case ConstantStatus.orderAccepted:
        return acceptedColor;
      case ConstantStatus.pickupInProgress:
        return pickupColor;
      case ConstantStatus.atLaundryShop:
        return atShopColor;
      case ConstantStatus.laundryInProcess:
        return processingColor;
      case ConstantStatus.deliveryInProgress:
        return deliveryColor;
      case ConstantStatus.completed:
        return completedColor;
      case ConstantStatus.cancelled:
        return cancelledColor;
      default:
        return Colors.grey.shade200;
    }
  }

  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case ConstantStatus.pending:
        return Icons.hourglass_empty;
      case ConstantStatus.orderAccepted:
        return Icons.check_circle_outline;
      case ConstantStatus.pickupInProgress:
        return Icons.directions_bike;
      case ConstantStatus.atLaundryShop:
        return Icons.store;
      case ConstantStatus.laundryInProcess:
        return Icons.local_laundry_service;
      case ConstantStatus.deliveryInProgress:
        return Icons.local_shipping;
      case ConstantStatus.completed:
        return Icons.done_all;
      case ConstantStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}
