import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/curr_screen_provider.dart';
import '../helpers/common.dart' as common;

class HomeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.color,
      height: 52,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 50,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                child: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {},
                  color: Colors.blueGrey,
                ),
              ),
              const ExpandedFlatButton(
                  screenButton: common.eSCREEN.SCREEN_CHATS),
              const ExpandedFlatButton(
                  screenButton: common.eSCREEN.SCREEN_STATUS),
              const ExpandedFlatButton(
                  screenButton: common.eSCREEN.SCREEN_CALLS),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpandedFlatButton extends StatelessWidget {
  const ExpandedFlatButton({
    Key key,
    @required this.screenButton,
  }) : super(key: key);

  final common.eSCREEN screenButton;

  void stateChanged(BuildContext context, common.eSCREEN selectedScreen) {
    Provider.of<CurrScreenProvider>(context, listen: false)
        .setCurrScreen(selectedScreen);
  }

  @override
  Widget build(BuildContext context) {
    final currScreen = Provider.of<CurrScreenProvider>(context).getCurrScreen;
    String title = 'CHATS';
    Color textColor = Colors.white30;
    Color barColor = Theme.of(context).primaryColor;

    if (screenButton == common.eSCREEN.SCREEN_STATUS) {
      title = 'STATUS';
    } else if (screenButton == common.eSCREEN.SCREEN_CALLS) {
      title = 'CALLS';
    }

    if (screenButton == currScreen) {
      textColor = Colors.white;
      barColor = Colors.white70;
    }

    return Expanded(
      child: Column(
        children: <Widget>[
          FlatButton(
            child: Text(title, style: TextStyle(color: textColor)),
            onPressed: () => stateChanged(context, screenButton),
            padding: const EdgeInsets.all(0),
          ),
          Container(
            height: 4,
            color: barColor,
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
          ),
        ],
      ),
    );
  }
}
