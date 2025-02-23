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
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("No user data available"));
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
                return const Center(child: Text('No orders found.'));
              }

              return ListView.builder(
                itemCount: orderController.orders.length,
                itemBuilder: (context, index) {
                  final order = orderController.orders[index];

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    color: getStatusColor(order.status),
                    child: ListTile(
                      title: Text('ชื่อร้าน: ${order.laundryName}'),
                      subtitle: Text(
                          'Total Price: \$${order.totalPrice}\nStatus: ${order.status}'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {},
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
      case 'in progress':
        return Colors.blue.shade100;
      case 'completed':
        return completed();
      case 'cancelled':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color completed() {
    notificationController.showOrderCompleteNotification();
    return Colors.green.shade100;
  }
}
