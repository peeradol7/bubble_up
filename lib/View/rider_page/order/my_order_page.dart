import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/app_routes.dart';

import '../../../Controller/order_controller.dart';

class MyOrderPage extends StatelessWidget {
  MyOrderPage({super.key});
  final OrderController orderController = Get.find<OrderController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
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

            orderController.fetchOrderByRiderId('rider$userId');

            return Obx(() {
              if (orderController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (orderController.hasError.value) {
                return Center(child: Text(orderController.errorMessage.value));
              }

              if (orderController.orderByRiderId.isEmpty) {
                return const Center(child: Text('No orders found.'));
              }

              return ListView.builder(
                itemCount: orderController.orderByRiderId.length,
                itemBuilder: (context, index) {
                  final order = orderController.orderByRiderId[index];
                  String? status;

                  if (order.status == 'Completed') {
                    status = 'เสร็จสิ้น';
                  } else {
                    status = 'กำลังดำเนินการ';
                  }
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('ชื่อร้าน: ${order.laundryName}'),
                      subtitle: Text(
                          'ราคาทั้งหมด: \$${order.totalPrice}\nStatus: $status'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        final orderId = order.orderId;
                        final path = AppRoutes.processOrderPage;
                        context.push('$path/$orderId');
                      },
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
}
