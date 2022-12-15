import 'package:flutter/material.dart';

import '../utils/custom_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;
  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    required this.controller,
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
          obscureText: isPassword,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 15, top: 5),
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: ColorsConstant.secondary),
            suffixIcon: Icon(icon, color: ColorsConstant.secondary),
          ),
        ));
  }
}
