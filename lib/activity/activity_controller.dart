import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityController extends GetxController {
  TextEditingController descriptionController = TextEditingController();
  final DateTime initialDate = DateTime.now();

  Rx<String> datee = 'DD/MM/YYYY'.obs;
  Rx<String> timee = 'HOUR/MIN'.obs;
  RxString activitySelectedItem = 'Break Fast'.obs;
  var itemList = [
    'Break Fast',
    'Lunch',
    'Dinner',
    'Other',
  ];
  // Rx<String> activityRadioButton = 'BreakFast'.obs;

  selectDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2022, 12),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      print(picked);
      datee.value = " ${picked.day}/${picked.month}/${picked.year}";
    }
  }

  selectTime(context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      print(picked.hour);
      timee.value = " ${picked.hour}:${picked.minute}";
    }
  }

  Future getRecord({required userEmail}) async {
    var data =
        FirebaseFirestore.instance.collection('users').doc(userEmail).get();
    update();
    return data;
  }

  addRecord(
    context, {
    required userEmail,
    required activity,
    required description,
    required checkedby,
    required createdate,
    required createtime,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(userEmail).update({
      'activityrecord': FieldValue.arrayUnion([
        {
          'activity': activity,
          'description': description,
          'checkedby': checkedby,
          'createdate': createdate,
          'createtime': createtime,
        }
      ])
    }).then((value) {
      Navigator.of(context).pop();
    });
    update();
  }
}
