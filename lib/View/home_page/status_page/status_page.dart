import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/Controller/order_controller.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

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

            String? userId;
            try {
              userId = snapshot.data!['userId'] as String;
            } catch (e) {
              return const Center(child: Text('Invalid user data format'));
            }

            if (userId.isEmpty || userId == 'Guest') {
              return const Center(child: Text('Please login to view orders'));
            }

            return FutureBuilder<void>(
              future: orderController.fetchOrdersByUserId(userId),
              builder: (context, _) {
                return Obx(() {
                  if (orderController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (orderController.hasError.value) {
                    return Center(
                        child: Text(orderController.errorMessage.value));
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
                        child: ListTile(
                          title: Text('Order ID: ${order.orderId}'),
                          subtitle: Text(
                              'Total Price: \$${order.totalPrice}\nStatus: ${order.status}'),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                      );
                    },
                  );
                });
              },
            );
          },
        ),
      ),
    );
  }
}
