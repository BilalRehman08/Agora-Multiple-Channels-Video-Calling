import 'package:agora_ui_kit/activity/activity_controller.dart';
import 'package:agora_ui_kit/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

createActivityDialog(
      {required BuildContext context, required ActivityController activityController, required String userEmail, required String currentUserEmail}) async {
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
                    items: activityController.itemList.map((String items) {
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
                  child: TextField(
                      controller: activityController.descriptionController,
                      maxLines: 5, //or null
                      decoration: const InputDecoration(
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
                backgroundColor: ColorsConstant.yellow, // Background color
              ),
              child: const Text('SUBMIT'),
              onPressed: () async {
                activityController.addRecord(context,
                    userEmail: userEmail,
                    activity: activityController.activitySelectedItem.value,
                    description: activityController.descriptionController.text,
                    checkedby: currentUserEmail,
                    createdate: activityController.datee.value,
                    createtime: activityController.timee.value);
              },
            ),
          ],
        );
      },
    );
  }