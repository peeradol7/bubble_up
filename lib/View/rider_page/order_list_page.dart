import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/order_controller.dart';
import 'package:thammasat/View/home_page/profile_page/profile_page.dart';
import 'package:thammasat/View/rider_page/order/my_order_page.dart';
import 'package:thammasat/app_routes.dart';

import '../../Controller/menubar_controller.dart';
import 'widget/rider_menu_bar_widget.dart';

class OrderListPage extends StatelessWidget {
  OrderListPage({super.key});

  final OrderController orderController = Get.put(OrderController());
  final MenuBarController menuBarController = Get.find<MenuBarController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Obx(
                () {
                  if (orderController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return PageView(
                    controller: menuBarController.pageController,
                    // ลบ NeverScrollableScrollPhysics เพื่อให้สไลด์ได้
                    // หากต้องการปรับแต่งความรู้สึกในการสไลด์ สามารถใช้ physics อื่นได้
                    // เช่น ClampingScrollPhysics() หรือ BouncingScrollPhysics()
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      // เมื่อเปลี่ยนหน้าด้วยการสไลด์ ให้อัพเดท selectedIndex ด้วย
                      menuBarController.selectedIndex.value = index;
                    },
                    children: [
                      // หน้าที่ 1: รายการออเดอร์
                      orderController.orderList.isEmpty
                          ? const Center(child: Text('ไม่มีออเดอร์'))
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 80),
                              itemCount: orderController.orderList.length,
                              itemBuilder: (context, index) {
                                final order = orderController.orderList[index];

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: ListTile(
                                    title: Text(order.laundryName!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("ราคา: ${order.totalPrice} บาท"),
                                        Text(
                                            "ประเภทส่ง: ${order.deliveryType}"),
                                        Text(
                                            "วิธีชำระเงิน: ${order.paymentMethod}"),
                                      ],
                                    ),
                                    trailing:
                                        const Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      final route = AppRoutes.orderDetail;
                                      final orderId = order.orderId;
                                      print(orderId);
                                      context.push('$route/$orderId');
                                      orderController
                                          .fetchOrdersByorderId(orderId!);
                                    },
                                  ),
                                );
                              },
                            ),
                      // หน้าที่ 2: งานของฉัน
                      MyOrderPage(),
                      // หน้าที่ 3: โปรไฟล์
                      ProfileWidget(),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: RiderMenuBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
