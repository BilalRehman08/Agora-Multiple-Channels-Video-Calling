import 'package:agora_ui_kit/activity/activity_record.dart';
import 'package:agora_ui_kit/activity/activity_users_view.dart';
import 'package:agora_ui_kit/chats/recent_chat_screen.dart';
import 'package:agora_ui_kit/consent_permission/consent_permission_view.dart';
import 'package:agora_ui_kit/users/users_list_view.dart';
import 'package:agora_ui_kit/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Widget videoWidget = buttonCard(
    text: "VIDEO\nMONITORING",
    icon: Icons.video_call,
    onPressed: () {
      Get.to(const UsersListView());
    },
    height: 0.3,
    width: 0.225,
  );

  Widget patientVitalsWidget = buttonCard(
    icon: Icons.medical_services,
    text: "RECORD PATIENTS\nVITALS",
    onPressed: () {},
    height: 0.3,
    width: 0.225,
  );

  Widget patientConsentPermissionWidget(Map data) {
    return buttonCard(
      icon: Icons.medical_services,
      text: "Family/Patient Consent\nPermission",
      onPressed: () {
        Get.to(ConsentPermissionView(facilityId: data["facilityId"]));
      },
      height: 0.3,
      width: 0.225,
    );
  }

  Widget patientRecordWidget(Map data) {
    return buttonCard(
      text: "FOOD/ACTIVITY\nRECORD",
      icon: Icons.dataset,
      onPressed: () {
        if (data["role"] == "Staff") {
          Get.to(ActivityView(facilityId: data["facilityId"]));
        } else {
          if (data["role"] == "Family") {
            Get.to(ActivtyRecord(userEmail: data["patientEmail"]));
          } else if (data["role"] == "Patient") {
            Get.to(ActivtyRecord(userEmail: data["email"]));
          }
        }
      },
      height: 0.3,
      width: 0.225,
    );
  }

  Widget chatWidget = buttonCard(
    text: "CHAT",
    icon: Icons.chat,
    onPressed: () {
      Get.to(const RecentChatScreen());
    },
    height: 0.3,
    width: 0.225,
  );

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  User get currentUser => FirebaseAuth.instance.currentUser!;
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

  getHomePage(Map data) {
    List<Widget> childrens = [];

    // video module
    if (data["modules"]["video"]) {
      if (data["role"] != "Family") {
        childrens.add(videoWidget);
      } else {
        childrens.add(StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("id", isEqualTo: data["patientId"])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.docs[0]["modules"]["video"]
                  ? videoWidget
                  : const SizedBox();
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
      }
    }

    // chat module
    if (data["modules"]["chat"]) {
      childrens.add(chatWidget);
    }

    // patient record module
    if (data["modules"]["patient_record"]) {
      childrens.add(patientRecordWidget(data));
    }

    // patient vitals module
    if (data["modules"]["patient_vitals"]) {
      childrens.add(patientVitalsWidget);
    }

    // patient consent permission module
    if (data["modules"]["role_management"]) {
      childrens.add(patientConsentPermissionWidget(data));
    }

    // return modules
    if (childrens.isEmpty) {
      return const Center(
        child: Text("No modules available"),
      );
    } else if (childrens.length == 1) {
      return Center(
        child: childrens[0],
      );
    } else if (childrens.length == 2) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: childrens,
        ),
      );
    } else if (childrens.length == 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              childrens[0],
              childrens[1],
            ],
          ),
          childrens[2],
        ],
      );
    } else if (childrens.length == 4) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              childrens[0],
              childrens[1],
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              childrens[2],
              childrens[3],
            ],
          ),
        ],
      );
    } else if (childrens.length == 5) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              childrens[0],
              childrens[1],
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              childrens[2],
              childrens[3],
            ],
          ),
          childrens[4],
        ],
      );
    }
  }
}
