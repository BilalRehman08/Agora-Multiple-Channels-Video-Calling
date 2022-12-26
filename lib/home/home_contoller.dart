import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  User currentUser = FirebaseAuth.instance.currentUser!;
  var currentUserName = '';

  getUserDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .get()
        .then((value) {
      currentUserName = value.data()!['name'];
    });
    print(currentUserName);
    update();
  }
}
