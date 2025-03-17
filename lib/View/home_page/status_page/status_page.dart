import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/Controller/notification_controller.dart';
import 'package:thammasat/Controller/order_controller.dart';

import '../../../constants/app_theme.dart';

class StatusPage extends StatelessWidget {
  StatusPage({super.key});

  final NotificationController notificationController =
      Get.find<NotificationController>();
  final OrderController orderController = Get.put(OrderController());

  void _showDeleteConfirmation(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('ยืนยันการลบออเดอร์'),
            ],
          ),
          content: Text('คุณต้องการยกเลิกออเดอร์นี้ใช่หรือไม่?'),
          actions: [
            TextButton(
              child: Text(
                'ยกเลิก',
                style: TextStyle(color: Colors.grey[700]),
              ),
              onPressed: () {
                context.pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('ลบออเดอร์'),
              onPressed: () {
                orderController.deleteOrder(orderId);
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สถานะออเดอร์',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.lightBlue.withOpacity(0.3), Colors.white],
            ),
          ),
          child: FutureBuilder<Map<String, dynamic>?>(
            future: authController.loadUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'ข้อผิดพลาด: ${snapshot.error}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_off,
                        size: 64,
                        color: AppTheme.secondaryColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "ไม่มีข้อมูลผู้ใช้",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.darkBlue,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final userId = snapshot.data!['userId'] as String;

              orderController.listenToOrders(userId);

              return Obx(() {
                if (orderController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  );
                }

                if (orderController.hasError.value) {
                  return Center(
                    child: Text(
                      orderController.errorMessage.value,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  );
                }

                if (orderController.orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 80,
                          color: AppTheme.accentColor,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'ไม่พบออเดอร์',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.darkBlue,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'ออเดอร์ที่คุณสั่งจะแสดงที่นี่',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: orderController.orders.length,
                  itemBuilder: (context, index) {
                    final order = orderController.orders[index];
                    final orderStatus = order.status ?? "ไม่ระบุสถานะ";
                    final riderName =
                        order.riderName ?? "ยังไม่มีไรเดอร์รับออเดอร์";

                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: AppTheme.cardDecoration,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onLongPress: () {
                              _showDeleteConfirmation(
                                  context, order.orderId ?? "");
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.getStatusColor(orderStatus),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        AppTheme.getStatusIcon(orderStatus),
                                        size: 20,
                                        color: Colors.black87,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        orderStatus,
                                        style: AppTheme.statusStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                // Order details
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              order.laundryName ??
                                                  "ไม่ระบุชื่อร้าน",
                                              style: AppTheme.headingStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              "${order.totalPrice} บาท",
                                              style: TextStyle(
                                                color: AppTheme.primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      _buildInfoRow(Icons.delivery_dining,
                                          "ผู้รับออเดอร์", riderName),
                                      SizedBox(height: 4),
                                      _buildInfoRow(
                                          Icons.local_shipping,
                                          "การจัดส่ง",
                                          order.deliveryType ?? "ไม่ระบุ"),
                                      SizedBox(height: 8),
                                      Text(
                                        "กดค้างเพื่อลบออเดอร์",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.secondaryColor,
        ),
        SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
