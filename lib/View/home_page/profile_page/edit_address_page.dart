import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/auth_controller.dart';
import '../../../Service/auth_service.dart';

class EditAddressPage extends StatelessWidget {
  EditAddressPage({super.key});

  final TextEditingController addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AuthController userController = Get.find<AuthController>();

    return Obx(() {
      final String currentAddress =
          userController.userModel.value?.address ?? '';
      addressController.text = currentAddress;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            currentAddress.isEmpty ? 'เพิ่มที่อยู่' : 'แก้ไขที่อยู่',
            style: const TextStyle(
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // ไอคอนและข้อความแสดงสถานะ
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 64,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentAddress.isEmpty
                                ? 'เพิ่มที่อยู่ของคุณ'
                                : 'ที่อยู่ปัจจุบันของคุณ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // ฟอร์มกรอกที่อยู่
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'ที่อยู่',
                        hintText: 'กรุณากรอกที่อยู่ของคุณ',
                        prefixIcon: const Icon(Icons.home_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกที่อยู่';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    // ปุ่มบันทึก
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final updatedData = {
                              'address': addressController.text.trim(),
                            };

                            final authService = AuthService();
                            await authService.updateUserData(updatedData);

                            userController.loadUserData();

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('บันทึกที่อยู่เรียบร้อยแล้ว'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // กลับไปหน้าก่อนหน้า
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              // แสดงข้อความเมื่อเกิดข้อผิดพลาด
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('เกิดข้อผิดพลาด: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        currentAddress.isEmpty
                            ? 'เพิ่มที่อยู่'
                            : 'บันทึกที่อยู่',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
