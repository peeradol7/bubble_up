import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "orders";

  Future<void> createOrder(OrderModel order) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(order.orderId)
          .set(order.toFirestore());
    } catch (e) {
      print("Error creating order: $e");
      throw e;
    }
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collectionPath).doc(orderId).get();
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
          .collection(collectionPath)
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
          .collection(collectionPath)
          .doc(orderId)
          .update(updatedData);
    } catch (e) {
      print("Error updating order: $e");
      throw e;
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection(collectionPath).doc(orderId).delete();
    } catch (e) {
      print("Error deleting order: $e");
      throw e;
    }
  }
}
