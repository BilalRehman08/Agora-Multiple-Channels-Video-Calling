import 'package:agora_ui_kit/activity/activity_controller.dart';
import 'package:agora_ui_kit/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_appbar.dart';

class ActivtyRecord extends StatelessWidget {
  const ActivtyRecord({super.key});

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
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                tileColor: ColorsConstant.forebackgroundColor,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.grey[600]!,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(25)),
                title: Text("BreakFast $index"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Description $index"),
                    Text("Description $index"),
                  ],
                ),
                trailing: Text("Date & Time $index"),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstant.yellow,
        onPressed: () {
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'ADD RECORD',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ColorsConstant.yellow, // Background color
                            ),
                            onPressed: () async {
                              await activityController.selectDate(context);
                            },
                            child: const Text('SELECT DATE'),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Obx(() {
                            return Text(activityController.datee.value);
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ColorsConstant.yellow, // Background color
                            ),
                            onPressed: () async {
                              await activityController.selectTime(context);
                            },
                            child: const Text('SELECT TIME'),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Obx(() {
                            return Text(activityController.timee.value);
                          }),
                        ],
                      ),
                      Obx(() {
                        return DropdownButton(
                          isExpanded: true,
                          value: activityController.activitySelectedItem.value,
                          onChanged: (value) {
                            activityController.activitySelectedItem.value =
                                value.toString();
                          },
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items:
                              activityController.itemList.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                        );
                      }),
                      const SizedBox(height: 10),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: ColorsConstant.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const TextField(
                            maxLines: 5, //or null
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                              hintText: "Enter your message",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                actionsPadding: const EdgeInsets.only(bottom: 20, right: 20),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          ColorsConstant.yellow, // Background color
                    ),
                    child: const Text('SUBMIT'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
