import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String orderCollection = "orders";

  Future<void> createOrder(OrderModel order) async {
    try {
      String orderId = _firestore.collection(orderCollection).doc().id;

      await _firestore
          .collection(orderCollection)
          .doc(orderId)
          .set(order.toFirestore());
      print('saved laundryAddress :: ${order.laundryAddress}');
      print("Order created successfully with ID: $orderId");
    } catch (e) {
      print("Error creating order: $e");
      throw e;
    }
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(orderCollection).doc(orderId).get();
      if (doc.exists) {
        return OrderModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print("Error getting order: $e");
      throw e;
    }
  }

  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(orderCollection)
          .where("userId", isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error getting orders by userId: $e");
      throw e;
    }
  }

  Future<void> updateOrder(
      String orderId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore
          .collection(orderCollection)
          .doc(orderId)
          .update(updatedData);
    } catch (e) {
      print("Error updating order: $e");
      throw e;
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection(orderCollection).doc(orderId).delete();
    } catch (e) {
      print("Error deleting order: $e");
      throw e;
    }
  }
}
