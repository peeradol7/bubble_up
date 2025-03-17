import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thammasat/Controller/order_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/constant_status.dart';

class ProcessOrderPage extends StatefulWidget {
  final String orderId;

  const ProcessOrderPage({
    super.key,
    required this.orderId,
  });

  @override
  _ProcessOrderPageState createState() => _ProcessOrderPageState();
}

class _ProcessOrderPageState extends State<ProcessOrderPage> {
  final OrderController orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.fetchOrdersByorderId(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: GetX<OrderController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          orderController.fetchOrdersByorderId(widget.orderId);
          final order = controller.orderByid.value;
          if (order == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 100, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'No order found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please check the order ID and try again',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(
                  title: 'เงินที่ได้รับ',
                  content: '${order.totalPrice} THB',
                  icon: Icons.monetization_on,
                ),
                SizedBox(height: 16),
                _buildInfoCard(
                  title: 'ที่อยู่ลูกค้า',
                  content: order.address,
                  icon: Icons.location_on,
                ),
                SizedBox(height: 16),
                _buildInfoCard(
                  title: 'เบอร์ลูกค้า',
                  content: order.phoneNumber,
                  icon: Icons.phone,
                ),
                SizedBox(height: 16),
                _buildInfoCard(
                  title: 'ชื่อร้านซักรีด',
                  content: order.laundryName ?? 'Unknown Laundry',
                  icon: Icons.local_laundry_service,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openGoogleMaps(
                          order.laundryAddress.latitude,
                          order.laundryAddress.longitude,
                          'Laundry Location',
                        ),
                        icon: Icon(Icons.store, color: Colors.white),
                        label: Text('ที่อยู่ร้านซักรีด'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openGoogleMaps(
                          order.deliveryAddress['latitude'],
                          order.deliveryAddress['longitude'],
                          'Delivery Location',
                        ),
                        icon: Icon(Icons.home, color: Colors.white),
                        label: Text('ไปที่อยู่ลูกค้า'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (order.status == ConstantStatus.orderAccepted)
                  _buildStatusButton(
                      'รับผ้าจากลูกค้า',
                      ConstantStatus.pickupInProgress,
                      Colors.green,
                      order.orderId!,
                      null),
                if (order.status == ConstantStatus.pickupInProgress)
                  _buildStatusButton(
                      'ส่งผ้าไปร้านซัก',
                      ConstantStatus.atLaundryShop,
                      Colors.blue,
                      order.orderId!,
                      null),
                if (order.status == ConstantStatus.atLaundryShop)
                  _buildStatusButton(
                      'ร้านซักรีดกำลังซักผ้า',
                      ConstantStatus.laundryInProcess,
                      Colors.orange,
                      order.orderId!,
                      null),
                if (order.status == ConstantStatus.laundryInProcess)
                  _buildStatusButton(
                      'กำลังนำผ้าไปส่ง',
                      ConstantStatus.deliveryInProgress,
                      Colors.purple,
                      order.orderId!,
                      null),
                if (order.status == ConstantStatus.deliveryInProgress)
                  _buildStatusButton(
                      'ส่งผ้าเรียบร้อย',
                      ConstantStatus.completed,
                      Colors.teal,
                      order.orderId!,
                      DateTime.now()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusButton(String label, String newStatus, Color color,
      String orderId, DateTime? time) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(color),
        ),
        onPressed: () {
          orderController.fetchOrdersByorderId(orderId);
          orderController.updateOrderStatusController(orderId, newStatus, time);
        },
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(content),
      ),
    );
  }

  void _openGoogleMaps(double latitude, double longitude, String label) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackbar('Could not launch Google Maps');
      }
    } catch (e) {
      _showErrorSnackbar('An error occurred while opening maps');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
