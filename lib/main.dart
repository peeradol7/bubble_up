import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/Controller/laundry_controller.dart';
import 'package:thammasat/Controller/menubar_controller.dart';
import 'package:thammasat/Controller/order_controller.dart';
import 'package:thammasat/Controller/position_controller.dart';
import 'package:thammasat/Controller/service_list_controller.dart';
import 'package:thammasat/Controller/slide_controller.dart';
import 'package:thammasat/app_routes.dart';

import 'Controller/location_controller.dart';
import 'Controller/notification_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(PositionController());
  Get.put(LocationController());
  Get.put(LaundryController());
  Get.put(AuthController());
  Get.put(MenuController());
  Get.put(MenuBarController());
  Get.put(ServiceListController());
  Get.put(SlideController());
  Get.put(OrderController());
  Get.put(NotificationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoutes().route,
      theme: ThemeData.fallback(),
    );
  }
}
