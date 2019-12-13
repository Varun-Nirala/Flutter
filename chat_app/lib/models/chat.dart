import 'package:flutter/foundation.dart';

import './message.dart';

class Chat {
  final String id;
  final List<Message> _messages = [];

  Chat({@required this.id});

  List<Message> get messages {
    return [..._messages];
  }

  void addMessage (Message msg) {
    _messages.add(msg);
  }
}