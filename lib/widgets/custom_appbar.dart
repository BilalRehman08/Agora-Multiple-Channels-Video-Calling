import 'package:flutter/material.dart';

import '../utils/custom_colors.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsConstant.forebackgroundColor,
      title: Center(
        child: Text(
          title,
          style: const TextStyle(
            letterSpacing: 4,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
