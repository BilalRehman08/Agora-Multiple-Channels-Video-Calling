import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class VideoCallController extends GetxController {
  String appId = "0efec5e57b8f47dabffb86ed5e5a3d5d";
  String serverUrl =
      "https://agora-token-service-production-a171.up.railway.app"; // The base URL to your token server, for example "https://agora-token-service-production-92ff.up.railway.app"
  int tokenExpireTime = 300; // Expire time in Seconds.
  bool isTokenExpiring = false; // Set to true when the token is about to expire

  String channelName = "";
  String token = "";
  final bool isHost = true;

  User currentUser = FirebaseAuth.instance.currentUser!;

  String remoteUserEmail = '';
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  int currentUserId = 0;
  // uid of the local user

  int? remoteUid; // uid of the remote user
  bool isJoined = false; // Indicates if the local user has joined the channel

  late RtcEngine agoraEngine;

  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  // To access the TextField

  Future<void> setupVideoSDKEngine({
    required int id,
    required String channelName,
    required int tokenRole,
  }) async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();
    await fetchToken(uid: id, channelName: channelName, tokenRole: tokenRole);
    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");

          isJoined = true;
          update();
        },
        onLeaveChannel: (connection, stats) {
          showMessage("Local user left the channel");
          isJoined = false;
          agoraEngine.leaveChannel();
          update();
        },
        onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
          showMessage("Remote user uid:$rUid joined the channel");

          remoteUid = rUid;
          update();
        },
        onUserOffline:
            (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
          showMessage("Remote user uid:$rUid left the channel");

          remoteUid = null;
          update();
        },
        onTokenPrivilegeWillExpire:
            (RtcConnection connection, String token) async {
          showMessage('Token expiring');
          isTokenExpiring = true;

          // fetch a new token when the current token is about to expire
          await agoraEngine.startPreview();

          // Set channel options including the client role and channel profile

          showMessage("Fetching token ...");

          await fetchToken(
              uid: id, channelName: channelName, tokenRole: tokenRole);
          update();
        },
      ),
    );
  }

  Future<void> fetchToken(
      {required int uid,
      required String channelName,
      required int tokenRole}) async {
    // Prepare the Url
    String url =
        '$serverUrl/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}/?expiry=${tokenExpireTime.toString()}';
    print(url);

    // Send the request
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      debugPrint('Token Received: $newToken');
      isJoined = true;
      update();
      // Use the token to join a channel or renew an expiring token
      setToken(newToken, uid);
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }

  void setToken(String newToken, int id) async {
    token = newToken;

    if (isTokenExpiring) {
      // Renew the token
      agoraEngine.renewToken(token);
      isTokenExpiring = false;
      showMessage("Token renewed");
    } else {
      // Join a channel.
      showMessage("Token received, joining a channel $channelName");

      // Set channel options including the client role and channel profile
      ChannelMediaOptions options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      );
      await agoraEngine.joinChannel(
        token: token,
        channelId: channelName,
        uid: id,
        options: options,
      );
    }
  }

  void leave() async {
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

    // isJoined = false;
    // remoteUid = null;
    // // channelName = '';
    // agoraEngine.leaveChannel();
    // Get.back();
    update();
  }

  @override
  void onClose() async {
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
    super.onClose();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   setupVideoSDKEngine();
  // }

// Clean up the resources when you leave
  // @override
  // void dispose() async {
  //   await agoraEngine.leaveChannel();
  //   super.dispose();
  // }
}
