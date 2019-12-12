/*
  Handles the HomeScreen, Show's AppBar which have Search option and MoreButton which show setting
  It's body contains HomeButtons Widget which have Bar which below Appbar
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/common.dart';

import '../provider/contacts_provider.dart';

import '../widgets/home_buttons.dart';

import '../screens/select_contact_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';
  static const appTitle = 'ChatApp';

  void _onSearchButton() {
    return;
  }

  void _onMoreButton() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () async {
          await Provider.of<ContactsProvider>(context, listen: false).fetchAndSetContacts();
          Navigator.of(context).pushNamed(SelectContactScreen.routeName);
        },
        backgroundColor: Colors.greenAccent[700],
        foregroundColor: Colors.white,
      ),
    );
  }
}
