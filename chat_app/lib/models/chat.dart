import 'package:flutter/foundation.dart';

import './message.dart';

class Chat {
  final String chatId;
  final List<Message> _messages = [];

  Chat({@required this.chatId});

  List<Message> get messages {
    List<Message> list = List<Message>.from(_messages);
    return list;
  }

  void addMessage (Message msg) {
    _messages.add(msg);
  }
}