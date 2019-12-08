import 'package:flutter/material.dart';

import '../helpers/common.dart';

class CurrScreenProvider extends ChangeNotifier {
  eSCREEN _currScreen = eSCREEN.SCREEN_CHATS;

  eSCREEN get getCurrScreen {
    eSCREEN val = _currScreen;
    return val;
  }

  void setCurrScreen(eSCREEN currScreen) {
    _currScreen = currScreen;
    notifyListeners();
  }
}
