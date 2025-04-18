import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/order_controller.dart';
import 'package:thammasat/constants/constant_status.dart';

import '../../Service/shared_preferenes_service.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final OrderController orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
  }

  void updateorder() {
    SharedPreferencesService.getInstance().then(
      (prefs) {
        final userData = prefs.getUserData();
        final name = userData['name'];
        final userId = userData['userId'];
        String riderId = 'rider$userId';

        orderController.updateOrderByRider(
          widget.orderId,
          riderId,
          name!,
          ConstantStatus.orderAccepted,
        );
        print('อัพเดทข้อมูลสำเร็จ');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("รายละเอียดออเดอร์")),
      body: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderController.orderByid.value == null) {
          print('order Id :: ${orderController.orderByid.value}');
          return const Center(child: Text("ไม่พบข้อมูลออเดอร์"));
        }

        final order = orderController.orderByid.value!;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ร้านซักรีด: ${order.laundryName}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("ราคารวม: ${order.totalPrice} บาท",
                  style: const TextStyle(fontSize: 18)),
              Text("ประเภทการส่ง: ${order.deliveryType}",
                  style: const TextStyle(fontSize: 18)),
              Text("วิธีชำระเงิน: ${order.paymentMethod}",
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              const Text("ที่อยู่จัดส่งของลูกค้า:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(order.address ?? 'ไม่ได้ใส่ที่อยู่'),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              updateorder();
              orderController.displayListOrders();
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "รับออเดอร์",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
