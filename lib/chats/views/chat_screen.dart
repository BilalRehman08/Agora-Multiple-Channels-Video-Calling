import 'package:agora_ui_kit/chats/views/video_call_screen.dart';
import 'package:flutter/material.dart';

import '../wigets/message.dart';
import '../wigets/message_text_field.dart';


class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => VideoCallScreen())),
              icon: Icon(Icons.video_camera_front))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
                padding: EdgeInsets.only(bottom: 16),
                reverse: true,
                itemBuilder: (_, index) => _messages[index],
                separatorBuilder: (_, index) => SizedBox(height: 16),
                itemCount: _messages.length),
          ),
          MessageTextField()
        ],
      ),
    );
  }
}

const _messages = <MessageBuble>[
  MessageBuble(
      profileImageUrl:
          "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80",
      message: "This app would be perfect if it had video chat!",
      date: "Apr 22, 8:59 PM"),
  MessageBuble(
      message: "This app would be perfect if it had video chat!",
      date: "Apr 22, 6:32 PM"),
  MessageBuble(
      profileImageUrl:
          "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80",
      message: "This app would be perfect if it had video chat!",
      date: "Apr 22, 5:47 PM"),
  MessageBuble(
      message: "This app would be perfect if it had video chat!",
      date: "Apr 22, 3:23 PM"),
  MessageBuble(
      message: "This app would be perfect if it had video chat!",
      date: "Apr 22, 4:45 PM"),
  MessageBuble(
      profileImageUrl:
          "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80",
      message: "This app would be perfect if it had video chat!",
      date: "Apr 22, 9:47 PM"),
];
