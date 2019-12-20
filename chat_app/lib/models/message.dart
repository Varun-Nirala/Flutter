import 'package:flutter/foundation.dart';

class Message {
  final String text;
  final String ownerId;
  final DateTime dateTime;

  const Message(
      {@required this.ownerId, @required this.text, @required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'ownerId': ownerId,
      'timeStamp': dateTime.toIso8601String(),
    };
  }
}

Message createMessage(String ownderId, String text) {
  return Message(ownerId: ownderId, text: text, dateTime: DateTime.now());
}
