import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thammasat/View/home_page/widget/build_navigation_bar.dart';

import '../../../Controller/menubar_controller.dart';

class MenuBarWidget extends StatelessWidget {
  const MenuBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MenuBarController controller = Get.find<MenuBarController>();
    final BuildNavigationBar navigationBar = BuildNavigationBar();

    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: (index) => controller.changePage(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          navigationBar.buildNavItem(
            Icons.home,
            'Home',
            0,
            controller,
          ),
          navigationBar.buildNavItem(
              Icons.location_on, 'Near Me', 1, controller),
          navigationBar.buildNavItem(Icons.assignment, 'Status', 2, controller),
          navigationBar.buildNavItem(Icons.person, 'Me', 3, controller),
        ],
      ),
    );
  }
}
