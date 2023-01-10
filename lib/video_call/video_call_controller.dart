import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_ui_kit/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class VideoCallController extends GetxController {
  bool isMicrophoneMuted = false;
  String serverUrl =
      "http://agora-token-service-production-3319.up.railway.app"; // The base URL to your token server, for example "https://agora-token-service-production-92ff.up.railway.app"
  String newToken = "";
  User get currentUser => FirebaseAuth.instance.currentUser!;
  int currentUserId = 0;
  bool isJoined = false;
  String channelName = '';

  String remoteUserEmail = '';

  String videoPermissionInfo = "";

  Stream<QuerySnapshot> getUsersStream(
      {required String role,
      required String facilityId,
      required int? patientId}) {
    Query query = FirebaseFirestore.instance.collection('users');
    if (role == "Family") {
      query = query.where("id", isEqualTo: patientId!);
      videoPermissionInfo = "You can only call patient of Id $patientId";
    } else if (role == "Staff") {
      query = query
          .where("facilityId", isEqualTo: facilityId)
          .where("role", isEqualTo: "Patient");
      videoPermissionInfo =
          "You can only call patients of facility Id $facilityId";
    } else if (role == "Patient") {
      query = query
          .where("facilityId", isEqualTo: facilityId)
          .where("role", isEqualTo: "Staff");
      videoPermissionInfo =
          "You can only call your family members and staff of facility Id $facilityId";
    }
    return query.snapshots();
  }

  Stream<QuerySnapshot<Object?>> getFamilyMembersStream(
      {required int patientId}) {
    Query query = FirebaseFirestore.instance.collection('users');
    query = query.where("patientId", isEqualTo: patientId);
    return query.snapshots();
  }

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

  microphoneMute() async {
    if (isMicrophoneMuted) {
      await agoraEngine.muteLocalAudioStream(false);
      isMicrophoneMuted = false;
      update();
    } else {
      await agoraEngine.muteLocalAudioStream(true);
      isMicrophoneMuted = true;
      update();
    }
  }

  turnCamera() async {
    await agoraEngine.switchCamera();
    update();
  }

  void leave() async {
    // Get.snackbar("title", "onLeave");

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

  @override
  void onClose() {
    if (isJoined) {
      leave();
      isJoined = false;
    }
    super.onClose();
  }
}
