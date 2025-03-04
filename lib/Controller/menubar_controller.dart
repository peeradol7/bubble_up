import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuBarController extends GetxController {
  var selectedIndex = 0.obs;

  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedIndex.value);
  }

  void changePage(BuildContext context, int index) {
    selectedIndex.value = index;

    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
