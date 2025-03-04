import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thammasat/Controller/notification_controller.dart';
import 'package:thammasat/app_routes.dart';

import '../../../Service/auth_service.dart';

class SettingPage extends StatefulWidget {
  SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final NotificationController notificationController =
      Get.find<NotificationController>();

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบบัญชี'),
          content: const Text(
              'คุณแน่ใจหรือไม่ที่จะลบบัญชีนี้? การดำเนินการนี้ไม่สามารถย้อนกลับได้'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'ลบบัญชี',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  final authService = AuthService();
                  await authService.deleteAccount();
                  context.pop(AppRoutes.landingPage);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('เกิดข้อผิดพลาด: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ตั้งค่า',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF01B9E4),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // การแจ้งเตือน
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.notifications,
                  color: Color(0xFF01B9E4),
                ),
                title: const Text(
                  'การแจ้งเตือน',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('เปิด/ปิดการแจ้งเตือนจากแอปพลิเคชัน'),
                trailing: FutureBuilder<bool>(
                  future: Permission.notification.isGranted,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Switch(
                        value: snapshot.data ?? false,
                        onChanged: (bool value) async {
                          if (value) {
                            await notificationController
                                .requestNotificationPermission();
                            openAppSettings();
                          } else {
                            await openAppSettings();
                          }
                        },
                        activeColor: const Color(0xFF01B9E4),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                title: const Text(
                  'ลบบัญชี',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('ลบบัญชีและข้อมูลทั้งหมดของคุณ'),
                onTap: () => _showDeleteConfirmation(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
