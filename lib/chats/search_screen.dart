import 'package:agora_ui_kit/chats/chat_controlller.dart';
import 'package:agora_ui_kit/chats/chat_screen.dart';
import 'package:agora_ui_kit/chats/models/remote_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatSearchScreen extends StatelessWidget {
  const ChatSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController controller =
        Get.isRegistered() ? Get.find() : Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: Get.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search User",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              onChanged: (String value) {
                controller.searchUser(value);
              },
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.searchedUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(controller.searchedUsers[index].name),
                    subtitle: Text(controller.searchedUsers[index].email),
                    onTap: () {
                      controller.remoteUser = controller.searchedUsers[index];
                      Get.to(() => const ChatHomeScreen());
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
