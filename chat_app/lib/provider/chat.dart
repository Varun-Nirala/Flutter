import 'package:flutter/foundation.dart';

class Message {
  final String text;
  final String ownerId;
  final DateTime dateTime;

  const Message({@required this.ownerId, @required this.text, @required this.dateTime});
}

Message createMessage(String ownderId, String text) {
  return Message(ownerId: ownderId, text: text, dateTime: DateTime.now());
}

class Chat {
  final String id;
  final List<Message> _messages = [];

  Chat({@required this.id});

  List<Message> get messages {
    return [..._messages];
  }

  void addMessage (Message msg) {
    messages.add(msg);
  }
}