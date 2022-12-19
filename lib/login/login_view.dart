import 'package:agora_ui_kit/login/login_controller.dart';
import 'package:agora_ui_kit/signup/signup_view.dart';
import 'package:agora_ui_kit/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/custom_colors.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController loginController =
        Get.isRegistered() ? Get.find() : Get.put(LoginController());
    return Scaffold(
      backgroundColor: ColorsConstant.backgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
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
                        const Text("Welcome Back !",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                        const Text("Login to Continue",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 30),
                        CustomTextField(
                          hintText: "Email",
                          icon: Icons.person_outline,
                          controller: loginController.emailController,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: "Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          controller: loginController.passwordController,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Forgot Password ?",
                                style: TextStyle(
                                    color: ColorsConstant.secondary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ],
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
                              // if (loginController
                              //         .emailController.text.isEmpty ||
                              //     loginController
                              //         .passwordController.text.isEmpty) {
                              //   Get.snackbar(
                              //     "Error",
                              //     "Please fill all fields",
                              //   );
                              // } else {
                              //   loginController.loginUser();
                              // }
                              loginController.loginUser();
                            },
                            child: Text("Login",
                                style: TextStyle(
                                    color: ColorsConstant.backgroundColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const SignUpView());
                          },
                          child: Text("Create a New Account",
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
