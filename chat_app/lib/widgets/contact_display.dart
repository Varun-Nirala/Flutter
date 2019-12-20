import 'package:chat_app/models/owner_info.dart';
import 'package:flutter/material.dart';

import 'package:contacts_service/contacts_service.dart';

import '../screens/chat_screen.dart';
import '../helpers/common.dart';

class ContactDisplay extends StatelessWidget {
  final Contact contact;

  const ContactDisplay({
    @required this.contact,
  });

  void openChatScreen(BuildContext context) {
    Navigator.of(context)
        .popAndPushNamed(ChatScreen.routeName, arguments: contact);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      child: ListTile(
        leading: getCircularAvatar(contact.avatar),
        title: Text(contact.displayName ??
            ''), // We Should Display Status here , at WhatsApp Show the Status
        subtitle: Text(contact.phones.first.value.toString()),
        onTap: () => openChatScreen(context), // Show Chat Screen
      ),
    );
  }
}
