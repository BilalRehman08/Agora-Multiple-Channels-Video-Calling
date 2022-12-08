import 'package:agora_ui_kit/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController loginController =
        Get.isRegistered() ? Get.find() : Get.put(LoginController());
    return Scaffold();
  }
}
