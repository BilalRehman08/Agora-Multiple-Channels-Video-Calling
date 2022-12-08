import 'package:agora_ui_kit/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signUpUser() async {
    try {
      await addUser();
      Get.to(const LoginView());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future addUser() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    DocumentSnapshot temp =
        await FirebaseFirestore.instance.collection('temp').doc('temp').get();
    Map tempMap = temp.data() as Map;
    int tempID = tempMap['count'] + 1;

    FirebaseFirestore.instance.collection('temp').doc('temp').update({
      'count': tempID,
    });

    // Call the user's CollectionReference to add a new user
    FirebaseFirestore.instance
        .collection('users')
        .doc(emailController.text)
        .set({
          'name': nameController.text, // John Doe
          'email': emailController.text, // Stokes and Sons
          'id': tempID, // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
