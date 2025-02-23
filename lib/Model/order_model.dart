import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String laundryId;
  final int totalPrice;
  final String address;
  final String paymentMethod;
  final String deliveryType;
  final String status;
  final LatLng laundryAddress;
  final Map<String, dynamic> deliveryAddress;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.laundryId,
    required this.totalPrice,
    required this.address,
    required this.paymentMethod,
    required this.deliveryType,
    required this.status,
    required this.laundryAddress,
    required this.deliveryAddress,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      orderId: data['orderId'],
      userId: data['userId'],
      laundryId: data['laundryId'],
      totalPrice: data['totalPrice'],
      address: data['address'],
      paymentMethod: data['paymentMethod'],
      deliveryType: data['deliveryType'],
      status: data['status'],
      deliveryAddress:
          CustomerLocation.fromFirestore(data['deliveryAddress'] ?? {})
              .toJson(),
      laundryAddress: LatLng(
        data['laundryAddress']['latitude'],
        data['laundryAddress']['longitude'],
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'laundryId': laundryId,
      'totalPrice': totalPrice,
      'address': address,
      'paymentMethod': paymentMethod,
      'deliveryType': deliveryType,
      'status': status,
      'deliveryAddress': deliveryAddress,
      'laundryAddress': {
        'latitude': laundryAddress.latitude,
        'longitude': laundryAddress.longitude,
      },
    };
  }
}

class CustomerLocation {
  final double latitude;
  final double longitude;

  CustomerLocation({
    required this.latitude,
    required this.longitude,
  });
  factory CustomerLocation.fromFirestore(Map<String, dynamic> data) {
    return CustomerLocation(
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
