import 'package:agora_ui_kit/video_call/video_call_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    // UsersListController usersListController =
    //     Get.isRegistered() ? Get.find() : Get.put(UsersListController());
    VideoCallController videoCallController =
        Get.isRegistered() ? Get.find() : Get.put(VideoCallController());
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: videoCallController.usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: ListTile(
                      leading: const CircleAvatar(backgroundColor: Colors.red),
                      tileColor: Colors.grey[200],
                      title: Text(snapshot.data!.docs[index]['name']),
                      subtitle: Text("${snapshot.data!.docs[index]['email']}"),
                      trailing: IconButton(
                          icon: const Icon(Icons.video_call),
                          onPressed: () async {
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
                                .doc(snapshot.data!.docs[index]['email'])
                                .update({
                              'channelName': videoCallController.channelName
                            });

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(videoCallController.currentUser.email)
                                .update({
                              'channelName': videoCallController.channelName
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
      ),
    );
  }
}
