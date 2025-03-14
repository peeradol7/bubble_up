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
  final String? riderName;
  final String? riderId;
  final String phoneNumber;

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
    this.riderName,
    this.riderId,
    required this.phoneNumber,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Document data is null");
    }

    try {
      return OrderModel(
        orderId: data['orderId'] ?? doc.id,
        userId: data['userId'] ?? '',
        laundryId: data['laundryId'] ?? '',
        totalPrice: data['totalPrice'] ?? 0,
        address: data['address'] ?? '',
        paymentMethod: data['paymentMethod'] ?? '',
        deliveryType: data['deliveryType'] ?? '',
        status: data['status'] ?? '',
        deliveryAddress: data['deliveryAddress'] != null
            ? (data['deliveryAddress'] is Map
                ? CustomerLocation.fromFirestore(
                        Map<String, dynamic>.from(data['deliveryAddress']))
                    .toJson()
                : CustomerLocation(latitude: 0, longitude: 0).toJson())
            : CustomerLocation(latitude: 0, longitude: 0).toJson(),
        laundryAddress: data['laundryAddress'] != null &&
                data['laundryAddress'] is Map &&
                data['laundryAddress']['latitude'] != null &&
                data['laundryAddress']['longitude'] != null
            ? LatLng(
                (data['laundryAddress']['latitude'] as num).toDouble(),
                (data['laundryAddress']['longitude'] as num).toDouble(),
              )
            : const LatLng(0, 0),
        laundryName: data['laundryName'] ?? '',
        riderName: data['riderName'] ?? '',
        riderId: data['riderId'] ?? '',
        phoneNumber: data['phoneNumber'] ?? 'ไม่มีเบอร์ติดต่อ',
      );
    } catch (e) {
      print("Error parsing OrderModel: $e");
      throw Exception("Failed to parse OrderModel: $e");
    }
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
      'riderName': riderName,
      'riderId': riderId,
      'phoneNumber': phoneNumber,
    };
  }
}

class CustomerLocation {
  final double latitude;
  final double longitude;

  CustomerLocation({required this.latitude, required this.longitude});

  factory CustomerLocation.fromFirestore(Map<String, dynamic> data) {
    return CustomerLocation(
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
