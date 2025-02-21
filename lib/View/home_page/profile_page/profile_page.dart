import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/View/home_page/profile_page/widget/button_widget.dart';
import 'package:thammasat/View/home_page/select_service_widget/menu_bar_widget.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final AuthController authController = Get.put(AuthController());
  final ButtonWidget buttonWidget = ButtonWidget();
  late Future<Map<String, String>?> userData;

  @override
  void initState() {
    super.initState();
    userData = authController.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header
            FutureBuilder<Map<String, String>?>(
              future: userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While data is being fetched
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // If an error occurs
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data != null) {
                  // Data is successfully fetched
                  final userName = snapshot.data!['name'] ?? 'Guest';

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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'แก้ไขข้อมูลส่วนตัว',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('No data available.'));
                }
              },
            ),

            // Menu Items
            Expanded(
              child: ListView(
                children: [
                  buttonWidget.buildMenuItem('My Address', () {}),
                  buttonWidget.buildMenuItem('Setting', () {}),
                  buttonWidget.buildMenuItem('Logout', () {}),
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
