import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/menubar_controller.dart';

class RiderNavigatorbarWidget {
  BottomNavigationBarItem buildAnimatedNavItem(
    IconData icon,
    String label,
    int index,
    MenuBarController controller,
  ) {
    return BottomNavigationBarItem(
      icon: Obx(() {
        final isSelected = controller.selectedIndex.value == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuint,
          padding: EdgeInsets.only(bottom: isSelected ? 4 : 0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated background circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: isSelected ? 40 : 0,
                width: isSelected ? 40 : 0,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              // Animated icon with color
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.blue : Colors.grey,
                  size: isSelected ? 30 : 24,
                ),
              ),
              // Indicator bar
              if (isSelected)
                Positioned(
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    width: 20,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
      label: label,
    );
  }

  BottomNavigationBarItem buildNavItem(
    IconData icon,
    String label,
    int index,
    MenuBarController controller,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: controller.selectedIndex.value == index ? 30 : 24,
      ),
      label: label,
    );
  }
}
