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
  final List<String> message = [
    'No more trips to the laundromat! Choose your preferred pickup time, and our riders will collect and deliver your laundry straight to your door. 🚛✨',
    'We use high-quality cleaning products and specialized techniques to ensure your garments stay fresh, bright, and long-lasting. 👕💎',
    'Easily track your order at every stage—from pickup and cleaning to delivery—right from our app. ⏳📱'
  ];

  void pageChanged(int index) {
    currentIndex.value = index;
  }
}
