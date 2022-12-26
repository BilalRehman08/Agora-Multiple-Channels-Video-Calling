import 'package:agora_ui_kit/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  loginUser() async {
    try {
      if (kDebugMode) {
        emailController.text = 'bilal@gmail.com';
        passwordController.text = 'bilal123';
      }
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Get.to(const HomeView());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("Error", 'No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Error", 'Wrong password provided for that user.');
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
