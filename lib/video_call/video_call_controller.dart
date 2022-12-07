import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class VideoCallController extends GetxController {
  String appId = "239ada4eaa1547c09fd9837805765768";
  String serverUrl =
      "https://agora-token-service-production-99d1.up.railway.app"; // The base URL to your token server, for example "https://agora-token-service-production-92ff.up.railway.app"
  int tokenExpireTime = 300; // Expire time in Seconds.
  bool isTokenExpiring = false; // Set to true when the token is about to expire
  final channelTextController = TextEditingController(text: '');

  final uid = TextEditingController(text: '');
  late var tokenRole = TextEditingController(text: '');

  // To access the TextField
  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
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
      // Use the token to join a channel or renew an expiring token
      setToken(newToken);
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }

  void setToken(String newToken) async {
    token = newToken;

    if (isTokenExpiring) {
      // Renew the token
      agoraEngine.renewToken(token);
      isTokenExpiring = false;
      showMessage("Token renewed");
    } else {
      // Join a channel.
      showMessage("Token received, joining a channel...");

      // Set channel options including the client role and channel profile
      ChannelMediaOptions options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      );
      await agoraEngine.joinChannel(
        token: token,
        channelId: channelName,
        uid: int.parse(uid.text),
        options: options,
      );
    }
  }

  String channelName = "fluttering";
  String token = "";
  final bool isHost = true;

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

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");

          isJoined = true;
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
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          showMessage('Token expiring');
          isTokenExpiring = true;

          // fetch a new token when the current token is about to expire
          fetchToken(int.parse(uid.text), channelName, int.parse(uid.text));
          update();
        },
      ),
    );
  }

  void join() async {
    await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile

    if (isHost) {
      tokenRole = tokenRole;
    } else {
      tokenRole = tokenRole;
    }

    channelName = channelTextController.text;

    if (channelName.isEmpty) {
      showMessage("Enter a channel name");
      return;
    } else {
      showMessage("Fetching token ...");
    }

    await fetchToken(
        int.parse(uid.text), channelName, int.parse(tokenRole.text));
  }

  void leave() {
    isJoined = false;
    remoteUid = null;
    update();
    agoraEngine.leaveChannel();
  }

  @override
  void onInit() {
    super.onInit();
    setupVideoSDKEngine();
  }

// Clean up the resources when you leave
  // @override
  // void dispose() async {
  //   await agoraEngine.leaveChannel();
  //   super.dispose();
  // }
}
