import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/location_controller.dart';

class LocationResultListWidget extends GetView<LocationController> {
  const LocationResultListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.searchText.isEmpty) {
        return const SizedBox.shrink();
      }

      return StreamBuilder(
        stream: controller.getLocationsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var filteredDocs = controller.getFilteredLocations(snapshot.data!);

          if (filteredDocs.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) =>
                    _buildListItem(filteredDocs[index], index),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildListItem(DocumentSnapshot doc, int index) {
    try {
      final data = doc.data() as Map<String, dynamic>;

      if (!controller.isValidLocation(data)) {
        return _buildErrorTile('ข้อมูลไม่ครบถ้วน', Colors.grey[100]);
      }

      return GestureDetector(
        onTap: () {
          controller.handleLocationSelection(data, index);
          controller.searchController.clear();
          controller.searchText.value = '';
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: ListTile(
            title: Text(
              data['laundryName'],
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              data['type'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    } catch (e) {
      return _buildErrorTile('เกิดข้อผิดพลาดในการแสดงข้อมูล', Colors.red[50]);
    }
  }

  Widget _buildErrorTile(String message, Color? color) {
    return ListTile(
      title: Text(message),
      tileColor: color,
    );
  }
}
