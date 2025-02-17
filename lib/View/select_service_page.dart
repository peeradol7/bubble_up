import 'package:flutter/material.dart';
import 'package:thammasat/View/select_service_widget/show_location_widget.dart';

class SelectServicePage extends StatefulWidget {
  const SelectServicePage({super.key});

  @override
  State<SelectServicePage> createState() => _SelectServicePageState();
}

class _SelectServicePageState extends State<SelectServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            ShowLocationWidget(),
            SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            // เพิ่ม content อื่นๆ ที่นี่
          ],
        ),
      ),
    );
  }
}
