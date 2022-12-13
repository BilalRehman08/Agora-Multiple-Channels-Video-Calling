import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_ui_kit/signup/signup_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import the generated file
import 'firebase_options.dart';

late RtcEngine agoraEngine;
String appId = "0efec5e57b8f47dabffb86ed5e5a3d5d";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  agoraEngine = createAgoraRtcEngine();
  await agoraEngine.initialize(RtcEngineContext(appId: appId));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: SignUpView(),
    );
  }
}
