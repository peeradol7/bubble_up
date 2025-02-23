import 'package:get/get.dart';

import '../Model/order_model.dart';
import '../Service/order_service.dart';

class OrderController extends GetxController {
  final OrderService _orderService = OrderService();
  final orderByid = Rxn<OrderModel>();
  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchOrdersByUserId(String userId) async {
    try {
      isLoading.value = true;
      orders.value = await _orderService.getOrdersByUserId(userId);
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
