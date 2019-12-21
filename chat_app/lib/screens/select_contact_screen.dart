import 'package:flutter/material.dart';

import '../helpers/common.dart';
import '../helpers/contacts.dart';
import '../widgets/contact_display.dart';

class SelectContactScreen extends StatelessWidget {
  static const routeName = '/select-contact-screen';

  void _onSearchButton() {
    return;
  }

  void _onMoreButton() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    final contactList = Contacts().registeredContactList;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Contact'),
            const SizedBox(height: 4),
            Text(
              '${contactList.length} contacts',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: <Widget>[
          getSearchIconButton(_onSearchButton),
          getMoreIconButton(_onMoreButton),
        ],
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: contactList.length,
        itemBuilder: (ctx, i) => ContactDisplay(
          contact: contactList[i],
        ),
      ),
    );
  }
}
