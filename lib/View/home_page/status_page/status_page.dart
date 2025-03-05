import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/Controller/notification_controller.dart';
import 'package:thammasat/Controller/order_controller.dart';

class StatusPage extends StatelessWidget {
  StatusPage({super.key});
  final NotificationController notificationController =
      Get.find<NotificationController>();
  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: authController.loadUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('ข้อผิดพลาด: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("ไม่มีข้อมูลผู้ใช้"));
            }

            final userId = snapshot.data!['userId'] as String;

            orderController.listenToOrders(userId);

            return Obx(() {
              if (orderController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (orderController.hasError.value) {
                return Center(child: Text(orderController.errorMessage.value));
              }

              if (orderController.orders.isEmpty) {
                return const Center(child: Text('ไม่พบออเดอร์'));
              }

              return ListView.builder(
                itemCount: orderController.orders.length,
                itemBuilder: (context, index) {
                  final order = orderController.orders[index];
                  final orderStatus = order.status ?? "ไม่ระบุสถานะ";

                  final riderName =
                      order.riderName ?? "ยังไม่มีไรเดอร์รับออเดอร์";

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    color: getStatusColor(orderStatus),
                    child: ListTile(
                      title: Text('ชื่อร้าน: ${order.laundryName}'),
                      subtitle: Text(
                          'ราคารวม: ${order.totalPrice} บาท\nสถานะ: ${orderStatus}\nผู้รับออเดอร์: ${riderName}'),
                      onLongPress: () {},
                    ),
                  );
                },
              );
            });
          },
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade100;
      case 'order accepted':
        return Colors.blue.shade100;
      case 'pickup in progress':
        return Colors.purple.shade100;
      case 'at laundry shop':
        return Colors.cyan.shade100;
      case 'laundry in process':
        return Colors.yellow.shade100;
      case 'delivery in progress':
        return Colors.teal.shade100;
      case 'completed':
        return Colors.green.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }
}
