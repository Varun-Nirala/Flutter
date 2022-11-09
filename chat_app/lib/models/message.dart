import 'package:flutter/foundation.dart';

import 'package:firebase_database/firebase_database.dart';

class Message {
  late String text;
  late String chatId;
  late String ownerId;
  late DateTime dateTime;

  Message(
      {required this.chatId,
      required this.ownerId,
      required this.text,
      required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'chatId': chatId,
      'ownerId': ownerId,
      'timeStamp': dateTime.toIso8601String(),
    };
  }

  Message.fromSnapshot(DataSnapshot snapshot) {
    text = snapshot.value['text'];
    chatId = snapshot.value['chatId'];
    ownerId = snapshot.value['ownerId'];
    dateTime = DateTime.parse(snapshot.value['timeStamp']);
  }
}

Message createMessage(
    String chatId, String ownderId, String text, DateTime timeStamp) {
  return Message(
      chatId: chatId, ownerId: ownderId, text: text, dateTime: timeStamp);
}
