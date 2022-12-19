import 'package:agora_ui_kit/chats/chat_controlller.dart';
import 'package:agora_ui_kit/chats/chat_screen.dart';
import 'package:agora_ui_kit/chats/models/remote_user_model.dart';
import 'package:agora_ui_kit/chats/search_screen.dart';
import 'package:agora_ui_kit/utils/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecentChatScreen extends StatelessWidget {
  const RecentChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.put(ChatController());

    return Scaffold(
        backgroundColor: ColorsConstant.backgroundColor,
        appBar: AppBar(
          backgroundColor: ColorsConstant.forebackgroundColor,
          title: const Text("Recent Chats"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                await controller.fetchAllUsers();
                controller.searchedUsers.clear();
                Get.to(() => const ChatSearchScreen());
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatRoom")
              .where("users", arrayContains: controller.currentUser.email)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  collectionSnapshot) {
            if (collectionSnapshot.hasData) {
              return ListView(
                children: collectionSnapshot.data!.docs
                    .map((DocumentSnapshot<Map<String, dynamic>> document) {
                  Map docData = document.data() as Map;
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(docData["users"][
                            docData["users"][0] == controller.currentUser.email
                                ? 1
                                : 0])
                        .get(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          padding: const EdgeInsets.only(
                              top: 10, right: 15, left: 15),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.red,
                            ),
                            tileColor: ColorsConstant.forebackgroundColor,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.grey[600]!,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            title: Text(
                              snapshot.data["name"],
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              docData["lastMessage"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              controller.remoteUser = RemoteUser(
                                id: snapshot.data["id"],
                                name: snapshot.data["name"],
                                email: snapshot.data["email"],
                              );
                              controller.currentChatRoomId.value = document.id;
                              Get.to(() => const ChatHomeScreen());
                            },
                          ),
                        );
                      } else {
                        return const Center(child: SizedBox());
                      }
                    },
                  );
                }).toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
