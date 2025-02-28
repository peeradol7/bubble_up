import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String orderCollection = "orders";

  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    try {
      if (userId.isEmpty) {
        return [];
      }

      final QuerySnapshot querySnapshot = await _firestore
          .collection(orderCollection)
          .where("userId", isEqualTo: userId)
          .get();

      final orders = querySnapshot.docs.map((doc) {
        return OrderModel.fromFirestore(doc);
      }).toList();

      return orders;
    } catch (e, stackTrace) {
      print("StackTrace: $stackTrace");
      throw e;
    }
  }

  Future<List<OrderModel>> getOrdersList() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection(orderCollection)
          .where('status', isEqualTo: 'pending')
          .get();

      final orders = querySnapshot.docs.map((doc) {
        return OrderModel.fromFirestore(doc);
      }).toList();

      return orders;
    } catch (e, stackTrace) {
      print("StackTrace: $stackTrace");
      throw e;
    }
  }

  Future<void> createOrder(OrderModel order) async {
    try {
      String orderId = _firestore.collection(orderCollection).doc().id;

      OrderModel updatedOrder = OrderModel(
        orderId: orderId,
        userId: order.userId,
        laundryId: order.laundryId,
        laundryName: order.laundryName,
        totalPrice: order.totalPrice,
        address: order.address,
        paymentMethod: order.paymentMethod,
        deliveryType: order.deliveryType,
        status: 'Pending',
        laundryAddress: order.laundryAddress,
        deliveryAddress: order.deliveryAddress,
      );

      await _firestore
          .collection(orderCollection)
          .doc(orderId)
          .set(updatedOrder.toFirestore());

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
      print('Document ID: ${doc.id}');
      print('Fetching from collection: $orderCollection');

      if (doc.exists) {
        print("Document data: ${doc.data()}");
        return OrderModel.fromFirestore(doc);
      } else {
        print("Document does not exist.");
        return null;
      }
    } catch (e) {
      print("Error getting order: $e");
      return null;
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
