import 'package:cloud_firestore/cloud_firestore.dart';

class LaundrysModel {
  final String laundryName;
  final String image;
  final double latitude;
  final double longitude;
  final String detail;
  final Map<String, dynamic> price;
  LaundrysModel({
    required this.laundryName,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.detail,
    required this.price,
  });

  factory LaundrysModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return LaundrysModel(
      laundryName: data['laundryName'] ?? '',
      image: data['image'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      detail: data['detail'] ?? '',
      price: Price.fromFirestore(data['price'] ?? {}).toJson(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'laundryName': laundryName,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
      'detail': detail,
      'price': price,
    };
  }
}

class Price {
  final int starter;
  final int normal;
  final int premium;

  Price({
    required this.starter,
    required this.normal,
    required this.premium,
  });
  factory Price.fromFirestore(Map<String, dynamic> data) {
    return Price(
      starter: data['starter'],
      normal: data['normal'],
      premium: data['premium'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'starter': starter,
      'normal': normal,
      'premium': premium,
    };
  }
}
