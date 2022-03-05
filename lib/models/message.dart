import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String content;
  final String sender;
  final DateTime time;
  final String uid;

  const Message({
    required this.content,
    required this.sender,
    required this.time,
    required this.uid,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      sender: json['sender'],
      time: (json["time"] as Timestamp).toDate(),
      uid: json["uid"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'sender': sender,
      'time': Timestamp.fromDate(time),
      'uid': uid,
    };
  }
}
