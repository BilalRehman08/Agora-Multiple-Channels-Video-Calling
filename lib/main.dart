import 'package:agora_ui_kit/video_call/video_call_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'video_call/video_call_controller.dart';

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    VideoCallController controller = Get.put(VideoCallController());
    return MaterialApp(
      scaffoldMessengerKey: controller.scaffoldMessengerKey,
      home: const VideoCallView(),
    );
  }
}
