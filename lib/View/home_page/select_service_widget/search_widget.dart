import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/location_controller.dart';

class SearchWidget extends GetView<LocationController> {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: 'ค้นหาสถานที่',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
