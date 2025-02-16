import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  final RxList<String> images = [
    'assets/slide1.png',
    'assets/slide2.png',
    'assets/slide3.png',
  ].obs;
  final List<String> titles = [
    'Convenient Home Pickup & Delivery',
    'Premium Quality Cleaning & Fabric Care',
    'Track the Progress of Your Laundry in Real Time'
  ];

  void pageChanged(int index) {
    currentIndex.value = index;
  }
}
