import 'package:flutter/material.dart';

import '../utils/custom_colors.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final double fontSize;
  const CustomAppBar({super.key, required this.title, this.fontSize = 24});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsConstant.forebackgroundColor,
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            letterSpacing: 4,
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
