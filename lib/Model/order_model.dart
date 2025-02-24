import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderModel {
  final String? orderId;
  final String userId;
  final String laundryId;
  final int totalPrice;
  final String address;
  final String paymentMethod;
  final String deliveryType;
  final String? status;
  final LatLng laundryAddress;
  final Map<String, dynamic> deliveryAddress;
  final String? laundryName;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.laundryId,
    required this.laundryName,
    required this.totalPrice,
    required this.address,
    required this.paymentMethod,
    required this.deliveryType,
    required this.status,
    required this.laundryAddress,
    required this.deliveryAddress,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    // Add a null check for data
    if (data == null) {
      throw Exception("Document data is null");
    }

    return OrderModel(
      orderId: data['orderId'] ?? '',
      userId: data['userId'] ?? '',
      laundryId: data['laundryId'] ?? '',
      totalPrice: data['totalPrice'] ?? 0,
      address: data['address'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      deliveryType: data['deliveryType'] ?? '',
      status: data['status'] ?? '',
      deliveryAddress: data['deliveryAddress'] != null
          ? CustomerLocation.fromFirestore(
                  data['deliveryAddress'] as Map<String, dynamic>)
              .toJson()
          : CustomerLocation(latitude: 0, longitude: 0).toJson(),
      laundryAddress: data['laundryAddress'] != null
          ? LatLng(
              data['laundryAddress']['latitude'] ?? 0.0,
              data['laundryAddress']['longitude'] ?? 0.0,
            )
          : const LatLng(0, 0),
      laundryName: data['laundryName'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'orderId': orderId,
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
      'laundryName': laundryName,
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
