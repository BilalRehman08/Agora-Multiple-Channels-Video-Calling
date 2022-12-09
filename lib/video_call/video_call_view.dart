import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_ui_kit/video_call/video_call_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          // if (controller.remoteUid == null) {
          //   // When remote user is not connected
          //   return Stack(
          //     children: [
          //       // Container for the local video
          //       SizedBox(
          //         height: Get.height,
          //         child: Center(child: localPreview(controller: controller)),
          //       ),
          //       // Button Row
          //       Positioned(
          //         bottom: 50,
          //         child: SizedBox(
          //           width: Get.width,
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: <Widget>[
          //               FloatingActionButton(
          //                 backgroundColor: Colors.red,
          //                 onPressed: controller.isJoined
          //                     ? () => {controller.leave()}
          //                     : null,
          //                 child: const Icon(
          //                   Icons.call_end,
          //                   color: Colors.white,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   );
          // }
          // // When remote user is connected
          // else {
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
                        backgroundColor: Colors.red,
                        onPressed: controller.isJoined
                            ? () => {controller.leave()}
                            : null,
                        child: const Icon(
                          Icons.call_end,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
          // }
        }),
      ),
    );
  }

// Display local video preview
  Widget localPreview({required VideoCallController controller}) {
    if (controller.isJoined) {
      return AgoraVideoView(
          controller: VideoViewController(
        rtcEngine: controller.agoraEngine,
        canvas: const VideoCanvas(uid: 0),
      ));
    } else {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

// Display remote user's video
  Widget remoteVideo({required VideoCallController controller}) {
    if (controller.remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: controller.agoraEngine,
          canvas: VideoCanvas(uid: controller.remoteUid),
          connection: RtcConnection(channelId: controller.channelName),
        ),
      );
    } else {
      String msg = '';
      // if (controller.isJoined) msg = 'Waiting for remote user to join';
      if (controller.isJoined) msg = '';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
