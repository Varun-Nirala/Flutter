/*
  -> The Home Screen
    -> Display the AppBar
 */

import 'package:flutter/material.dart';

import '../widgets/home_buttons.dart';

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
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _onSearchButton,
            padding: EdgeInsets.all(0),
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: _onMoreButton,
            padding: EdgeInsets.all(0),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          HomeButtons(),
        ],
      ),
    );
  }
}
