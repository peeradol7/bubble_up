import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/View/home_page/profile_page/widget/button_widget.dart';
import 'package:thammasat/View/home_page/select_service_widget/menu_bar_widget.dart';
import 'package:thammasat/app_routes.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final AuthController authController = Get.find<AuthController>();
  final ButtonWidget buttonWidget = ButtonWidget();
  late Future<Map<String, String>?> userData;

  @override
  void initState() {
    super.initState();
    userData = authController.loadUserData();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Confirm Logout',
              style: TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to log out?',
              style: TextStyle(color: Colors.black87)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                authController.logoutController();
                context.go(AppRoutes.landingPage);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF01B9E4),
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder<Map<String, String>?>(
              future: userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data != null) {
                  final displayName = snapshot.data!['name'] ?? 'Guest';
                  authController.name.value = displayName;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[200],
                          child: const Icon(Icons.person),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authController.name.value,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .push(AppRoutes.editPersonDataPage);
                                    },
                                    child: const Text(
                                      'แก้ไขข้อมูลส่วนตัว',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('No data available.'));
                }
              },
            ),
            Expanded(
              child: ListView(
                children: [
                  buttonWidget.buildMenuItem('My Address', () {
                    context.push(AppRoutes.editAddressPage);
                  }),
                  buttonWidget.buildMenuItem('Setting', () {
                    context.push(AppRoutes.settingPage);
                  }),
                  buttonWidget.buildMenuItem('Logout', () {
                    _showLogoutDialog();
                  }),
                ],
              ),
            ),
            MenuBarWidget(),
          ],
        ),
      ),
    );
  }
}
