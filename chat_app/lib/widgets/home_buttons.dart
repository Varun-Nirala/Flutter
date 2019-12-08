import 'package:flutter/material.dart';

import '../helpers/common.dart' as common;

class HomeButtons extends StatelessWidget {
  final common.eSCREEN currScreen;
  final Function atHomeSetCurrScreen;

  HomeButtons({
    @required this.currScreen,
    @required this.atHomeSetCurrScreen,
  });

  FlatButton _createFlatButtons(common.eSCREEN screen, Function onPress) {
    String title = 'CHATS';
    Color textColor = Colors.white30;

    if (screen == common.eSCREEN.SCREEN_STATUS) {
      title = 'STATUS';
    } else if (screen == common.eSCREEN.SCREEN_CALLS) {
      title = 'CALLS';
    }

    if (screen == currScreen) {
      textColor = Colors.white;
    }

    return FlatButton(
      child: Text(title, style: TextStyle(color: textColor)),
      onPressed: onPress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.color,
      height: 50,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 25,
                child: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {},
                  color: Colors.blueGrey,
                ),
              ),
              Expanded(
                child: _createFlatButtons(common.eSCREEN.SCREEN_CHATS, () {}),
              ),
              Expanded(
                child: _createFlatButtons(common.eSCREEN.SCREEN_STATUS, () {}),
              ),
              Expanded(
                child: _createFlatButtons(common.eSCREEN.SCREEN_CALLS, () {}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}