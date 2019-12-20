import 'package:flutter/foundation.dart';

import '../models/message.dart';
import '../models/chat.dart';

import '../helpers/db_helper.dart' as db;

class ChatProvider extends ChangeNotifier {
  final List<Chat> _chats = [];

  Chat _addNewChat(String chatId) {
    _chats.add(Chat(chatId: chatId));
    return _chats.firstWhere((chat) => chat.chatId == chatId);
  }

  Chat _getChat(String chatId) {
    return _chats.firstWhere((chat) => chat.chatId == chatId,
        orElse: () => _addNewChat(chatId));
  }

  // Exposed API
  void addMessage(String chatId, String ownerId, String text) async {
    Message msg = createMessage(ownerId, text);
    _getChat(chatId).addMessage(msg);

    await db.DBHelper().addMessage(chatId, msg);
    notifyListeners();
  }

  List<Message> getAllMessages(String chatId) {
    return _getChat(chatId).messages;
  }
}
