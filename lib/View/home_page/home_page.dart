import 'package:flutter/material.dart';
import 'package:thammasat/View/home_page/select_service_widget/display_service_widget.dart';
import 'package:thammasat/View/home_page/select_service_widget/promotion_banner_widget.dart';
import 'package:thammasat/View/home_page/select_service_widget/show_location_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            SliverToBoxAdapter(
              child: DisplayServiceWidget(),
            ),
            SliverToBoxAdapter(
              child: PromotionBannerWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
