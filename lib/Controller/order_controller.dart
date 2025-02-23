import 'package:get/get.dart';

import '../Model/order_model.dart';
import '../Service/order_service.dart';

class OrderController extends GetxController {
  final OrderService _orderService = OrderService();
  final orderByid = Rxn<OrderModel>();
  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  Future<void> fetchOrdersByUserId(String? userId) async {
    try {
      print("Debug - userId received: '$userId'");
      print("Debug - userId type: ${userId.runtimeType}");

      // ตรวจสอบ null และ empty
      if (userId == null || userId.isEmpty) {
        print("Debug - userId is null or empty");
        hasError.value = true;
        errorMessage.value = 'ไม่พบข้อมูลผู้ใช้';
        orders.value = []; // เคลียร์ค่าเก่าถ้ามี
        return;
      }

      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // สร้าง local variable เพื่อให้แน่ใจว่าเป็น String
      final String validUserId = userId;
      print("Debug - about to call service with userId: '$validUserId'");

      final result = await _orderService.getOrdersByUserId(validUserId);
      print("Debug - service call successful, orders count: ${result.length}");

      orders.value = result;
    } catch (e, stackTrace) {
      // เพิ่ม stackTrace เพื่อดู error details
      print("Debug - Error in fetchOrdersByUserId:");
      print("Error: $e");
      print("StackTrace: $stackTrace");

      hasError.value = true;
      errorMessage.value = 'เกิดข้อผิดพลาดในการโหลดข้อมูล';
      orders.value = []; // เคลียร์ค่าเก่าเมื่อเกิด error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addOrder(OrderModel order) async {
    await _orderService.createOrder(order);

    orders.add(order);
  }

  Future<void> updateOrder(
      String orderId, Map<String, dynamic> updatedData) async {
    await _orderService.updateOrder(orderId, updatedData);
    fetchOrdersByUserId(updatedData['userId']);
  }

  Future<void> deleteOrder(String orderId) async {
    await _orderService.deleteOrder(orderId);
    orders.removeWhere((order) => order.orderId == orderId);
  }
}
