import 'package:agora_ui_kit/activity/activity_record.dart';
import 'package:agora_ui_kit/activity/activity_users_view.dart';
import 'package:agora_ui_kit/chats/recent_chat_screen.dart';
import 'package:agora_ui_kit/consent_permission/consent_permission_view.dart';
import 'package:agora_ui_kit/home/home_contoller.dart';
import 'package:agora_ui_kit/widgets/custom_appbar.dart';
import 'package:agora_ui_kit/widgets/custom_button.dart';
import 'package:agora_ui_kit/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../users/users_list_view.dart';
import '../utils/custom_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(homeController.currentUser.email)
            .get(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: ColorsConstant.backgroundColor,
              body: const Center(
                child: Text("Something went wrong"),
              ),
            );
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Scaffold(
              backgroundColor: ColorsConstant.backgroundColor,
              body: const Center(
                child: Text("Document does not exist"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: ColorsConstant.backgroundColor,
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          Map<String, dynamic> data = snapshot.data!.data()!;
          return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: CustomAppBar(
                  title: data["role"],
                ),
              ),
              backgroundColor: ColorsConstant.backgroundColor,
              drawer: const CustomDrawer(),
              body: homeController.getHomePage(data));
        });
  }
}
