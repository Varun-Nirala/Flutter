import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:firebase_database/firebase_database.dart';

import '../models/active_chats.dart';

import '../helpers/contacts.dart';
import '../helpers/db_helper.dart' as db;

class ActiveChatsProvider extends ChangeNotifier {
  late StreamSubscription<DatabaseEvent>? _onChatAddedSubscription;
  late StreamSubscription<DatabaseEvent>? _onChatUpdatedSubscription;
  late ActiveChats activeChats;

  @override
  void dispose() {
    _onChatAddedSubscription!.cancel();
    _onChatUpdatedSubscription!.cancel();
    super.dispose();
  }

  void _onChatAdded(DatabaseEvent event) {
    Map<String, dynamic> map = Map<String, dynamic>.from(event.snapshot as Map);
    String chatId = map['chatId'];
    String toNumber = map['toNumber'];
    String lastText = map['lastText'];
    String lastupdated = map['lastUpdated'];

    Contact contact = Contacts().findByNumber(toNumber);
    if (toNumber == Contacts().ownerNumber) {
      contact = Contacts().findByNumber(event.snapshot.key!);
    }

    getActiveChats().addNewchat(chatId, contact, lastText, lastupdated);
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
