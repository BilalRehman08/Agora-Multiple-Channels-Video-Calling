import 'package:agora_ui_kit/login/login_view.dart';
import 'package:agora_ui_kit/signup/signup_controller.dart';
import 'package:agora_ui_kit/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/custom_colors.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    SignUpController signUpController =
        Get.isRegistered() ? Get.find() : Get.put(SignUpController());
    return Scaffold(
      backgroundColor: ColorsConstant.backgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Card(
                color: ColorsConstant.backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                elevation: 10,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    width: 500,
                    decoration: BoxDecoration(
                        color: ColorsConstant.forebackgroundColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Create New \nAccount",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 30),
                        CustomTextField(
                          hintText: "User Name",
                          icon: Icons.person_outline,
                          controller: signUpController.nameController,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: "Email",
                          icon: Icons.email_outlined,
                          controller: signUpController.emailController,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: "Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          controller: signUpController.passwordController,
                        ),
                        const SizedBox(height: 30),
                        Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorsConstant.yellow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () {
                              if (signUpController
                                      .nameController.text.isEmpty ||
                                  signUpController
                                      .emailController.text.isEmpty ||
                                  signUpController
                                      .passwordController.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Please fill all fields",
                                );
                              } else {
                                signUpController.signUpUser();
                              }
                            },
                            child: Text("Create",
                                style: TextStyle(
                                    color: ColorsConstant.backgroundColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Get.to(const LoginView());
                          },
                          child: Text("Login",
                              style: TextStyle(
                                  color: ColorsConstant.yellow,
                                  decoration: TextDecoration.underline,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
