import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_ui_kit/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class VideoCallController extends GetxController {
  String serverUrl =
      "https://agora-token-service-production-a171.up.railway.app"; // The base URL to your token server, for example "https://agora-token-service-production-92ff.up.railway.app"
  String newToken = "";
  User currentUser = FirebaseAuth.instance.currentUser!;
  int currentUserId = 0;
  bool isJoined = false;
  String channelName = '';

  String remoteUserEmail = '';
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  int remoteUid = 0;
  Future<void> setupVideoSDKEngine() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .get()
        .then((value) {
      remoteUid = value.data()!['remoteid'];
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .get()
        .then((value) {
      channelName = value.data()!['channelName'];
    });

    String url = '$serverUrl/rtc/$channelName/1/uid/$currentUserId/?expiry=300';
    final response = await http.get(Uri.parse(url));
    newToken = jsonDecode(response.body)["rtcToken"];
    print(newToken);
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine

    await agoraEngine.enableVideo();

    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    agoraEngine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        // Get.snackbar("title", "onJoinChannelSuccess");
        isJoined = true;
        update();
      },
    ));
    await agoraEngine.joinChannel(
      token: newToken,
      channelId: channelName,
      uid: currentUserId,
      options: options,
    );
    // Register the event handler
  }

  void leave() async {
    Get.snackbar("title", "onLeave");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .get()
        .then((value) {
      remoteUserEmail = value.data()!['remoteemail'];
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .update({
      'remoteemail': '',
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(remoteUserEmail)
        .update({
      'remoteemail': '',
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .update({
      'remoteid': 0,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(remoteUserEmail)
        .update({
      'remoteid': 0,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .update({
      'channelName': '',
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(remoteUserEmail)
        .update({
      'channelName': '',
    });

    await agoraEngine.leaveChannel();
    isJoined = false;
    // remoteUid = null;
    // // channelName = '';
    update();
  }

  // @override
  // void onClose() async {
  //   Get.snackbar("title", "onClose");
  //   await agoraEngine.leaveChannel();
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currentUser.email)
  //       .get()
  //       .then((value) {
  //     remoteUserEmail = value.data()!['remoteemail'];
  //   });
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currentUser.email)
  //       .update({
  //     'channelName': '',
  //   });

  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(remoteUserEmail)
  //       .update({
  //     'channelName': '',
  //   });
  //   super.onClose();
  // }
}
