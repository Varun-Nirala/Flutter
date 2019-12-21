import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

import '../screens/chat_screen.dart';
import '../models/active_chats.dart';
import '../helpers/contacts.dart';
import '../helpers/common.dart';

class ActiveChatsWidget extends StatefulWidget {
  final Map<String, ChatInfo> chatMap;

  ActiveChatsWidget(this.chatMap);

  @override
  _ActiveChatsWidgetState createState() => _ActiveChatsWidgetState();
}

class _ActiveChatsWidgetState extends State<ActiveChatsWidget> {
  String ownerNumber;

  @override
  void initState() {
    ownerNumber = Contacts().ownerNumber;
    super.initState();
  }

  void openChatScreen(BuildContext context, Contact contact) {
    Navigator.of(context).pushNamed(ChatScreen.routeName, arguments: contact);
  }

  @override
  Widget build(BuildContext context) {
    return widget.chatMap.length < 1
        ? Center(
            child: Text('Start Chatting...'),
          )
        : ListView.builder(
            itemCount: widget.chatMap.length,
            itemBuilder: (BuildContext ctx, int i) {
              String key = widget.chatMap.keys.elementAt(i);
              return displayActiveChats(widget.chatMap[key]);
            },
          );
  }

  Widget displayActiveChats(ChatInfo chatInfo) {
    return Card(
      margin: EdgeInsets.all(0),
      child: ListTile(
        leading: getCircularAvatar(chatInfo.contact.avatar),
        title: Text(
          chatInfo.contact.displayName ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ), // We Should Display Status here , at WhatsApp Show the Status
        subtitle: Text(chatInfo.lastText),
        onTap: () =>
            openChatScreen(context, chatInfo.contact), // Show Chat Screen
        trailing: Text(getFormattedTime(chatInfo.lastUpdated)),
      ),
    );
  }
}
