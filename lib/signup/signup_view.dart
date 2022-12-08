import 'package:agora_ui_kit/login/login_view.dart';
import 'package:agora_ui_kit/signup/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    SignUpController signUpController =
        Get.isRegistered() ? Get.find() : Get.put(SignUpController());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: Get.width * 0.6,
              child: TextField(
                controller: signUpController.nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
              ),
            ),
            SizedBox(
              width: Get.width * 0.6,
              child: TextField(
                controller: signUpController.emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
            ),
            SizedBox(
              width: Get.width * 0.6,
              child: TextField(
                controller: signUpController.passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                signUpController.signUpUser();
              },
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(const LoginView());
              },
              child: const Text('Login Page'),
            ),
          ],
        ),
      ),
    );
  }
}
