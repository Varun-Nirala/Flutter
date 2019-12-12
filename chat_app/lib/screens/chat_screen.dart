import 'package:flutter/material.dart';

import 'package:contacts_service/contacts_service.dart';

import '../helpers/common.dart';

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
        title: Text(_contact.givenName.toString()),
        actions: <Widget>[
          getVideoIconButton(_onVideoButton),
          getCallIconButton(_onCallButton),
          getMoreIconButton(_onMoreButton),
        ],
        elevation: 0,
      ),
      body: Center(
        child: Text(_contact.phones.first.value.toString()),
      ),
    );
  }
}

class LeadingWidget extends StatelessWidget {
  final Contact _contact;

  const LeadingWidget(this._contact);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back),
          padding: EdgeInsets.all(0),
          onPressed: () => Navigator.of(context).pop(),
        ),
        getCircularAvatar(_contact.avatar),
      ],
    );
  }
}
