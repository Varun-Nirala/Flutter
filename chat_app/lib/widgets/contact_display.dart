import 'package:flutter/material.dart';

import 'package:contacts_service/contacts_service.dart';

class ContactDisplay extends StatelessWidget {
  final Contact contact;

  const ContactDisplay({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      child: ListTile(
        leading: (contact.avatar != null && contact.avatar.isNotEmpty)
            ? CircleAvatar(backgroundImage: MemoryImage(contact.avatar))
            : CircleAvatar(child: Text(contact.initials())),
        title: Text(contact.displayName ?? ''), // We Should Display Status here , at WhatsApp Show the Status
        subtitle: Text(contact.phones.first.value.toString()),
        onTap: () {}, // Show Chat Screen
      ),
    );
  }
}
