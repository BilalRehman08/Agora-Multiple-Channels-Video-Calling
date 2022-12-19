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
    return WillPopScope(
      onWillPop: () async {
        controller.currentChatRoomId.value = "";
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                controller.currentChatRoomId.value = "";
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text(controller.remoteUser!.name),
        ),
        body: Column(
          children: [
            Obx(() => controller.currentChatRoomId.isNotEmpty
                ? Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("chatRoom")
                          .doc(controller.currentChatRoomId.value)
                          .collection("chats")
                          .orderBy("time", descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasData) {
                          List<QueryDocumentSnapshot> docs =
                              snapshot.data!.docs;
                          return Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 20),
                              child: ListView.builder(
                                  reverse: true,
                                  itemCount: docs.length,
                                  itemBuilder: (context, index) {
                                    Message message = Message.fromJson(
                                        docs[index].data()
                                            as Map<String, dynamic>);
                                    message.uid = docs[index].id;
                                    if (message.senderEmail ==
                                        controller.currentUser.email) {
                                      return myChatContainer(message, index);
                                    } else {
                                      message.updateReadStatus(
                                          controller.currentChatRoomId,
                                          docs[index].id);
                                      return otherPeopleChatContainer(
                                          message, index);
                                    }
                                  }));
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  )
                : const Spacer()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 10),
                const Icon(Icons.camera_alt_outlined, color: Colors.black),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: Get.height * 0.17),
                      child: TextField(
                        maxLines: null,
                        controller: controller.chatMessageController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          border: InputBorder.none,
                          hintText: "Write a comment",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await controller.sendMessage();
                    },
                    icon: const Icon(Icons.send_outlined, color: Colors.black))
              ],
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  myChatContainer(Message message, index) {
    return Obx(() => Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                constraints: BoxConstraints(
                    maxWidth: Get.width * 0.8, minWidth: 90),
                decoration: BoxDecoration(
                    color: Colors.yellow.withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(4),
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    message.content,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 25,
                bottom: 3,
                child: Text(
                  "${message.time.hour}:${message.time.minute} ${message.time.hour > 12 ? "PM" : "AM"}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              Icon(Icons.done_all,
                  color: message.isRead ? Colors.blue : Colors.grey,
                  size: 20)
            ],
          ),
        ],
      ),
    ));
  }

  otherPeopleChatContainer(Message message, index) {
    return Obx(() => Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            constraints: BoxConstraints(
              maxWidth: Get.width * 0.8,
            ),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(20),
                )),
            child: Text(
              message.content,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
