import 'package:agora_ui_kit/home/home_view.dart';
import 'package:agora_ui_kit/login/login_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController facilityController = TextEditingController();
  TextEditingController patientIdController = TextEditingController();
  String patientEmail = "";
  List<String> rolesList = ["Manager", "Staff", "Patient", "Family"];
  RxBool isPasswordNotVisible = true.obs;
  RxString selectedRole = "Patient".obs;
  Map modules = {};

  // function to create sample users
  createSampleUsers() async {
    for (String role in rolesList) {
      for (var i = 1; i <= 4; i++) {
        nameController.text = '$role$i';
        emailController.text = '${role.toLowerCase()}$i@gmail.com';
        passwordController.text = '${role.toLowerCase()}$i';
        facilityController.text = '${(i % 2) + 1}';
        selectedRole.value = role;
        if (role == "Family") {
          patientIdController.text = '${i + 8}';
        }
        await addUser();
      }
    }
  }

  signUpUser() async {
    try {
      // if (kDebugMode) {
      // nameController.text = 'Family1';
      // emailController.text = 'family1@gmail.com';
      // passwordController.text = 'family1';
      // facilityController.text = '2';
      // selectedRole.value = "Family";
      // patientIdController.text = '13';
      // }
      await addUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("Error", 'The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Error", 'The account already exists for that email.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future addUser() async {
    if (selectedRole.value == "Family") {
      QuerySnapshot temp = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: int.parse(patientIdController.text))
          .get();
      if (temp.docs.isEmpty) {
        Get.snackbar("Error", "Invalid Patient ID");
        return;
      }
      patientEmail = (temp.docs[0].data()! as Map)['email'];
    }
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    if (selectedRole.value == "Patient") {
      modules = {
        "chat": false,
        "patient_record": true,
        "patient_vitals": true,
        "role_management": false,
        "video": true
      };
    } else if (selectedRole.value == "Family") {
      modules = {
        "chat": true,
        "patient_record": true,
        "patient_vitals": true,
        "role_management": false,
        "video": true
      };
    } else if (selectedRole.value == "Staff") {
      modules = {
        "chat": true,
        "patient_record": true,
        "patient_vitals": true,
        "role_management": false,
        "video": true
      };
    } else if (selectedRole.value == "Manager") {
      modules = {
        "chat": true,
        "patient_record": false,
        "patient_vitals": false,
        "role_management": true,
        "video": false
      };
    }
    DocumentSnapshot temp =
        await FirebaseFirestore.instance.collection('temp').doc('temp').get();
    Map tempMap = temp.data() as Map;
    int tempID = tempMap['count'] + 1;

    await FirebaseFirestore.instance.collection('temp').doc('temp').update({
      'count': tempID,
    });

    // Call the user's CollectionReference to add a new user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(emailController.text)
        .set({
          'name': nameController.text,
          'email': emailController.text,
          'role': selectedRole.value,
          'facilityId': facilityController.text,
          'id': tempID,
          'channelName': '',
          'patientId': patientIdController.text.isNotEmpty
              ? int.parse(patientIdController.text)
              : 0,
          'patientEmail': patientEmail,
          'remoteid': 0,
          'remoteemail': '',
          'activityrecord': [],
          'modules': modules
          // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    facilityController.clear();
    patientIdController.clear();
    selectedRole.value = 'Patient';
    Get.offAll(const HomeView());
  }
}
