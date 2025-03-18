import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/order_controller.dart';
import 'package:thammasat/View/home_page/profile_page/profile_page.dart';
import 'package:thammasat/View/rider_page/order/my_order_page.dart';
import 'package:thammasat/app_routes.dart';

import '../../Controller/menubar_controller.dart';
import '../../constants/app_theme.dart';
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
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [AppTheme.lightBlue.withOpacity(0.2), Colors.white],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    color: AppTheme.primaryColor,
                    child: Row(
                      children: [
                        Icon(Icons.pedal_bike, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          'Bubble up rider',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () {
                        if (orderController.isLoading.value) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryColor,
                            ),
                          );
                        }

                        return PageView(
                          controller: menuBarController.pageController,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (index) {
                            menuBarController.selectedIndex.value = index;
                          },
                          children: [
                            orderController.orderList.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.receipt_long_outlined,
                                          size: 72,
                                          color: AppTheme.accentColor,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'ไม่มีออเดอร์ในขณะนี้',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: AppTheme.darkBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.only(
                                      bottom: 80,
                                      left: 16,
                                      right: 16,
                                      top: 16,
                                    ),
                                    itemCount: orderController.orderList.length,
                                    itemBuilder: (context, index) {
                                      final order =
                                          orderController.orderList[index];

                                      return Container(
                                        margin: EdgeInsets.only(bottom: 12),
                                        decoration: AppTheme.cardDecoration,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                final route =
                                                    AppRoutes.orderDetail;
                                                final orderId = order.orderId;
                                                print(orderId);
                                                context.push('$route/$orderId');
                                                orderController
                                                    .fetchOrdersByorderId(
                                                        orderId!);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            order.laundryName!,
                                                            style: AppTheme
                                                                .headingStyle,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 12,
                                                            vertical: 6,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppTheme
                                                                .accentColor
                                                                .withOpacity(
                                                                    0.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Text(
                                                            "${order.totalPrice} บาท",
                                                            style: AppTheme
                                                                .priceStyle,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(height: 24),
                                                    Row(
                                                      children: [
                                                        _buildInfoItem(
                                                          Icons.local_shipping,
                                                          "ประเภทส่ง: ${order.deliveryType}",
                                                        ),
                                                        SizedBox(width: 12),
                                                        _buildInfoItem(
                                                          Icons.payment,
                                                          "ชำระเงิน: ${order.paymentMethod}",
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        TextButton.icon(
                                                          onPressed: () {
                                                            final route =
                                                                AppRoutes
                                                                    .orderDetail;
                                                            final orderId =
                                                                order.orderId;
                                                            context.push(
                                                                '$route/$orderId');
                                                            orderController
                                                                .fetchOrdersByorderId(
                                                                    orderId!);
                                                          },
                                                          icon: Icon(
                                                            Icons.visibility,
                                                            color: AppTheme
                                                                .primaryColor,
                                                            size: 18,
                                                          ),
                                                          label: Text(
                                                            "รายละเอียด",
                                                            style: TextStyle(
                                                              color: AppTheme
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                AppTheme
                                                                    .primaryColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
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
                ],
              ),
            ),
            Positioned(
              bottom: 1,
              left: 0,
              right: 0,
              child: _buildMenuBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.secondaryColor,
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: AppTheme.subtitleStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: RiderMenuBarWidget(),
    );
  }
}
