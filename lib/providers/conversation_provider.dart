import 'package:flutter/material.dart';
import 'package:kit_chat/models/models.dart';
import 'package:kit_chat/resources/firestore_methods.dart';
import 'package:uuid/uuid.dart';

class ConversationProvider extends ChangeNotifier {
  final Conversation _conversation;
  final String name;
  Conversation get conversation => _conversation;

  String _textMessage = "";
  String get textMessage => _textMessage;

  ConversationProvider(this._conversation, this.name);

  void setTextMessage(String newTextMessage) {
    _textMessage = newTextMessage;
    notifyListeners();
  }

  Future<void> sendMessage(String senderUid) async {
    final newMessage = Message(
        content: _textMessage,
        sender: senderUid,
        time: DateTime.now(),
        uid: const Uuid().v1());
    await FirestoreMethods().sendMessage(conversation.uid, newMessage);
  }
}
