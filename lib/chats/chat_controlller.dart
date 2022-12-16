import 'package:agora_ui_kit/chats/models/message_model.dart';
import 'package:agora_ui_kit/chats/models/remote_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RemoteUser? remoteUser;
  String? currentChatRoomId;
  TextEditingController chatMessageController = TextEditingController();
  User currentUser = FirebaseAuth.instance.currentUser!;

  sendMessage() {
    if (chatMessageController.text.isNotEmpty) {
      Message message = Message(
          senderEmail: currentUser.email!,
          content: chatMessageController.text,
          time: DateTime.now());
      chatMessageController.clear();
      FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(currentChatRoomId)
          .collection("chats")
          .add(message.toJson());
      FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(currentChatRoomId)
          .update({"lastMessage": message.content});
    }
  }
}
