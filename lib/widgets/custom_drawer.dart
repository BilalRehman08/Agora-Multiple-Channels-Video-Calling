import 'package:agora_ui_kit/home/home_contoller.dart';
import 'package:agora_ui_kit/login/login_controller.dart';
import 'package:agora_ui_kit/login/login_view.dart';
import 'package:agora_ui_kit/utils/custom_colors.dart';
import 'package:agora_ui_kit/video_call/video_call_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.isRegistered<LoginController>()
        ? Get.find<LoginController>()
        : Get.put(LoginController());

    VideoCallController videoCallController =
        Get.isRegistered<VideoCallController>()
            ? Get.find<VideoCallController>()
            : Get.put(VideoCallController());

    HomeController homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    return Drawer(
      backgroundColor: ColorsConstant.backgroundColor,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            accountName: GetBuilder<HomeController>(builder: (context) {
              return Text(
                homeController.currentUserName,
                style: const TextStyle(fontSize: 20),
              );
            }),
            accountEmail: Text(
              "${videoCallController.currentUser.email}",
              style: const TextStyle(fontSize: 15),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/person.png'),
            ),
          ),
          ListTile(
            title: const Text(
              'Settings',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            trailing: const Icon(Icons.settings, color: Colors.white),
            onTap: () {
              homeController.getUserDetails();
            },
          ),
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            trailing: const Icon(Icons.logout, color: Colors.white),
            onTap: () async {
              await loginController.signOut();
              Get.offAll(const LoginView());
            },
          ),
        ],
      ),
    );
  }
}
