import 'package:agora_ui_kit/utils/custom_colors.dart';
import 'package:agora_ui_kit/video_call/video_call_controller.dart';
import 'package:agora_ui_kit/video_call/video_call_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../widgets/custom_appbar.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    // UsersListController usersListController =
    //     Get.isRegistered() ? Get.find() : Get.put(UsersListController());
    VideoCallController videoCallController =
        Get.isRegistered() ? Get.find() : Get.put(VideoCallController());
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          title: "VIDEO MONITORING",
        ),
      ),
      backgroundColor: ColorsConstant.backgroundColor,
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(videoCallController.currentUser.email)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> callSnapShot) {
            if (callSnapShot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            if (callSnapShot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            Map channelData = callSnapShot.data!.data() as Map;
            if (channelData["channelName"] == "") {
              if (videoCallController.isJoined) {
                // Get.snackbar("Leaving", "Channel");

                agoraEngine.leaveChannel();
                videoCallController.isJoined = false;
              }

              return StreamBuilder<QuerySnapshot>(
                stream: videoCallController.usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data!.docs[index]['email'] ==
                            videoCallController.currentUser.email) {
                          videoCallController.currentUserId =
                              snapshot.data!.docs[index]['id'];
                          return const SizedBox();
                        }

                        return Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, right: 20, left: 20),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              leading: const CircleAvatar(
                                  backgroundColor: Colors.red),
                              tileColor: ColorsConstant.forebackgroundColor,
                              title: Text(snapshot.data!.docs[index]['name'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                "${snapshot.data!.docs[index]['email']}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: IconButton(
                                  icon: const Icon(
                                    Icons.video_call,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    videoCallController.remoteUserEmail =
                                        snapshot.data!.docs[index]['email'];

                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(videoCallController
                                            .currentUser.email)
                                        .update({
                                      'remoteid': snapshot.data!.docs[index]
                                          ['id'],
                                    });

                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(
                                            videoCallController.remoteUserEmail)
                                        .update({
                                      'remoteid':
                                          videoCallController.currentUserId,
                                    });

                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(videoCallController
                                            .currentUser.email)
                                        .update({
                                      'remoteemail':
                                          videoCallController.remoteUserEmail,
                                    });

                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(
                                            videoCallController.remoteUserEmail)
                                        .update({
                                      'remoteemail':
                                          videoCallController.currentUser.email,
                                    });

                                    if (videoCallController.currentUserId <
                                        snapshot.data!.docs[index]['id']) {
                                      videoCallController.channelName =
                                          "${videoCallController.currentUserId}${snapshot.data!.docs[index]['id']}";
                                    } else {
                                      videoCallController.channelName =
                                          "${snapshot.data!.docs[index]['id']}${videoCallController.currentUserId}";
                                    }

                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(
                                            snapshot.data!.docs[index]['email'])
                                        .update({
                                      'channelName':
                                          videoCallController.channelName
                                    });

                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(videoCallController
                                            .currentUser.email)
                                        .update({
                                      'channelName':
                                          videoCallController.channelName
                                    });

                                    // await videoCallController.setupVideoSDKEngine(
                                    //   id: usersListController.currentUserId,
                                    //   channelName: videoCallController.channelName,
                                    //   tokenRole: 1,
                                    // );
                                    // Get.to(const VideoCallView());
                                  }),
                            ));
                      });
                },
              );
            } else {
              return FutureBuilder(
                future: videoCallController.setupVideoSDKEngine(),
                builder: (context, snapshot3) {
                  if (snapshot3.connectionState == ConnectionState.done) {
                    videoCallController.isJoined = true;
                    return const VideoCallView();
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            }
          }),
    );
  }
}
