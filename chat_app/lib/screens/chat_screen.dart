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
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              alignment: Alignment.centerLeft,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            getCircularAvatar(_contact.avatar),
            SizedBox(width: 4,),
            Text(_contact.givenName),
          ],
        ),
        actions: <Widget>[
          getVideoIconButton(_onVideoButton),
          getCallIconButton(_onCallButton),
          getMoreIconButton(_onMoreButton),
        ],
        elevation: 0,
      ),
      body: ChatWidget(chatId: _contact.phones.first.value),// Show Chat Area
    );
  }
}
