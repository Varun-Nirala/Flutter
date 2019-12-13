import 'package:flutter/foundation.dart';

import '../models/message.dart';
import '../models/chat.dart';

class ChatProvider extends ChangeNotifier {
  final List<Chat> _chats = [];

  Chat _addNewChat(String chatId) {
    _chats.add(Chat(id: chatId));
    return _chats.firstWhere((chat) => chat.id == chatId);
  }

  Chat getChat(String chatId) {
    return _chats.firstWhere((chat) => chat.id == chatId,
        orElse: () => _addNewChat(chatId));
  }

  void addMessage(String chatId, String text) {
    getChat(chatId).addMessage(createMessage(chatId, text));
    notifyListeners();
  }

  List<Message> getAllMessages (String chatId) {
    return getChat(chatId).messages;
  }
}
