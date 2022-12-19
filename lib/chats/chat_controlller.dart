import 'package:agora_ui_kit/chats/models/message_model.dart';
import 'package:agora_ui_kit/chats/models/remote_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RemoteUser? remoteUser;
  RxString currentChatRoomId = "".obs;
  TextEditingController chatMessageController = TextEditingController();
  User currentUser = FirebaseAuth.instance.currentUser!;
  List<RemoteUser> allUsers = [];
  RxList<RemoteUser> searchedUsers = <RemoteUser>[].obs;

  sendMessage() async {
    if (chatMessageController.text.isNotEmpty) {
      Message message = Message(
        senderEmail: currentUser.email!,
        content: chatMessageController.text,
        time: DateTime.now(),
        isRead: false,
      );
      chatMessageController.clear();

      // if chat room id is empty then create a new chat room
      if (currentChatRoomId.isEmpty) {
        await FirebaseFirestore.instance.collection("chatRoom").add({
          "users": [currentUser.email, remoteUser!.email],
          "lastMessage": message.content
        }).then((value) {
          currentChatRoomId.value = value.id;
        });
      }
      // add message to chat room
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(currentChatRoomId.value)
          .collection("chats")
          .add(message.toJson());

      // update last message in chat room
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(currentChatRoomId.value)
          .update({"lastMessage": message.content});
    }
  }

  Future<void> getChatRoomIDIfExist() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("chatRoom")
        .where("users", arrayContains: currentUser.email)
        .get();
    for (DocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      Map docData = document.data() as Map;
      if (docData["users"][0] == remoteUser!.email ||
          docData["users"][1] == remoteUser!.email) {
        currentChatRoomId.value = document.id;
        break;
      }
    }
  }

  Future<void> fetchAllUsers() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("users")
        .where("email", isNotEqualTo: currentUser.email)
        .get();
    for (DocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      Map docData = document.data() as Map;
      RemoteUser remoteUser = RemoteUser(
          id: docData["id"], name: docData["name"], email: docData["email"]);
      allUsers.add(remoteUser);
    }
  }

  void searchUser(String value) {
    if (value.isNotEmpty) {
      searchedUsers.value = allUsers
          .where((element) =>
              element.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      searchedUsers.value = [];
    }
  }
}
