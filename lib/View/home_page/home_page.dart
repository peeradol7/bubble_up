import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thammasat/View/home_page/select_service_widget/display_service_widget.dart';
import 'package:thammasat/View/home_page/select_service_widget/menu_bar_widget.dart';
import 'package:thammasat/View/home_page/select_service_widget/promotion_banner_widget.dart';
import 'package:thammasat/View/home_page/select_service_widget/recommended_widget.dart';
import 'package:thammasat/View/home_page/select_service_widget/show_location_widget.dart';

import '../../Controller/menubar_controller.dart';
import '../../Controller/position_controller.dart';
import 'map_page/map_page.dart';
import 'profile_page/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PositionController mapController = Get.find<PositionController>();
  @override
  void initState() {
    mapController.fetchDistrict();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MenuBarController controller = Get.find<MenuBarController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // PageView จะอยู่ภายใต้ LocationResultListWidget
            Positioned.fill(
              child: Obx(() => PageView(
                    controller: controller.pageController,
                    onPageChanged: (index) {
                      controller.selectedIndex.value = index;
                    },
                    physics: controller.selectedIndex.value == 1
                        ? const NeverScrollableScrollPhysics()
                        : const PageScrollPhysics(),
                    children: [
                      CustomScrollView(
                        slivers: [
                          ShowLocationWidget(),
                          SliverToBoxAdapter(child: SizedBox(height: 1)),
                          SliverToBoxAdapter(child: DisplayServiceWidget()),
                          SliverToBoxAdapter(child: PromotionBannerWidget()),
                          SliverToBoxAdapter(child: RecommendedWidget()),
                          SliverToBoxAdapter(child: SizedBox(height: 90)),
                        ],
                      ),
                      MapPage(),
                      Center(child: Text('Status Page')),
                      ProfileWidget(),
                    ],
                  )),
            ),

            // MenuBar อยู่ล่างสุดของจอ
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MenuBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
