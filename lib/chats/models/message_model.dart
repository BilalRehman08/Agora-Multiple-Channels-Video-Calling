class Message {
  String senderEmail;
  String content;
  DateTime time;

  Message(
      {required this.senderEmail, required this.content, required this.time});

  Message.fromJson(Map<String, dynamic> json)
      : senderEmail = json['senderEmail'],
        content = json['content'],
        time = DateTime.parse(json['time']);

  Map<String, dynamic> toJson() => {
        'senderEmail': senderEmail,
        'content': content,
        'time': time.toIso8601String(),
      };
}
