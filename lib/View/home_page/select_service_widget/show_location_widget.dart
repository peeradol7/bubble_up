import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thammasat/Controller/map_controller.dart';

class ShowLocationWidget extends StatefulWidget {
  const ShowLocationWidget({super.key});

  @override
  State<ShowLocationWidget> createState() => _ShowLocationWidgetState();
}

class _ShowLocationWidgetState extends State<ShowLocationWidget> {
  final MapController mapController = Get.put(MapController());

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
        background: Container(
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
                padding: EdgeInsets.only(left: 18, right: 18),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(width: 1),
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
                        right: 0,
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
            ],
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(
            left: 25,
            right: 25,
            bottom: 10,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        titlePadding: EdgeInsets.zero,
      ),
    );
  }
}
