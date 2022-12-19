import 'package:agora_ui_kit/chats/recent_chat_screen.dart';
import 'package:agora_ui_kit/users/users_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectionMsgVideo extends StatelessWidget {
  const SelectionMsgVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          InkWell(
            onTap: () {
              Get.to(() => const RecentChatScreen());
            },
            child: const SizedBox(
              height: 200,
              width: 200,
              child: Card(
                shape: RoundedRectangleBorder(),
                child: Center(child: Text("Start Chat")),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const UsersListView());
            },
            child: const SizedBox(
              height: 200,
              width: 200,
              child: Card(
                shape: RoundedRectangleBorder(),
                child: Center(child: Text("Start Chat")),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
