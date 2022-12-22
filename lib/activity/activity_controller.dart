import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityController extends GetxController {
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
}
