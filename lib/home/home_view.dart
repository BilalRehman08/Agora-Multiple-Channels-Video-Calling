import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/custom_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstant.forebackgroundColor,
        title: const Center(
          child: Text(
            "ALFGROWTH",
            style: TextStyle(
              letterSpacing: 4,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
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
                  onPressed: () {},
                  height: 0.3,
                  width: 0.225,
                ),
                buttonCard(
                  text: "CHAT",
                  icon: Icons.chat,
                  onPressed: () {},
                  height: 0.3,
                  width: 0.225,
                ),
                buttonCard(
                  text: "FOOD/ACTIVITY\nRECORD",
                  icon: Icons.dataset,
                  onPressed: () {},
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
