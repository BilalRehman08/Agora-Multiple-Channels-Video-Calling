import 'package:agora_ui_kit/video_call/video_call_controller.dart';
import 'package:agora_ui_kit/widgets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/custom_colors.dart';
import 'activity_record.dart';

class ActivityView extends StatelessWidget {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    VideoCallController controller =
        Get.isRegistered() ? Get.find() : Get.put(VideoCallController());
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          title: "ACTIVITY",
        ),
      ),
      backgroundColor: ColorsConstant.backgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.usersStream,
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
                  controller.currentUser.email) {
                controller.currentUserId = snapshot.data!.docs[index]['id'];
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 20, left: 20),
                child: ListTile(
                  onTap: () {
                    Get.to(ActivtyRecord(
                      userEmail: snapshot.data!.docs[index]['email'],
                    ));
                  },
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey[600]!,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(25)),
                  leading: const CircleAvatar(backgroundColor: Colors.red),
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
                  trailing: const Icon(
                    Icons.note_add,
                    color: Colors.white,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
