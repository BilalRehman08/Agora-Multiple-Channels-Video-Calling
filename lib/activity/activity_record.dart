import 'package:agora_ui_kit/activity/activity_controller.dart';
import 'package:agora_ui_kit/activity/create_activity_dialog.dart';
import 'package:agora_ui_kit/utils/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_appbar.dart';

class ActivtyRecord extends StatelessWidget {
  final String? currentUserEmail;
  final String userEmail;
  final bool isStaff;
  const ActivtyRecord(
      {super.key,
      required this.userEmail,
      this.currentUserEmail,
      this.isStaff = false});

  @override
  Widget build(BuildContext context) {
    ActivityController activityController = Get.isRegistered()
        ? Get.find<ActivityController>()
        : Get.put<ActivityController>(ActivityController());
    return Scaffold(
      backgroundColor: ColorsConstant.backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          title: "ACTIVITY RECORD",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<ActivityController>(builder: (_) {
          return FutureBuilder(
              future: activityController.getRecord(userEmail: userEmail),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data['activityrecord'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            tileColor: ColorsConstant.forebackgroundColor,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.grey[600]!,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(25)),
                            title: Text(
                              "${snapshot.data['activityrecord'][index]['activity']}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    "Description : ${snapshot.data['activityrecord'][index]['description']}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15)),
                                Text(
                                    "Check by : ${snapshot.data['activityrecord'][index]['checkedby']}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15)),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "${snapshot.data['activityrecord'][index]['createdate']}",
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text(
                                    "${snapshot.data['activityrecord'][index]['createtime']}",
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        }),
      ),
      floatingActionButton: isStaff
          ? FloatingActionButton(
              backgroundColor: ColorsConstant.yellow,
              onPressed: () {
                createActivityDialog(
                    context: context,
                    activityController: activityController,
                    userEmail: userEmail,
                    currentUserEmail: currentUserEmail!);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
