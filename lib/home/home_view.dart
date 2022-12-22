import 'package:agora_ui_kit/activity/activity_users_view.dart';
import 'package:agora_ui_kit/chats/recent_chat_screen.dart';
import 'package:agora_ui_kit/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../users/users_list_view.dart';
import '../utils/custom_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          title: "ALFGROWTH",
        ),
      ),
      backgroundColor: ColorsConstant.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonCard(
                  text: "VIDEO\nMONITORING",
                  icon: Icons.video_call,
                  onPressed: () {
                    Get.to(const UsersListView());
                  },
                  height: 0.3,
                  width: 0.225,
                ),
                buttonCard(
                  text: "CHAT",
                  icon: Icons.chat,
                  onPressed: () {
                    Get.to(const RecentChatScreen());
                  },
                  height: 0.3,
                  width: 0.225,
                ),
                buttonCard(
                  text: "FOOD/ACTIVITY\nRECORD",
                  icon: Icons.dataset,
                  onPressed: () {
                    Get.to(const ActivityView());
                  },
                  height: 0.3,
                  width: 0.225,
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonCard(
                  icon: Icons.medical_services,
                  text: "RECORD PATIENTS\nVITALS",
                  onPressed: () {},
                  height: 0.3,
                  width: 0.225,
                ),
                buttonCard(
                  icon: Icons.person,
                  text: "PROFILE",
                  onPressed: () {},
                  height: 0.3,
                  width: 0.225,
                ),
                buttonCard(
                  icon: Icons.settings,
                  text: "SETTINGS",
                  onPressed: () {},
                  height: 0.3,
                  width: 0.225,
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
