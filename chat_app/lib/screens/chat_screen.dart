import 'package:flutter/material.dart';

import 'package:contacts_service/contacts_service.dart';

import '../helpers/common.dart';
import '../widgets/chat_widget.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat-screen';

  void _onVideoButton() {
    return;
  }

  void _onCallButton() {
    return;
  }

  void _onMoreButton() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    final Contact _contact = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            getCircularAvatar(_contact.avatar!),
            SizedBox(
              width: 10,
            ),
            Text(_contact.givenName ?? ''),
          ],
        ),
        actions: <Widget>[
          getVideoIconButton(_onVideoButton),
          getCallIconButton(_onCallButton),
          getMoreIconButton(_onMoreButton),
        ],
        elevation: 0,
      ),
      body: ChatWidget(othersContact: _contact), // Show Chat Area
    );
  }
}
