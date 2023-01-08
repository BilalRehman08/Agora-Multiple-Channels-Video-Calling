import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/custom_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final RxBool? isPassword;
  final VoidCallback? onPressedSuffixIcon;
  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.icon,
    this.isPassword,
    required this.controller, this.onPressedSuffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsConstant.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: controller,
          obscureText: isPassword?.value ?? false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 15, top: 5),
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: ColorsConstant.secondary),
            suffixIcon: IconButton(
              icon: Icon(icon, color: ColorsConstant.secondary),
              onPressed: onPressedSuffixIcon,
            ),
          ),
        ));
  }
}
