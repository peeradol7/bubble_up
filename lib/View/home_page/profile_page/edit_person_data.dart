import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:thammasat/Controller/auth_controller.dart';
import 'package:thammasat/View/home_page/profile_page/widget/edit_data_preson_widget.dart';

class EditPersonData extends StatelessWidget {
  EditPersonData({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AuthController userController = Get.find<AuthController>();
    final EditDataPresonWidget edit = EditDataPresonWidget();

    return Obx(() {
      nameController.text = userController.userModel.value?.displayName ?? '';
      phoneController.text = userController.userModel.value?.phoneNumber ?? '';
      passwordController.text = userController.userModel.value?.password ?? '';

      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'edit data',
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 30),
                    edit.buildTextField(
                      controller: nameController,
                      label: 'Display name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    edit.buildTextField(
                      controller: passwordController,
                      label: 'password',
                      icon: Icons.lock_outline,
                    ),
                    const SizedBox(height: 16),
                    edit.buildTextField(
                      controller: phoneController,
                      label: 'Phone number',
                      icon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final updatedData = {
                              'name': nameController.text,
                              'password': passwordController.text,
                              'phoneNumber': phoneController.text,
                            };

                            await userController.updateUserData(updatedData);
                            userController.loadUserData();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('อัพเดทข้อมูลเรียบร้อยแล้ว'),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              context.pop();
                            }
                          } catch (e) {
                            if (context.mounted) {
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
                      child: const Text(
                        'บันทึกข้อมูล',
                        style: TextStyle(
                          color: Colors.white,
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
