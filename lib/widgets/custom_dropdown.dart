import 'package:agora_ui_kit/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

customDropDown(
    {required RxString dropDownValue, required List<String> dropDownItems}) {
  return Obx(() => Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.only(left: 20, right: 10),
        decoration: BoxDecoration(
          color: ColorsConstant.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton(
            dropdownColor: ColorsConstant.primary,
            isExpanded: true,
            style: TextStyle(color: ColorsConstant.secondary),
            underline: const SizedBox(),
            items: dropDownItems
                .map<DropdownMenuItem>((String item) =>
                    DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) {
              dropDownValue.value = value as String;
            },
            value: dropDownValue.value),
      ));
}
