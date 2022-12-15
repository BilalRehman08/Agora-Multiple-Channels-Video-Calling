import 'package:agora_ui_kit/chats/chat_controlller.dart';
import 'package:agora_ui_kit/chats/chat_screen.dart';
import 'package:agora_ui_kit/chats/models/remote_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class RecentChatScreen extends StatelessWidget {
  const RecentChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.put(ChatController());
    User currentUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(title: const Text("Chat Room")),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatRoom")
              .where("users", arrayContains: currentUser.email)
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
                        .doc(docData["users"]
                            [docData["users"][0] == currentUser.email ? 1 : 0])
                        .get(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListTile(
                          title: Text(snapshot.data["name"]),
                          subtitle: Text(docData["lastMessage"]),
                          onTap: (){
                            controller.remoteUser = RemoteUser(
                              id: snapshot.data["id"],
                              name: snapshot.data["name"],
                              email: snapshot.data["email"],
                            );
                            Get.to(()=>ChatHomeScreen());
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
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
