import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../Model/order_model.dart';
import '../Service/order_service.dart';

class OrderController extends GetxController {
  final OrderService _orderService = OrderService();
  final orderByid = Rxn<OrderModel>();
  final orderByRiderId = <OrderModel>[].obs;
  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final orderList = <OrderModel>[].obs;

  @override
  void onInit() {
    displayListOrders();
    super.onInit();
  }

  void listenToOrders(String userId) {
    isLoading(true);
    hasError(false);

    FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      orders.value =
          snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
      isLoading(false);
    }, onError: (error) {
      hasError(true);
      errorMessage(error.toString());
      isLoading(false);
    });
  }

  Future<void> updateOrderByRider(
    String orderId,
    String riderId,
    String riderName,
    String status,
  ) async {
    try {
      await _orderService.updateOrderForRider(
        orderId: orderId,
        riderId: riderId,
        riderName: riderName,
        status: status,
      );
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchOrdersByorderId(String orderId) async {
    if (orderId.isEmpty) {
      return;
    }

    isLoading.value = true;
    orderByid.value = null;

    try {
      final data = await _orderService.getOrderById(orderId);
      orderByid.value = data;

      if (data != null) {}
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
      print('Fetch completed, isLoading set to false');
    }
  }

  Future<void> fetchOrdersByUserId(String? userId) async {
    try {
      if (userId == null || userId.isEmpty) {
        hasError.value = true;
        errorMessage.value = 'ไม่พบข้อมูลผู้ใช้';
        orders.value = [];
        return;
      }

      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final String validUserId = userId;

      final result = await _orderService.getOrdersByUserId(validUserId);

      orders.value = result;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'เกิดข้อผิดพลาดในการโหลดข้อมูล';
      orders.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addOrder(OrderModel order) async {
    await _orderService.createOrder(order);

    orders.add(order);
    update();
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

  Future<void> displayListOrders() async {
    isLoading.value = true;

    try {
      print('Fetching all orders');
      final data = await _orderService.getOrdersList();
      orderList.assignAll(data);
      print('Fetched ${orderList.length} orders successfully');
    } catch (e) {
      print("Error loading orders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOrderByRiderId(String riderId) async {
    try {
      final data = await _orderService.getOrderByRiderId(riderId);
      orderByRiderId.value = data;
    } catch (e) {
      print(e);
    }
  }
}
