import 'package:agora_ui_kit/activity/activity_record.dart';
import 'package:agora_ui_kit/activity/activity_users_view.dart';
import 'package:agora_ui_kit/chats/recent_chat_screen.dart';
import 'package:agora_ui_kit/consent_permission/consent_permission_view.dart';
import 'package:agora_ui_kit/home/home_contoller.dart';
import 'package:agora_ui_kit/widgets/custom_appbar.dart';
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
              preferredSize: Size.fromHeight(50),
              child: CustomAppBar(
                title: data["role"],
              ),
            ),
            backgroundColor: ColorsConstant.backgroundColor,
            drawer: const CustomDrawer(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      data["modules"]["video"]
                          ? data["role"] != "Family"
                              ? buttonCard(
                                  text: "VIDEO\nMONITORING",
                                  icon: Icons.video_call,
                                  onPressed: () {
                                    Get.to(const UsersListView());
                                  },
                                  height: 0.3,
                                  width: 0.225,
                                )
                              : StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("users")
                                      .where("id", isEqualTo: data["patientId"])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return snapshot.data!.docs[0]["modules"]
                                              ["video"]
                                          ? buttonCard(
                                              text: "VIDEO\nMONITORING",
                                              icon: Icons.video_call,
                                              onPressed: () {
                                                Get.to(const UsersListView());
                                              },
                                              height: 0.3,
                                              width: 0.225,
                                            )
                                          : const SizedBox();
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                )
                          : const SizedBox(),
                      data["modules"]["chat"]
                          ? buttonCard(
                              text: "CHAT",
                              icon: Icons.chat,
                              onPressed: () {
                                Get.to(const RecentChatScreen());
                              },
                              height: 0.3,
                              width: 0.225,
                            )
                          : const SizedBox(),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      data["modules"]["patient_record"]
                          ? buttonCard(
                              text: "FOOD/ACTIVITY\nRECORD",
                              icon: Icons.dataset,
                              onPressed: () {
                                if (data["role"] == "Staff") {
                                  Get.to(ActivityView(
                                      facilityId: data["facilityId"]));
                                } else {
                                  if (data["role"] == "Family") {
                                    Get.to(ActivtyRecord(
                                        userEmail: data["patientEmail"]));
                                  } else if (data["role"] == "Patient") {
                                    Get.to(ActivtyRecord(
                                        userEmail: data["email"]));
                                  }
                                }
                              },
                              height: 0.3,
                              width: 0.225,
                            )
                          : const SizedBox(),
                      data["modules"]["patient_vitals"]
                          ? buttonCard(
                              icon: Icons.medical_services,
                              text: "RECORD PATIENTS\nVITALS",
                              onPressed: () {},
                              height: 0.3,
                              width: 0.225,
                            )
                          : const SizedBox(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      data["modules"]["role_management"]
                          ? buttonCard(
                              icon: Icons.medical_services,
                              text: "Family/Patient Consent\nPermission",
                              onPressed: () {
                                Get.to(ConsentPermissionView(
                                    facilityId: data["facilityId"]));
                              },
                              height: 0.3,
                              width: 0.225,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

buttonCard({
  required String text,
  required onPressed,
  required icon,
  required num height,
  required num width,
}) {
  return InkWell(
    onTap: onPressed,
    child: Card(
      color: ColorsConstant.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 15,
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 40),
        width: Get.width * width,
        height: Get.height * height,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: ColorsConstant.forebackgroundColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  letterSpacing: 1,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}
