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
      appBar: AppBar(
        title: const Text('Get started with Video Calling'),
      ),
      body: GetBuilder<VideoCallController>(builder: (_) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          children: [
            // Container for the local video
            Container(
              height: 240,
              decoration: BoxDecoration(border: Border.all()),
              child: Center(child: localPreview(controller: controller)),
            ),
            const SizedBox(height: 10),
            //Container for the Remote video
            Container(
              height: 240,
              decoration: BoxDecoration(border: Border.all()),
              child: Center(child: remoteVideo(controller: controller)),
            ),
            // Button Row
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        controller.isJoined ? null : () => {controller.join()},
                    child: const Text("Join"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        controller.isJoined ? () => {controller.leave()} : null,
                    child: const Text("Leave"),
                  ),
                ),
              ],
            ),
            TextField(
              controller: controller.channelTextController,
              decoration:
                  const InputDecoration(hintText: 'Type the channel name here'),
            ),
            TextField(
              controller: controller.uid,
              decoration:
                  const InputDecoration(hintText: 'Type the uid name here'),
            ),
            TextField(
              controller: controller.tokenRole,
              decoration: const InputDecoration(
                  hintText: 'Type the tokenrole name here'),
            ),

            // Button Row ends
          ],
        );
      }),
    );
  }

// Display local video preview
  Widget localPreview({required VideoCallController controller}) {
    if (controller.isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: controller.agoraEngine,
          canvas: VideoCanvas(
              uid: controller.uid.text.isEmpty
                  ? 0
                  : int.parse(controller.uid.text)),
        ),
      );
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
      if (controller.isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
