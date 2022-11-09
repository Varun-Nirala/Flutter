import 'package:contacts_service/contacts_service.dart';

class ChatInfo {
  Contact contact;
  String lastText;
  String lastUpdated;

  ChatInfo(this.contact, this.lastText, this.lastUpdated);
}

class ActiveChats {
  final String ownerId;
  final Map<String, ChatInfo> _chatMap = {}; // ChatId is key

  ActiveChats({
    required this.ownerId,
  });

  Map<String, ChatInfo> get chatMap {
    Map<String, ChatInfo> map = Map<String, ChatInfo>.from(_chatMap);
    return map;
  }

  Contact getContact(String chatId) {
    return _chatMap[chatId]!.contact;
  }

  ChatInfo? getValue(String chatId) {
    return _chatMap[chatId];
  }

  bool isChatPresent(String chatId) {
    return _chatMap.containsKey(chatId);
  }

  void addNewchat(
      String chatId, Contact contact, String lastText, String lastUpdated) {
    _chatMap[chatId] = ChatInfo(contact, lastText, lastUpdated);
  }
}
