/*
  Handles the HomeScreen, Show's AppBar which have Search option and MoreButton which show setting
  It's body contains HomeButtons Widget which have Bar which below Appbar
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/active_chats_provider.dart';

import '../models/active_chats.dart';

import '../helpers/common.dart';
import '../helpers/contacts.dart';

import '../widgets/home_buttons.dart';
import '../widgets/active_chats_widget.dart';

import '../screens/select_contact_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';
  static const appTitle = 'ChatApp';

  void _onSearchButton() {
    return;
  }

  void _onMoreButton() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    final String _ownerNumber = ModalRoute.of(context).settings.arguments;
    Map<String, ChatInfo> chatMap =
        Provider.of<ActiveChatsProvider>(context).getActiveChats().chatMap;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(HomeScreen.appTitle),
        actions: <Widget>[
          getSearchIconButton(_onSearchButton),
          getMoreIconButton(_onMoreButton),
        ],
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          HomeButtons(),
          Expanded(
            child: ActiveChatsWidget(chatMap),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () async {
          await Contacts().fetchAndSetContacts(_ownerNumber);
          Navigator.of(context).pushNamed(SelectContactScreen.routeName);
        },
        backgroundColor: Colors.greenAccent[700],
        foregroundColor: Colors.white,
      ),
    );
  }
}
