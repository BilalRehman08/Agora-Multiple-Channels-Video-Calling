import 'package:agora_ui_kit/video_call/video_call_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import the generated file
import 'firebase_options.dart';
import 'video_call/video_call_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(home: MyApp()));
}

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
