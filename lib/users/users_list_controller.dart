import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UsersListController extends GetxController {
  User currentUser = FirebaseAuth.instance.currentUser!;
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  int currentUserId = 0;
  // @override
  // void onInit() {
  //   super.onInit();

  // }

}
