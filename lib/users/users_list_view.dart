import 'package:agora_ui_kit/users/users_list_controller.dart';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: usersListController.usersStream,
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
                if (snapshot.data!.docs[index]['id'] ==
                    usersListController.user.uid) {
                  return const SizedBox();
                }
                return Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: ListTile(
                      leading: const CircleAvatar(backgroundColor: Colors.red),
                      tileColor: Colors.grey[200],
                      title: Text(snapshot.data!.docs[index]['name']),
                      subtitle: Text(snapshot.data!.docs[index]['id']),
                      trailing: IconButton(
                          icon: const Icon(Icons.video_call), onPressed: () {}),
                    ));
              });
        },
      ),
    );
  }
}
