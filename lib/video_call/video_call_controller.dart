import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallController extends GetxController {
  String appId = "0efec5e57b8f47dabffb86ed5e5a3d5d";
  String serverUrl =
      "https://agora-token-service-production-a171.up.railway.app"; // The base URL to your token server, for example "https://agora-token-service-production-92ff.up.railway.app"

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
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .get()
        .then((value) {
      remoteUid = value.data()!['remoteid'];
    });
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
      token:
          "007eJxTYHBoylka0r3/e86zVcYP7l1XXb6L+cdXNx677W9Ulyu1uV1WYDBITUtNNk01NU+ySDMxT0lMSktLsjBLTQEKJRqnmKYUPpiW3BDIyPBhjykrIwMEgvhMDIbGDAwA9BEiAQ==",
      channelId: "13",
      uid: currentUserId,
      options: options,
    );
    // Register the event handler
  }

  void leave() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Get.snackbar("title", "onLeave");
        await agoraEngine.leaveChannel();
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

        isJoined = false;
        // remoteUid = null;
        // // channelName = '';
        update();
      }
    } on SocketException catch (_) {
      Get.snackbar("Error", "Internet Conencetion Issue");
    }
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
