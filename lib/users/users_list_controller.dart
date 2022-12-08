import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UsersListController extends GetxController {
  final RxList users = [].obs;
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  // @override
  // void onInit() {
  //   super.onInit();

  // }

}
