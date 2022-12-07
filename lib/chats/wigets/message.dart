import 'package:flutter/material.dart';

class MessageBuble extends StatelessWidget {
  final String? profileImageUrl;
  final String message;
  final String date;

  const MessageBuble(
      {Key? key,
      this.profileImageUrl,
      required this.message,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReceiver = profileImageUrl != null;
    return Row(
      mainAxisAlignment:
          isReceiver ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isReceiver)
          Padding(
            padding: EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              foregroundImage: NetworkImage(profileImageUrl!),
            ),
          ),
        Flexible(
          child: Column(
            crossAxisAlignment:
                isReceiver ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                constraints: BoxConstraints(maxWidth: 275),
                decoration: BoxDecoration(
                  color: isReceiver ? Colors.green : Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 8),
              Text(date, style: TextStyle(fontSize: 12))
            ],
          ),
        ),
        if (!isReceiver)
          const SizedBox(
            width: 12,
          ),
      ],
    );
  }
}
