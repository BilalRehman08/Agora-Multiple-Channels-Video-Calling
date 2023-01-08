import 'package:agora_ui_kit/consent_permission/consent_permission_controller.dart';
import 'package:agora_ui_kit/utils/custom_colors.dart';
import 'package:agora_ui_kit/widgets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConsentPermissionView extends StatelessWidget {
  final String facilityId;
  const ConsentPermissionView({super.key, required this.facilityId});

  @override
  Widget build(BuildContext context) {
    ConsentPermissionController controller =
        Get.put(ConsentPermissionController());
    return Scaffold(
      backgroundColor: ColorsConstant.backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          title: "Consent Permission",
          fontSize: 20,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('facilityId', isEqualTo: facilityId)
            .where("role", isEqualTo: "Patient")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  width: Get.width * 0.9,
                  child: Text(
                    "You can manage the consent permission of patients of facility Id $facilityId",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 20, left: 20),
                        child: ListTile(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.grey[600]!,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(25)),
                            leading:
                                const CircleAvatar(backgroundColor: Colors.red),
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
                            trailing: Switch(
                              value: snapshot.data!.docs[index]['modules']
                                  ['video'],
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(snapshot.data!.docs[index]['email'])
                                    .update({
                                  'modules': {
                                    'chat': false,
                                    'video': value,
                                    'patient_record': true,
                                    'patient_vitals': true,
                                    'role_management': false
                                  }
                                });
                              },
                            )),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
