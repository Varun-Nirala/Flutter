import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:firebase_database/firebase_database.dart';

import '../models/active_chats.dart';

import '../helpers/contacts.dart';
import '../helpers/db_helper.dart' as db;

class ActiveChatsProvider extends ChangeNotifier {
  StreamSubscription<Event> _onChatAddedSubscription;
  StreamSubscription<Event> _onChatUpdatedSubscription;
  ActiveChats activeChats;

  @override
  void dispose() {
    _onChatAddedSubscription.cancel();
    _onChatUpdatedSubscription.cancel();
    super.dispose();
  }

  void _onChatAdded(Event event) {
    DataSnapshot data = event.snapshot;
    String chatId = data.value['chatId'];
    String toNumber = data.value['toNumber'];
    String lastText = data.value['lastText'];
    String lastupdated = data.value['lastUpdated'];

    Contact contact = Contacts().findByNumber(toNumber);
    if (toNumber == Contacts().ownerNumber) {
      contact = Contacts().findByNumber(data.key);
    }

    getActiveChats().addNewchat(
        chatId: chatId,
        contact: contact,
        lastText: lastText,
        lastUpdated: lastupdated);
    notifyListeners();
  }

  ActiveChats getActiveChats() {
    if (_onChatAddedSubscription == null) {
      activeChats = ActiveChats(ownerId: Contacts().ownerNumber);
      _onChatAddedSubscription = db.DBHelper()
          .getActiveChatsReference(activeChats.ownerId)
          .onChildAdded
          .listen(_onChatAdded);
      _onChatUpdatedSubscription = db.DBHelper()
          .getActiveChatsReference(activeChats.ownerId)
          .onChildChanged
          .listen(_onChatAdded);
    }
    return activeChats;
  }

  void addActiveChat(String chatId, String otherNumber, String lastText,
      DateTime timeStamp) async {
    String toNumber = otherNumber.replaceAll(' ', '');
    Map<String, dynamic> data = {
      'chatId': chatId,
      'toNumber': toNumber,
      'lastText': lastText,
      'lastUpdated': timeStamp.toIso8601String(),
    };
    await db.DBHelper().addChat(activeChats.ownerId, toNumber, data);
  }
}
