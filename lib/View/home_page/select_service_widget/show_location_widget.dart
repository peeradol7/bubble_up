import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thammasat/Controller/location_controller.dart';
import 'package:thammasat/Controller/position_controller.dart';
import 'package:thammasat/View/home_page/select_service_widget/search_widget.dart';

class ShowLocationWidget extends StatelessWidget {
  final LocationController locationController = Get.find<LocationController>();
  final PositionController mapController = Get.find<PositionController>();
  final TextEditingController searchController = TextEditingController();

  ShowLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const appbar = Color(0xFF01B9E4);

    return SliverAppBar(
      elevation: 0,
      backgroundColor: appbar,
      expandedHeight: 150,
      pinned: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1.0,
        background: Stack(
          // เปลี่ยนเป็น Stack เพื่อรองรับ ResultList
          children: [
            Container(
              decoration: BoxDecoration(
                color: appbar,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Obx(() {
                          var district = mapController.district.value;
                          return Positioned(
                            left: 100,
                            top: 5,
                            child: Text(
                              district.isNotEmpty
                                  ? district
                                  : 'Loading location...',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: SearchWidget(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
