import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Message {
  String? uid;
  String senderEmail;
  String content;
  DateTime time;
  bool isRead;

  Message(
      {required this.senderEmail,
      required this.content,
      required this.time,
      required this.isRead,
      this.uid});

  Message.fromJson(Map<String, dynamic> json)
      : senderEmail = json['senderEmail'],
        content = json['content'],
        time = DateTime.parse(json['time']),
        isRead = json['isRead'];

  Map<String, dynamic> toJson() => {
        'senderEmail': senderEmail,
        'content': content,
        'time': time.toIso8601String(),
        'isRead': isRead,
      };

  Future<void> updateReadStatus(
      RxString currentChatRoomId, String docID) async {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(currentChatRoomId.value)
        .collection("chats")
        .doc(docID)
        .update({"isRead": true});
  }
}
