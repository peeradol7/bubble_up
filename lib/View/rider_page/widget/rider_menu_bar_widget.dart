import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/menubar_controller.dart';
import 'rider_navigatorbar_widget.dart';

class RiderMenuBarWidget extends StatelessWidget {
  const RiderMenuBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MenuBarController controller = Get.find<MenuBarController>();
    final RiderNavigatorbarWidget navigationBar = RiderNavigatorbarWidget();

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value.clamp(0, 2),
          onTap: (index) {
            if (index >= 0 && index < 3) {
              controller.changePage(context, index);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: [
            navigationBar.buildAnimatedNavItem(
              Icons.home,
              'Home',
              0,
              controller,
            ),
            navigationBar.buildAnimatedNavItem(
              Icons.motorcycle_rounded,
              'งานของฉัน',
              1,
              controller,
            ),
            navigationBar.buildAnimatedNavItem(
              Icons.person,
              'Me',
              2,
              controller,
            ),
          ],
        ),
      ),
    );
  }
}
