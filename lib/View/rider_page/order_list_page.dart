import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/order_controller.dart';
import 'package:thammasat/app_routes.dart';

class OrderListPage extends StatelessWidget {
  OrderListPage({super.key});
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายการออเดอร์')),
      body: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (orderController.orderList.isEmpty) {
          return const Center(child: Text('ไม่มีออเดอร์'));
        }

        return ListView.builder(
          itemCount: orderController.orderList.length,
          itemBuilder: (context, index) {
            final order = orderController.orderList[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text(order.laundryName!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ราคา: ${order.totalPrice} บาท"),
                    Text("ประเภทส่ง: ${order.deliveryType}"),
                    Text("วิธีชำระเงิน: ${order.paymentMethod}"),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  final route = AppRoutes.orderDetail;
                  final orderId = order.orderId;
                  orderController.fetchOrdersByorderId(orderId!);
                  print(orderId);
                  context.push('$route/$orderId');
                },
              ),
            );
          },
        );
      }),
    );
  }
}
