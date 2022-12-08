import 'package:agora_ui_kit/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController loginController =
        Get.isRegistered() ? Get.find() : Get.put(LoginController());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: Get.width * 0.6,
              child: TextField(
                controller: loginController.emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
            ),
            SizedBox(
              width: Get.width * 0.6,
              child: TextField(
                controller: loginController.passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                loginController.loginUser();
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(const LoginView());
              },
              child: const Text('Sign Up Page'),
            ),
          ],
        ),
      ),
    );
  }
}
