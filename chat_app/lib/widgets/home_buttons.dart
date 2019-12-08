import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/curr_screen_provider.dart';
import '../helpers/common.dart' as common;

FlatButton _createFlatButtons(common.eSCREEN currScreen,
    common.eSCREEN selectedScreen, Function onPress) {
  String title = 'CHATS';
  Color textColor = Colors.white30;

  if (selectedScreen == common.eSCREEN.SCREEN_STATUS) {
    title = 'STATUS';
  } else if (selectedScreen == common.eSCREEN.SCREEN_CALLS) {
    title = 'CALLS';
  }

  if (selectedScreen == currScreen) {
    textColor = Colors.white;
  }

  return FlatButton(
    child: Text(title, style: TextStyle(color: textColor)),
    onPressed: onPress,
  );
}

class HomeButtons extends StatelessWidget {
  void handleChnageInState(
      BuildContext context, common.eSCREEN selectedScreen) {
    Provider.of<CurrScreenProvider>(context).setCurrScreen(selectedScreen);
  }

  @override
  Widget build(BuildContext context) {
    final currScreen = Provider.of<CurrScreenProvider>(context).getCurrScreen;
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
                child: _createFlatButtons(
                    currScreen,
                    common.eSCREEN.SCREEN_CHATS,
                    () => handleChnageInState(
                        context, common.eSCREEN.SCREEN_CHATS)),
              ),
              Expanded(
                child: _createFlatButtons(
                    currScreen,
                    common.eSCREEN.SCREEN_STATUS,
                    () => handleChnageInState(
                        context, common.eSCREEN.SCREEN_STATUS)),
              ),
              Expanded(
                child: _createFlatButtons(
                    currScreen,
                    common.eSCREEN.SCREEN_CALLS,
                    () => handleChnageInState(
                        context, common.eSCREEN.SCREEN_CALLS)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
