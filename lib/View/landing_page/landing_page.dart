import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/Controller/slide_controller.dart';
import 'package:thammasat/app_routes.dart';

import '../../Service/shared_preferenes_service.dart';
import 'home_button_widget.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final SlideController controller = Get.find<SlideController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: authController.loadUserDataInitState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data == true) {
            SharedPreferencesService.getInstance().then((prefs) {
              final userData = prefs.getUserData();
              final userRole = userData['role'];

              if (userRole == 'customer') {
                Future.delayed(Duration.zero, () {
                  context.go(AppRoutes.homePage);
                });
              } else if (userRole == 'Rider') {
                Future.delayed(Duration.zero, () {
                  context.go(AppRoutes.riderHomePage);
                });
              }
            });
          }
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Expanded(
                      child: PageView.builder(
                        onPageChanged: (index) =>
                            controller.currentIndex.value = index,
                        itemCount: controller.titles.length,
                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 02),
                                  child: Image.asset(
                                    controller.images[index],
                                    height: 230,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 50),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    controller.titles[index],
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Text(
                                    controller.message[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      controller.titles.length,
                                      (index) => Obx(
                                        () => Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                controller.currentIndex.value ==
                                                        index
                                                    ? Colors.blue
                                                    : Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 0,
                        top: MediaQuery.of(context).viewInsets.bottom > 0
                            ? 0
                            : 20,
                      ),
                      child: HomeButtonWidget(),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
