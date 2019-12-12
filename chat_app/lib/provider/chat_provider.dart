import 'package:flutter/foundation.dart';

import '../models/message.dart';

class Chat {
  final String id;
  final List<Message> _messages = [];

  Chat({@required this.id});

  List<Message> get messages {
    return [..._messages];
  }

  void addMessage(Message msg) {
    messages.add(msg);
  }
}

class ChatProvider extends ChangeNotifier {
  final List<Chat> _chats = [];

  Chat _addNewChat(String chatId) {
    _chats.add(Chat(id: chatId));
    notifyListeners();
    return _chats.firstWhere((chat) => chat.id == chatId);
  }

  Chat getChat(String chatId) {
    return _chats.firstWhere((chat) => chat.id == chatId,
        orElse: () => _addNewChat(chatId));
  }

  void addMessage(String chatId, Message msg) {
    getChat(chatId).addMessage(msg);
    notifyListeners();
  }

  List<Message> getAllMessages (String chatId) {
    return getChat(chatId).messages;
  }
}
