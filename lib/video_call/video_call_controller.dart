import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class VideoCallController extends GetxController {
  String appId = "0efec5e57b8f47dabffb86ed5e5a3d5d";
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

  late RtcEngine agoraEngine;
  int remoteUid = 0;
  Future<void> setupVideoSDKEngine() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .get()
        .then((value) {
      remoteUid = value.data()!['remoteid'];
    });

    String url = '$serverUrl/rtc/$channelName/1/uid/$currentUserId/?expiry=300';
    final response = await http.get(Uri.parse(url));
    newToken = jsonDecode(response.body)["rtcToken"];
    print(newToken);
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();

    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    agoraEngine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        Get.snackbar("title", "onJoinChannelSuccess");
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

    await agoraEngine.leaveChannel();
    isJoined = false;

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
