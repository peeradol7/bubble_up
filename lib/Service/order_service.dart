import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String orderCollection = "orders";

  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    try {
      print("Service - received userId: '$userId'"); // debug log

      if (userId.isEmpty) {
        return [];
      }

      print("Service - collection path: '$orderCollection'");

      final QuerySnapshot querySnapshot = await _firestore
          .collection(orderCollection)
          .where("userId", isEqualTo: userId)
          .get();

      print(
          "Service - query completed, docs count: ${querySnapshot.docs.length}");

      final orders = querySnapshot.docs.map((doc) {
        print("Service - converting doc ${doc.id}"); // debug log
        return OrderModel.fromFirestore(doc);
      }).toList();

      print("Service - conversion completed, orders count: ${orders.length}");
      return orders;
    } catch (e, stackTrace) {
      print("Service error details:");
      print("Error: $e");
      print("StackTrace: $stackTrace");
      throw e; // ส่ง error กลับไปให้ controller จัดการ
    }
  }

  Future<void> createOrder(OrderModel order) async {
    try {
      String orderId = _firestore.collection(orderCollection).doc().id;

      await _firestore
          .collection(orderCollection)
          .doc(orderId)
          .set(order.toFirestore());
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
