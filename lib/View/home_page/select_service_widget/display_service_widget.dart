import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/View/home_page/widget/service_list_widget.dart';
import 'package:thammasat/app_routes.dart';

class DisplayServiceWidget extends StatelessWidget {
  const DisplayServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceListWidget serviceListWidget = ServiceListWidget();

    void nextPage() {
      context.push(AppRoutes.homepage);
    }

    void printTitle(String title) {
      print(title);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              serviceListWidget.buildServiceItem(
                  'Wash & Fold', ('assets/serviceItem/WashAndFold.png'), () {
                nextPage;
                printTitle('Wash & Fold');
              }),
              serviceListWidget.buildServiceItem(
                  'Wash & Iron', ('assets/serviceItem/WashAndIron.png'), () {
                nextPage;
              }),
              serviceListWidget.buildServiceItem(
                  'Dry Clean', ('assets/serviceItem/DryClean.png'), () {
                nextPage;
              }),
              serviceListWidget.buildServiceItem(
                  'Bedding', ('assets/serviceItem/Bedding.png'), () {
                nextPage;
              }),
              serviceListWidget.buildServiceItem(
                  'Shoes Cleaning', 'assets/serviceItem/ShoesCleaning.png', () {
                nextPage;
              }),
              serviceListWidget.buildServiceItem(
                  'Sofa & Mattress', 'assets/serviceItem/SofaAndMattress.png',
                  () {
                nextPage;
              }),
            ],
          ),
        ],
      ),
    );
  }
}
