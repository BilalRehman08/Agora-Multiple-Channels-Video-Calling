import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_ui_kit/video_call/video_call_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agora_ui_kit/main.dart';

class VideoCallView extends StatelessWidget {
  const VideoCallView({super.key});
  @override
  Widget build(BuildContext context) {
    VideoCallController controller = Get.isRegistered()
        ? Get.find<VideoCallController>()
        : Get.put(VideoCallController());
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<VideoCallController>(builder: (_) {
          return Stack(
            children: [
              SizedBox(
                height: Get.height,
                child: Center(child: remoteVideo(controller: controller)),
              ),
              const SizedBox(height: 10),
              Positioned(
                top: 10,
                right: 10,
                child: SizedBox(
                  height: 160,
                  width: 110,
                  child: Center(child: localPreview(controller: controller)),
                ),
              ),
              // Button Row
              Positioned(
                bottom: 50,
                child: SizedBox(
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: Colors.grey[600],
                        onPressed: () {
                          controller.microphoneMute();
                        },
                        child: Icon(
                          controller.isMicrophoneMuted
                              ? Icons.mic_off
                              : Icons.mic,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 25),
                      FloatingActionButton(
                        backgroundColor: Colors.red,
                        onPressed: () {
                          controller.leave();
                        },
                        child: const Icon(
                          Icons.call_end,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 25),
                      FloatingActionButton(
                        backgroundColor: Colors.grey[600],
                        onPressed: () {
                          controller.turnCamera();
                        },
                        child: const Icon(
                          Icons.switch_camera,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

// Display local video preview
  Widget localPreview({required VideoCallController controller}) {
    return AgoraVideoView(
        controller: VideoViewController(
      rtcEngine: agoraEngine,
      canvas: const VideoCanvas(uid: 0),
    ));
  }

// Display remote user's video
  Widget remoteVideo({required VideoCallController controller}) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: agoraEngine,
        canvas: VideoCanvas(uid: controller.remoteUid),
        connection: RtcConnection(channelId: controller.channelName),
      ),
    );
  }
}
