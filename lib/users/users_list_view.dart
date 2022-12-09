import 'package:agora_ui_kit/users/users_list_controller.dart';
import 'package:agora_ui_kit/video_call/video_call_controller.dart';
import 'package:agora_ui_kit/video_call/video_call_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    UsersListController usersListController =
        Get.isRegistered() ? Get.find() : Get.put(UsersListController());

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(usersListController.currentUser.email)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snapshotchannel) {
            if (snapshotchannel.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            if (snapshotchannel.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            Map channelData = snapshotchannel.data!.data() as Map;
            if (channelData["channelName"] == "") {
              return StreamBuilder<QuerySnapshot>(
                stream: usersListController.usersStream,
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
                        print(snapshot.data!.docs[index]);
                        if (snapshot.data!.docs[index]['email'] ==
                            usersListController.currentUser.email) {
                          usersListController.currentUserId =
                              snapshot.data!.docs[index]['id'];
                          return const SizedBox();
                        }
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: ListTile(
                              leading: const CircleAvatar(
                                  backgroundColor: Colors.red),
                              tileColor: Colors.grey[200],
                              title: Text(snapshot.data!.docs[index]['name']),
                              subtitle: Text(
                                  "${snapshot.data!.docs[index]['email']}"),
                              trailing: IconButton(
                                  icon: const Icon(Icons.video_call),
                                  onPressed: () async {
                                    if (usersListController.currentUserId <
                                        snapshot.data!.docs[index]['id']) {
                                      usersListController.channelName =
                                          "${usersListController.currentUserId}${snapshot.data!.docs[index]['id']}";
                                    } else {
                                      usersListController.channelName =
                                          "${snapshot.data!.docs[index]['id']}${usersListController.currentUserId}";
                                    }
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(
                                            "${usersListController.currentUserId}")
                                        .set({
                                      'channelName':
                                          usersListController.channelName
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(
                                            "${snapshot.data!.docs[index]['id']}")
                                        .set({
                                      'channelName':
                                          usersListController.channelName
                                    });
                                  }),
                            ));
                      });
                },
              );
            } else {
              print("go to video call view");
              return VideoCallView();
            }
          }),
    );
  }
}
