import 'package:agora_ui_kit/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

buttonCard({
  required String text,
  required onPressed,
  required icon,
  required num height,
  required num width,
}) {
  return InkWell(
    onTap: onPressed,
    child: Card(
      color: ColorsConstant.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 15,
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 40),
        width: Get.width * width,
        height: Get.height * height,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: ColorsConstant.forebackgroundColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  letterSpacing: 1,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}