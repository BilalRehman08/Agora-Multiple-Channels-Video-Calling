import 'package:agora_ui_kit/chats/chat_controlller.dart';
import 'package:agora_ui_kit/chats/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatHomeScreen extends StatelessWidget {
  const ChatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController controller =
        Get.isRegistered() ? Get.find() : Get.put(ChatController());
    return Scaffold(
        persistentFooterButtons: [
          Row(
            children: [
              const Icon(Icons.camera_alt_outlined, color: Colors.yellow),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.yellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextFormField(
                    controller: controller.chatMessageController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20, top: 10),
                      border: InputBorder.none,
                      hintText: "Write a comment",
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            controller.sendMessage();
                          },
                          icon: const Icon(Icons.send_outlined,
                              color: Colors.yellow)),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(controller.remoteUser!.name),
        ),
        body: Scaffold(
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatRoom")
                .doc(controller.currentChatRoomId)
                .collection("chats")
                .orderBy("time", descending: true)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
                  child: ListView(
                    reverse: true,
                    children: snapshot.data!.docs
                        .map<Widget>((QueryDocumentSnapshot documentSnapshot) {
                      Message message = Message.fromJson(
                          documentSnapshot.data() as Map<String, dynamic>);
                      if (message.senderEmail == controller.currentUser.email) {
                        return myChatContainer(message);
                      } else {
                        return otherPeopleChatContainer(message);
                      }
                    }).toList(),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }

  myChatContainer(Message message) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  constraints: BoxConstraints(
                    maxWidth: Get.width * 0.6,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(24),
                        topLeft: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(4),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      message.content,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${message.time.hour}:${message.time.minute} ${message.time.hour > 12 ? "PM" : "AM"}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  otherPeopleChatContainer(Message message) {
    return Container(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            constraints: BoxConstraints(
              maxWidth: Get.width * 0.6,
            ),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(24),
                )),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Text(
                message.content,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${message.time.hour}:${message.time.minute} ${message.time.hour > 12 ? "PM" : "AM"}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
