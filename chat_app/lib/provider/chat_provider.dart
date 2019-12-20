import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:firebase_database/firebase_database.dart';

import '../models/message.dart';
import '../models/chat.dart';

import '../helpers/db_helper.dart' as db;

class ChatProvider extends ChangeNotifier {
  StreamSubscription<Event> _onMessageAddedSubscription;
  final List<Chat> _chats = [];

  @override
  void dispose() {
    _onMessageAddedSubscription.cancel();
    super.dispose();
  }

  Chat _addNewChat(String chatId) {
    _chats.add(Chat(chatId: chatId));
    return _chats.firstWhere((chat) => chat.chatId == chatId);
  }

  void _onMessageAdded(Event event) {
    Message msg = Message.fromSnapshot(event.snapshot);
    _getChat(msg.chatId).addMessage(msg);
    notifyListeners();
  }

  Chat _getChat(String chatId) {
    if (_onMessageAddedSubscription == null) {
      _onMessageAddedSubscription = db.DBHelper()
          .getMessagesReference(chatId)
          .onChildAdded
          .listen(_onMessageAdded);
    }
    return _chats.firstWhere((chat) => chat.chatId == chatId,
        orElse: () => _addNewChat(chatId));
  }

  // Exposed API
  void addMessage(String chatId, String ownerId, String text) async {
    Message msg = createMessage(chatId, ownerId, text);
    await db.DBHelper().addMessage(chatId, msg);
  }

  List<Message> getAllMessages(String chatId) {
    return _getChat(chatId).messages;
  }
}
